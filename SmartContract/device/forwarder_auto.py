import serial
import json
import requests
import time
import serial.tools.list_ports
import argparse
import sys

# Flask API configuration - UPDATED FOR VPS
FLASK_URL = "http://173.249.48.25:8000/api/sensors"  # VPS URL
API_KEY = "MY_API_KEY"  # Must match API_KEY on VPS
BAUD = 9600

def find_arduino_port():
    """Tự động tìm COM port của Arduino"""
    # Danh sách các VID/PID phổ biến của Arduino
    arduino_vid_pids = [
        (0x2341, 0x0043),  # Arduino Uno
        (0x2341, 0x0001),  # Arduino Uno
        (0x2A03, 0x0043),  # Arduino Uno (clone)
        (0x2341, 0x0243),  # Arduino Mega
        (0x2A03, 0x0010),  # Arduino Mega (clone)
        (0x1A86, 0x7523),  # CH340 (Arduino clone)
        (0x10C4, 0xEA60),  # CP210x (Arduino clone)
    ]
    
    ports = serial.tools.list_ports.comports()
    
    for port in ports:
        # Kiểm tra theo VID/PID
        if (port.vid, port.pid) in arduino_vid_pids:
            print(f"✅ Found Arduino at {port.device} (VID: {port.vid:04X}, PID: {port.pid:04X})")
            return port.device
        
        # Kiểm tra theo mô tả (description)
        desc_lower = (port.description or "").lower()
        if any(keyword in desc_lower for keyword in ['arduino', 'ch340', 'cp210', 'usb serial']):
            print(f"✅ Found Arduino at {port.device} ({port.description})")
            return port.device
    
    # Nếu không tìm thấy, thử tất cả các port COM
    print("⚠️  Không tìm thấy Arduino theo VID/PID, đang thử tất cả COM ports...")
    for port in ports:
        try:
            ser = serial.Serial(port.device, BAUD, timeout=1)
            time.sleep(2)  # Đợi Arduino reset
            test_line = ser.readline().decode(errors="ignore").strip()
            if test_line and ('{' in test_line or '"time"' in test_line):
                print(f"✅ Found Arduino at {port.device} (detected by data)")
                ser.close()
                return port.device
            ser.close()
        except:
            continue
    
    return None

def main():
    # Declare global variables first (before using them)
    global FLASK_URL, API_KEY
    
    # Parse command line arguments
    parser = argparse.ArgumentParser(description='Smart Farm Arduino Forwarder')
    parser.add_argument('--port', type=str, help='Serial port (e.g., COM4, /dev/ttyUSB0)')
    parser.add_argument('--flask-url', type=str, default=FLASK_URL, help='Flask API URL')
    parser.add_argument('--api-key', type=str, default=API_KEY, help='API Key')
    args = parser.parse_args()
    
    # Use provided Flask URL and API key if specified
    if args.flask_url:
        FLASK_URL = args.flask_url
    if args.api_key:
        API_KEY = args.api_key
    
    print("=" * 60)
    print("🔌 Smart Farm Arduino Forwarder - Auto Port Detection")
    print("=" * 60)
    
    # Tự động tìm port hoặc dùng port được chỉ định
    if args.port:
        port = args.port
        print(f"📌 Using specified port: {port}")
    else:
        port = find_arduino_port()
    
    if not port:
        print("❌ Không tìm thấy Arduino!")
        print("   Hãy kiểm tra:")
        print("   1. Arduino đã được cắm USB chưa?")
        print("   2. Driver USB đã được cài đặt chưa?")
        print("   3. Thử chạy lại script sau khi cắm USB")
        # Chỉ dừng để input trên Windows (có stdin tương tác)
        if sys.stdin.isatty() and sys.platform == 'win32':
            input("\nNhấn Enter để thoát...")
        sys.exit(1)
    
    print(f"\n🚀 Đang kết nối với {port}...")
    
    try:
        # Initialize serial connection
        ser = serial.Serial(port, BAUD, timeout=1)
        time.sleep(2)  # Đợi Arduino reset
        print(f"✅ Connected to {port} at {BAUD} baud")
        print(f"📡 Sending data to: {FLASK_URL}")
        print("=" * 60)
        print("📊 Đang đợi dữ liệu từ Arduino...\n")
        
        while True:
            try:
                # Read line from Arduino
                line = ser.readline().decode(errors="ignore").strip()
                
                if not line:
                    continue
                
                # Sửa dòng JSON bị thiếu ký tự đầu
                if not line.startswith("{"):
                    if line.startswith('ime":'):
                        line = '{"time":' + line[5:]
                    elif line.startswith('"time":'):
                        line = "{" + line
                    elif '"' in line:
                        line = "{" + line
                    else:
                        continue
                
                print(f"📥 Received: {line[:80]}...")
                
                # Parse JSON from Arduino
                try:
                    payload = json.loads(line)
                except json.JSONDecodeError:
                    if not line.endswith("}"):
                        line = line + "}"
                    try:
                        payload = json.loads(line)
                    except json.JSONDecodeError as e:
                        print(f"❌ JSON decode error: {e}")
                        continue
                
                # Debug: Kiểm tra soil_pct và light_pct
                print(f"📊 Parsed payload keys: {list(payload.keys())}")
                if "soil_pct" in payload:
                    print(f"   ✅ soil_pct: {payload['soil_pct']}")
                else:
                    print(f"   ❌ soil_pct: MISSING (có soil_raw: {'soil_raw' in payload})")
                if "light_pct" in payload:
                    print(f"   ✅ light_pct: {payload['light_pct']}")
                else:
                    print(f"   ❌ light_pct: MISSING (có light_raw: {'light_raw' in payload}, có light: {'light' in payload})")
                
                # Send to Flask API
                headers = {
                    "Content-Type": "application/json",
                    "x-api-key": API_KEY
                }
                
                # Tăng timeout lên 30 giây và thêm retry
                max_retries = 3
                success = False
                for attempt in range(max_retries):
                    try:
                        response = requests.post(
                            FLASK_URL, 
                            json=payload, 
                            headers=headers, 
                            timeout=30
                        )
                        if response.status_code == 200:
                            print(f"✅ Sent successfully: {response.status_code}")
                            success = True
                        else:
                            print(f"⚠️  Response: {response.status_code} - {response.text[:100]}")
                        break
                    except requests.exceptions.Timeout:
                        if attempt < max_retries - 1:
                            print(f"⏳ Timeout, retrying... ({attempt + 1}/{max_retries})")
                            time.sleep(2)
                        else:
                            print(f"❌ Timeout after {max_retries} attempts")
                    except requests.exceptions.RequestException as e:
                        print(f"❌ Request error: {e}")
                        break
                
            except json.JSONDecodeError as e:
                print(f"❌ JSON decode error: {e}")
            except requests.exceptions.RequestException as e:
                print(f"❌ Request error: {e}")
            except Exception as e:
                print(f"❌ Unexpected error: {e}")
                
            time.sleep(0.5)  # Small delay between reads
            
    except serial.SerialException as e:
        print(f"❌ Serial connection error: {e}")
        print("   Hãy kiểm tra Arduino đã được cắm và port đúng chưa")
        input("\nNhấn Enter để thoát...")
    except KeyboardInterrupt:
        print("\n\n🛑 Đã dừng bởi người dùng")
        if 'ser' in locals():
            ser.close()
        print("✅ Đã đóng kết nối serial")

if __name__ == "__main__":
    main()


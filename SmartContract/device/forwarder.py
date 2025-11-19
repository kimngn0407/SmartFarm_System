import serial
import json
import requests
import time

# Serial port configuration - CHANGE PORT if needed
PORT = "COM4"  # Windows: COM3, COM4, COM5... - Check Device Manager
BAUD = 9600

# Flask API configuration - UPDATED FOR VPS
FLASK_URL = "http://173.249.48.25:8000/api/sensors"  # VPS URL
API_KEY = "MY_API_KEY"  # Must match API_KEY on VPS

def main():
    try:
        # Initialize serial connection
        ser = serial.Serial(PORT, BAUD, timeout=1)
        print(f"Connected to {PORT} at {BAUD} baud")
        
        while True:
            try:
                # Read line from Arduino
                line = ser.readline().decode(errors="ignore").strip()
                
                if not line:
                    continue
                
                # Sửa dòng JSON bị thiếu ký tự đầu (ví dụ: ime":175... -> {"time":175...)
                if not line.startswith("{"):
                    # Kiểm tra các trường hợp thiếu ký tự
                    if line.startswith('ime":'):  # Thiếu {"t
                        line = '{"time":' + line[5:]  # Bỏ "ime": và thêm {"time":
                    elif line.startswith('"time":'):  # Chỉ thiếu {
                        line = "{" + line
                    elif '"' in line:  # Có dấu " nhưng không bắt đầu bằng {
                        line = "{" + line
                    else:
                        # Bỏ qua dòng không hợp lệ
                        continue
                
                print(f"Received: {line}")
                
                # Parse JSON from Arduino
                try:
                    payload = json.loads(line)
                except json.JSONDecodeError:
                    # Thử sửa JSON nếu thiếu dấu đóng }
                    if not line.endswith("}"):
                        line = line + "}"
                    try:
                        payload = json.loads(line)
                    except json.JSONDecodeError as e:
                        print(f"JSON decode error: {e} - Line: {line[:50]}...")
                        continue
                
                # Send to Flask API
                headers = {
                    "Content-Type": "application/json",
                    "x-api-key": API_KEY
                }
                
                # Tăng timeout lên 30 giây và thêm retry
                max_retries = 3
                for attempt in range(max_retries):
                    try:
                        response = requests.post(
                            FLASK_URL, 
                            json=payload, 
                            headers=headers, 
                            timeout=30  # Tăng timeout lên 30 giây
                        )
                        print(f"Response: {response.status_code} - {response.text[:100]}")
                        break  # Thành công, thoát khỏi retry loop
                    except requests.exceptions.Timeout:
                        if attempt < max_retries - 1:
                            print(f"Request timeout, retrying... ({attempt + 1}/{max_retries})")
                            time.sleep(2)
                        else:
                            print(f"Request error: Timeout after {max_retries} attempts")
                    except requests.exceptions.RequestException as e:
                        print(f"Request error: {e}")
                        break  # Lỗi khác, không retry
                
            except json.JSONDecodeError as e:
                print(f"JSON decode error: {e}")
            except requests.exceptions.RequestException as e:
                print(f"Request error: {e}")
            except Exception as e:
                print(f"Unexpected error: {e}")
                
            time.sleep(1)  # Small delay between reads
            
    except serial.SerialException as e:
        print(f"Serial connection error: {e}")
        print("Make sure Arduino is connected and port is correct")

if __name__ == "__main__":
    main()


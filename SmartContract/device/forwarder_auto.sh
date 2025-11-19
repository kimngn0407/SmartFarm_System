#!/bin/bash
# Smart Farm Arduino Forwarder - Auto Start Script for Linux/VPS
# Tự động phát hiện và kết nối với Arduino qua USB

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Flask API configuration
FLASK_URL="http://173.249.48.25:8000/api/sensors"
API_KEY="MY_API_KEY"
BAUD=9600

# Python executable (adjust if needed)
PYTHON_CMD="python3"
if ! command -v python3 &> /dev/null; then
    PYTHON_CMD="python"
fi

# Virtual environment (if exists)
if [ -d "venv" ]; then
    source venv/bin/activate
fi

echo "============================================================"
echo "  Smart Farm Arduino Forwarder - Auto Start (Linux/VPS)"
echo "============================================================"
echo ""

# Function to find Arduino port
find_arduino_port() {
    # Check if Arduino is connected via USB
    for port in /dev/ttyUSB* /dev/ttyACM*; do
        if [ -e "$port" ]; then
            echo "✅ Found potential Arduino at $port"
            # Try to open and test
            if timeout 2 $PYTHON_CMD -c "import serial; s=serial.Serial('$port', $BAUD, timeout=1); import time; time.sleep(2); print('OK')" 2>/dev/null; then
                echo "✅ Confirmed Arduino at $port"
                echo "$port"
                return 0
            fi
        fi
    done
    
    echo "❌ No Arduino found"
    return 1
}

# Main loop
while true; do
    PORT=$(find_arduino_port)
    
    if [ -n "$PORT" ]; then
        echo ""
        echo "🚀 Starting forwarder for $PORT..."
        echo "📡 Sending data to: $FLASK_URL"
        echo "============================================================"
        echo ""
        
        # Run forwarder with auto port detection
        $PYTHON_CMD forwarder_auto.py --port "$PORT" || {
            echo "❌ Forwarder stopped. Waiting 5 seconds before retry..."
            sleep 5
        }
    else
        echo "⏳ Waiting for Arduino to be connected..."
        sleep 5
    fi
done


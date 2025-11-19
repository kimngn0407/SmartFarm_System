# 🐧 Hướng dẫn Tự động Chạy Arduino Forwarder trên VPS (Linux)

## 📋 Tổng quan

Trên VPS Linux, bạn có thể tự động chạy Arduino forwarder bằng:
1. **Systemd Service** - Tự động chạy khi boot và tự động restart
2. **udev Rules** - Tự động chạy khi cắm USB Arduino
3. **Shell Script với Auto-Retry** - Tự động tìm và kết nối Arduino

---

## 🎯 Cách 1: Systemd Service (Khuyến nghị)

### Bước 1: Copy service file

```bash
cd ~/projects/SmartFarm/SmartContract/device
sudo cp arduino-forwarder.service /etc/systemd/system/
```

### Bước 2: Chỉnh sửa service file (nếu cần)

```bash
sudo nano /etc/systemd/system/arduino-forwarder.service
```

**Chỉnh các thông tin:**
- `WorkingDirectory`: Đường dẫn đến thư mục `device`
- `ExecStart`: Đường dẫn đến Python và script
- `User`: User chạy service (thường là `root` hoặc user của bạn)
- `Environment`: Các biến môi trường (FLASK_URL, API_KEY)

### Bước 3: Reload systemd và enable service

```bash
sudo systemctl daemon-reload
sudo systemctl enable arduino-forwarder.service
sudo systemctl start arduino-forwarder.service
```

### Bước 4: Kiểm tra status

```bash
# Xem status
sudo systemctl status arduino-forwarder.service

# Xem logs
sudo journalctl -u arduino-forwarder.service -f

# Restart service
sudo systemctl restart arduino-forwarder.service

# Stop service
sudo systemctl stop arduino-forwarder.service
```

---

## 🔌 Cách 2: Tự động Chạy Khi Cắm USB (udev Rules)

### Bước 1: Copy udev rule

```bash
cd ~/projects/SmartFarm/SmartContract/device
sudo cp 99-arduino-forwarder.rules /etc/udev/rules.d/
```

### Bước 2: Reload udev rules

```bash
sudo udevadm control --reload-rules
sudo udevadm trigger
```

### Bước 3: Test

1. Rút USB Arduino (nếu đang cắm)
2. Cắm lại USB Arduino
3. Kiểm tra service đã tự động start chưa:
   ```bash
   sudo systemctl status arduino-forwarder.service
   ```

### Bước 4: Xem logs khi cắm USB

```bash
# Monitor udev events
sudo udevadm monitor --property

# Xem service logs
sudo journalctl -u arduino-forwarder.service -f
```

---

## 🔄 Cách 3: Shell Script với Auto-Retry

### Bước 1: Tạo script executable

```bash
cd ~/projects/SmartFarm/SmartContract/device
chmod +x forwarder_auto.sh
```

### Bước 2: Chạy script

```bash
# Chạy trực tiếp
./forwarder_auto.sh

# Hoặc chạy trong background
nohup ./forwarder_auto.sh > forwarder.log 2>&1 &
```

### Bước 3: Tạo systemd service từ script (tùy chọn)

Tạo file `/etc/systemd/system/arduino-forwarder-script.service`:

```ini
[Unit]
Description=Smart Farm Arduino Forwarder (Script)
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/root/projects/SmartFarm/SmartContract/device
ExecStart=/root/projects/SmartFarm/SmartContract/device/forwarder_auto.sh
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
```

Sau đó:
```bash
sudo systemctl daemon-reload
sudo systemctl enable arduino-forwarder-script.service
sudo systemctl start arduino-forwarder-script.service
```

---

## 🛠️ Cài đặt Dependencies trên VPS

### Bước 1: Cài Python và pip

```bash
# Ubuntu/Debian
sudo apt update
sudo apt install python3 python3-pip python3-venv

# CentOS/RHEL
sudo yum install python3 python3-pip
```

### Bước 2: Cài pyserial

```bash
# System-wide
sudo pip3 install pyserial requests

# Hoặc trong virtual environment
cd ~/projects/SmartFarm/SmartContract/device
python3 -m venv venv
source venv/bin/activate
pip install pyserial requests
```

### Bước 3: Cài USB drivers (nếu cần)

```bash
# Ubuntu/Debian
sudo apt install usbutils

# Kiểm tra USB devices
lsusb
dmesg | grep tty
```

### Bước 4: Cấp quyền truy cập USB

```bash
# Thêm user vào dialout group (cho serial ports)
sudo usermod -a -G dialout $USER

# Hoặc cấp quyền 666 cho tty devices (tạm thời)
sudo chmod 666 /dev/ttyUSB* /dev/ttyACM*
```

---

## 📝 Cấu hình Flask API trên VPS

### Kiểm tra Flask API đang chạy

```bash
# Kiểm tra process
ps aux | grep flask
ps aux | grep app.py

# Kiểm tra port 8000
netstat -tulpn | grep 8000
# hoặc
ss -tulpn | grep 8000
```

### Chạy Flask API (nếu chưa chạy)

```bash
cd ~/projects/SmartFarm/SmartContract/flask-api

# Tạo virtual environment
python3 -m venv venv
source venv/bin/activate

# Cài dependencies
pip install -r requirements.txt

# Chạy Flask API
python app.py

# Hoặc chạy trong background
nohup python app.py > flask.log 2>&1 &
```

### Tạo systemd service cho Flask API (tùy chọn)

Tạo `/etc/systemd/system/flask-api.service`:

```ini
[Unit]
Description=Smart Farm Flask API
After=network.target postgresql.service

[Service]
Type=simple
User=root
WorkingDirectory=/root/projects/SmartFarm/SmartContract/flask-api
Environment="PATH=/root/projects/SmartFarm/SmartContract/flask-api/venv/bin"
ExecStart=/root/projects/SmartFarm/SmartContract/flask-api/venv/bin/python app.py
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
```

Sau đó:
```bash
sudo systemctl daemon-reload
sudo systemctl enable flask-api.service
sudo systemctl start flask-api.service
```

---

## 🔍 Troubleshooting

### Không tìm thấy Arduino?

```bash
# Kiểm tra USB devices
lsusb

# Kiểm tra serial ports
ls -l /dev/ttyUSB* /dev/ttyACM*

# Kiểm tra dmesg logs
dmesg | tail -20
```

### Permission denied?

```bash
# Thêm user vào dialout group
sudo usermod -a -G dialout $USER

# Logout và login lại, hoặc:
newgrp dialout

# Hoặc cấp quyền tạm thời
sudo chmod 666 /dev/ttyUSB* /dev/ttyACM*
```

### Service không start?

```bash
# Xem logs chi tiết
sudo journalctl -u arduino-forwarder.service -n 50

# Kiểm tra syntax của service file
sudo systemd-analyze verify /etc/systemd/system/arduino-forwarder.service

# Test chạy thủ công
cd ~/projects/SmartFarm/SmartContract/device
python3 forwarder_auto.py
```

### Không gửi được data lên Flask API?

```bash
# Test kết nối đến Flask API
curl -X POST http://173.249.48.25:8000/api/sensors \
  -H "Content-Type: application/json" \
  -H "x-api-key: MY_API_KEY" \
  -d '{"sensorId":7,"time":1730000000,"temperature":25.5}'

# Kiểm tra firewall
sudo ufw status
sudo iptables -L -n
```

### udev rule không hoạt động?

```bash
# Test udev rule
sudo udevadm test /sys/class/tty/ttyUSB0

# Xem udev logs
sudo journalctl -u systemd-udevd -f

# Kiểm tra rule đã được load chưa
sudo udevadm control --reload-rules
sudo udevadm trigger
```

---

## ✅ Checklist Setup VPS

- [ ] Cài Python 3 và pip
- [ ] Cài pyserial và requests
- [ ] Cấp quyền truy cập USB (dialout group)
- [ ] Copy và cấu hình systemd service
- [ ] Enable và start service
- [ ] Copy udev rules (nếu muốn auto-start khi cắm USB)
- [ ] Kiểm tra Flask API đang chạy
- [ ] Test kết nối Arduino
- [ ] Kiểm tra logs

---

## 📌 Lưu ý

1. **Port có thể thay đổi**: `/dev/ttyUSB0` có thể thành `/dev/ttyUSB1` nếu cắm lại
2. **User permissions**: Đảm bảo user có quyền truy cập serial ports
3. **Flask API phải chạy**: Forwarder cần Flask API để gửi data
4. **Network**: Đảm bảo VPS có kết nối internet để gửi data
5. **Logs**: Luôn kiểm tra logs khi có vấn đề

---

## 🚀 Quick Start (Tóm tắt)

```bash
# 1. Cài dependencies
sudo apt install python3 python3-pip python3-venv
sudo pip3 install pyserial requests

# 2. Cấp quyền USB
sudo usermod -a -G dialout $USER
newgrp dialout

# 3. Setup systemd service
cd ~/projects/SmartFarm/SmartContract/device
sudo cp arduino-forwarder.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable arduino-forwarder.service
sudo systemctl start arduino-forwarder.service

# 4. Setup udev rules (tùy chọn)
sudo cp 99-arduino-forwarder.rules /etc/udev/rules.d/
sudo udevadm control --reload-rules
sudo udevadm trigger

# 5. Kiểm tra
sudo systemctl status arduino-forwarder.service
sudo journalctl -u arduino-forwarder.service -f
```


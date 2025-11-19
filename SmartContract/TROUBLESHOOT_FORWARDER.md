# 🔧 Troubleshooting Arduino Forwarder

## ❌ Vấn đề: Arduino Forwarder không chạy

**Dấu hiệu:**
- Status trống (không có "online")
- Đã restart nhiều lần (↺ 2, 3, ...)
- Memory = 0b

## 🔍 Kiểm tra Logs

```bash
# Xem logs chi tiết
pm2 logs arduino-forwarder --lines 50

# Xem logs real-time
pm2 logs arduino-forwarder -f

# Xem error logs
pm2 logs arduino-forwarder --err --lines 50
```

## 🐛 Các nguyên nhân thường gặp:

### 1. Không tìm thấy Arduino (USB chưa cắm hoặc không được nhận diện)

**Logs sẽ hiển thị:**
```
❌ Không tìm thấy Arduino!
   Hãy kiểm tra:
   1. Arduino đã được cắm USB chưa?
   2. Driver USB đã được cài đặt chưa?
```

**Giải pháp:**
```bash
# Kiểm tra USB devices
lsusb
ls -l /dev/ttyUSB* /dev/ttyACM*

# Nếu không có device, cắm lại USB Arduino

# Kiểm tra quyền
groups | grep dialout
# Nếu không có, chạy:
sudo usermod -a -G dialout $USER
newgrp dialout
```

### 2. Thiếu Python dependencies

**Logs sẽ hiển thị:**
```
ModuleNotFoundError: No module named 'serial'
# hoặc
ModuleNotFoundError: No module named 'requests'
```

**Giải pháp:**
```bash
cd ~/projects/SmartFarm/SmartContract/device

# Kích hoạt virtual environment
source venv/bin/activate

# Cài dependencies
pip install pyserial requests

# Deactivate
deactivate
```

### 3. Sai đường dẫn trong ecosystem config

**Logs sẽ hiển thị:**
```
FileNotFoundError: [Errno 2] No such file or directory: 'forwarder_auto.py'
```

**Giải pháp:**
```bash
cd ~/projects/SmartFarm/SmartContract/device

# Kiểm tra file tồn tại
ls -la forwarder_auto.py

# Kiểm tra và chỉnh sửa ecosystem.config.cjs
nano ecosystem.config.cjs
# Đảm bảo "cwd" đúng: "/root/projects/SmartFarm/SmartContract/device"
```

### 4. API_KEY không khớp hoặc Flask API không chạy

**Logs sẽ hiển thị:**
```
Request error: Connection refused
# hoặc
Request error: 401 Unauthorized
```

**Giải pháp:**
```bash
# Kiểm tra Flask API đang chạy
pm2 status flask-api

# Kiểm tra API_KEY
cat device/ecosystem.config.cjs | grep API_KEY
cat flask-api/.env | grep API_KEY
# Phải giống nhau!

# Test Flask API
curl http://localhost:8000/api/sensors/latest
```

### 5. Python interpreter không đúng

**Logs sẽ hiển thị:**
```
/usr/bin/python3: No such file or directory
```

**Giải pháp:**
```bash
# Tìm Python path
which python3
# hoặc
which python

# Chỉnh sửa ecosystem.config.cjs
nano ecosystem.config.cjs
# Thay "python3" bằng đường dẫn đầy đủ, ví dụ: "/usr/bin/python3"
```

---

## ✅ Fix nhanh (Step by step)

```bash
# 1. Xem logs để biết lỗi cụ thể
pm2 logs arduino-forwarder --lines 50

# 2. Kiểm tra Arduino đã cắm chưa
lsusb
ls -l /dev/ttyUSB* /dev/ttyACM*

# 3. Kiểm tra Python dependencies
cd ~/projects/SmartFarm/SmartContract/device
source venv/bin/activate
pip list | grep -E "pyserial|requests"
deactivate

# 4. Kiểm tra config
cat ecosystem.config.cjs | grep -E "cwd|interpreter|FLASK_URL|API_KEY"

# 5. Restart forwarder
pm2 restart arduino-forwarder

# 6. Xem logs real-time
pm2 logs arduino-forwarder -f
```

---

## 🎯 Test thủ công (không qua PM2)

```bash
cd ~/projects/SmartFarm/SmartContract/device

# Kích hoạt venv
source venv/bin/activate

# Chạy thủ công để xem lỗi
python3 forwarder_auto.py

# Nếu chạy được, có nghĩa là vấn đề ở PM2 config
# Nếu không chạy được, xem lỗi và fix
```

---

## 📝 Checklist

- [ ] Arduino đã cắm USB
- [ ] USB device được nhận diện (`lsusb`, `ls /dev/ttyUSB*`)
- [ ] User có quyền truy cập USB (`groups | grep dialout`)
- [ ] Python dependencies đã cài (`pip list | grep pyserial`)
- [ ] ecosystem.config.cjs có đường dẫn đúng
- [ ] API_KEY khớp giữa forwarder và Flask API
- [ ] Flask API đang chạy (`pm2 status flask-api`)
- [ ] Python interpreter đúng (`which python3`)

---

## 🔄 Restart hoàn toàn

Nếu vẫn không được, restart hoàn toàn:

```bash
# 1. Stop và delete
pm2 stop arduino-forwarder
pm2 delete arduino-forwarder

# 2. Kiểm tra và fix tất cả issues ở trên

# 3. Start lại
cd ~/projects/SmartFarm/SmartContract/device
pm2 start ecosystem.config.cjs

# 4. Save
pm2 save

# 5. Kiểm tra
pm2 status
pm2 logs arduino-forwarder --lines 20
```


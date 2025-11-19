# 🔍 Hướng dẫn Kiểm tra SmartContract Services trên VPS

## 📋 Tổng quan

Các service SmartContract trên VPS bao gồm:
1. **Flask API** (port 8000) - Nhận data từ Arduino và lưu vào PostgreSQL
2. **Oracle Node** (port 5001) - Push hash lên blockchain (PioneChain)
3. **Arduino Forwarder** - Đọc data từ Arduino và gửi lên Flask API

---

## 🚀 Cách kiểm tra nhanh

### Với PM2 (Nếu đã dùng PM2):

```bash
cd ~/projects/SmartFarm/SmartContract

# Chạy script kiểm tra
chmod +x check_services_pm2.sh
./check_services_pm2.sh

# Hoặc kiểm tra thủ công
pm2 status
pm2 logs
pm2 monit
```

### Kiểm tra tổng quát:

```bash
cd ~/projects/SmartFarm/SmartContract

# Chạy script kiểm tra đầy đủ
chmod +x check_services.sh
./check_services.sh
```

---

## 🔧 Kiểm tra thủ công

### 1. Kiểm tra PM2 Processes

```bash
# Xem tất cả processes
pm2 list

# Xem chi tiết một process
pm2 info arduino-forwarder
pm2 info flask-api
pm2 info oracle-node

# Xem logs
pm2 logs arduino-forwarder
pm2 logs flask-api
pm2 logs oracle-node

# Xem logs real-time
pm2 logs --lines 50
```

### 2. Kiểm tra Systemd Services

```bash
# Kiểm tra status
sudo systemctl status arduino-forwarder.service
sudo systemctl status flask-api.service
sudo systemctl status oracle-node.service

# Xem logs
sudo journalctl -u arduino-forwarder.service -f
sudo journalctl -u flask-api.service -f
sudo journalctl -u oracle-node.service -f
```

### 3. Kiểm tra Ports đang listen

```bash
# Kiểm tra port 8000 (Flask API)
netstat -tuln | grep 8000
# hoặc
ss -tuln | grep 8000
# hoặc
lsof -i :8000

# Kiểm tra port 5001 (Oracle Node)
netstat -tuln | grep 5001
ss -tuln | grep 5001
lsof -i :5001
```

### 4. Kiểm tra Processes đang chạy

```bash
# Tìm Flask API process
ps aux | grep "python.*app.py"
ps aux | grep flask

# Tìm Oracle Node process
ps aux | grep "node.*server.js"
ps aux | grep oracle

# Tìm Arduino Forwarder process
ps aux | grep "python.*forwarder"
ps aux | grep forwarder
```

### 5. Health Check - Test API Endpoints

```bash
# Test Flask API
curl http://localhost:8000/api/sensors/latest
# hoặc
curl -X POST http://localhost:8000/api/sensors \
  -H "Content-Type: application/json" \
  -H "x-api-key: MY_API_KEY" \
  -d '{"sensorId":7,"time":1730000000,"temperature":25.5}'

# Test Oracle Node
curl http://localhost:5001/oracle/health

# Test Backend API (nếu có)
curl http://localhost:8080/actuator/health
```

### 6. Kiểm tra Database Connection

```bash
# Kiểm tra .env file
cat flask-api/.env | grep DB_URL

# Test connection (nếu có psql)
psql $DB_URL -c "SELECT COUNT(*) FROM sensor_data;"
```

### 7. Kiểm tra USB/Serial Devices

```bash
# Xem USB devices
lsusb

# Xem serial ports
ls -l /dev/ttyUSB* /dev/ttyACM*

# Xem dmesg logs
dmesg | grep -i usb | tail -20
```

---

## 📊 Checklist Kiểm tra

### ✅ Services đang chạy:
- [ ] Arduino Forwarder (PM2 hoặc systemd)
- [ ] Flask API (port 8000)
- [ ] Oracle Node (port 5001)

### ✅ Ports đang listen:
- [ ] Port 8000 (Flask API)
- [ ] Port 5001 (Oracle Node)
- [ ] Port 8080 (Backend API - nếu có)

### ✅ Health Checks:
- [ ] Flask API endpoint trả về 200 hoặc 401
- [ ] Oracle Node health check trả về `{"ok": true}`
- [ ] Backend API health check trả về `{"status": "UP"}`

### ✅ Database:
- [ ] PostgreSQL đang chạy
- [ ] Connection string đúng trong .env
- [ ] Có thể query sensor_data table

### ✅ USB/Serial:
- [ ] Arduino được nhận diện (`/dev/ttyUSB*` hoặc `/dev/ttyACM*`)
- [ ] User có quyền truy cập serial port

---

## 🐛 Troubleshooting

### Service không chạy?

```bash
# Với PM2
pm2 restart arduino-forwarder
pm2 logs arduino-forwarder --lines 50

# Với systemd
sudo systemctl restart arduino-forwarder.service
sudo journalctl -u arduino-forwarder.service -n 50
```

### Port không listen?

```bash
# Kiểm tra firewall
sudo ufw status
sudo iptables -L -n

# Kiểm tra process đang dùng port
sudo lsof -i :8000
sudo lsof -i :5001
```

### API không response?

```bash
# Test localhost
curl http://localhost:8000/api/sensors/latest

# Test từ bên ngoài (nếu có public IP)
curl http://173.249.48.25:8000/api/sensors/latest

# Kiểm tra logs
pm2 logs flask-api
# hoặc
sudo journalctl -u flask-api.service -f
```

### Arduino không kết nối?

```bash
# Kiểm tra USB device
lsusb
ls -l /dev/ttyUSB* /dev/ttyACM*

# Kiểm tra quyền
groups | grep dialout
sudo chmod 666 /dev/ttyUSB0  # Thay ttyUSB0 bằng port của bạn

# Test serial connection
python3 -c "import serial; s=serial.Serial('/dev/ttyUSB0', 9600); print(s.readline())"
```

---

## 📝 Ghi chú

- **PM2**: Dễ quản lý, có web interface (`pm2 web`)
- **Systemd**: Tích hợp sâu với Linux, tự động chạy khi boot
- **Ports**: Đảm bảo firewall cho phép các port cần thiết
- **Logs**: Luôn kiểm tra logs khi có vấn đề

---

## 🔗 Liên kết

- [PM2 Documentation](https://pm2.keymetrics.io/docs/usage/quick-start/)
- [Systemd Service Guide](https://www.freedesktop.org/software/systemd/man/systemd.service.html)
- [Flask API Documentation](flask-api/README.md)
- [Oracle Node Documentation](oracle-node/README.md)


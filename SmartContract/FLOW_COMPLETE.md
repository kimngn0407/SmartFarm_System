# 🔄 Flow Tự động Hoàn chỉnh: Arduino → Database → PioneChain

## 📊 Tổng quan Flow

```
┌─────────┐      ┌──────────────┐      ┌──────────┐      ┌─────────────┐      ┌──────────────┐
│ Arduino │ USB  │   Forwarder  │ HTTP │ Flask API│ SQL  │ PostgreSQL  │ HTTP │ Oracle Node │
│  (USB)  │─────▶│  (PM2)      │─────▶│ (PM2)    │─────▶│  Database   │─────▶│   (PM2)     │
└─────────┘      └──────────────┘      └──────────┘      └─────────────┘      └──────────────┘
                                                                                      │
                                                                                      │ RPC
                                                                                      ▼
                                                                              ┌──────────────┐
                                                                              │ PioneChain  │
                                                                              │ Blockchain  │
                                                                              └──────────────┘
```

## 🔄 Chi tiết Flow

### 1. Arduino → Forwarder (USB Serial)
- **Arduino** gửi JSON data qua USB Serial (9600 baud)
- **Forwarder** (`forwarder_auto.py`) đọc data từ `/dev/ttyUSB0` hoặc `/dev/ttyACM0`
- Tự động phát hiện port khi cắm USB

### 2. Forwarder → Flask API (HTTP POST)
- **Forwarder** gửi data lên Flask API:
  ```bash
  POST http://173.249.48.25:8000/api/sensors
  Headers: x-api-key: MY_API_KEY
  Body: {
    "sensorId": 7,
    "time": 1730000000,
    "temperature": 25.5,
    "humidity": 60.0,
    "soil_pct": 45,
    "light": 77
  }
  ```

### 3. Flask API → PostgreSQL (SQL INSERT)
- **Flask API** nhận data và lưu vào PostgreSQL:
  - Temperature → `sensor_data` với `sensor_id = 7`
  - Humidity → `sensor_data` với `sensor_id = 8`
  - Soil → `sensor_data` với `sensor_id = 9`
  - Light → `sensor_data` với `sensor_id = 10`

### 4. Flask API → Oracle Node (HTTP POST)
- **Flask API** tính hash (Keccak256) của data
- Gửi hash lên Oracle Node:
  ```bash
  POST http://localhost:5001/oracle/push
  Body: {
    "time": 1730000000,
    "hash": "0xabc123..."
  }
  ```

### 5. Oracle Node → PioneChain (Blockchain Transaction)
- **Oracle Node** nhận hash và push lên blockchain:
  - Gọi smart contract: `storeHash(time, hash)`
  - Transaction được gửi lên PioneChain (RPC: https://rpc.zeroscan.org)
  - Trả về transaction hash

---

## 🚀 Setup Tự động

### Bước 1: Chạy script setup

```bash
cd ~/projects/SmartFarm/SmartContract
chmod +x setup_auto_iot.sh
./setup_auto_iot.sh
```

Script sẽ:
- ✅ Kiểm tra và cài PM2 (nếu chưa có)
- ✅ Cài Python dependencies
- ✅ Cấp quyền USB
- ✅ Start Arduino Forwarder với PM2
- ✅ Setup auto-start khi boot
- ✅ Test tất cả services

### Bước 2: Chỉnh sửa config (nếu cần)

```bash
cd ~/projects/SmartFarm/SmartContract/device
nano ecosystem.config.js
```

Chỉnh:
- `cwd`: Đường dẫn đến thư mục device
- `FLASK_URL`: URL Flask API
- `API_KEY`: API Key (phải khớp với `flask-api/.env`)

### Bước 3: Kiểm tra services

```bash
pm2 status
```

Kết quả mong đợi:
```
┌────┬────────────────────┬──────────┬──────┬───────────┬──────────┬──────────┐
│ id │ name               │ mode     │ ↺    │ status    │ cpu      │ memory   │
├────┼────────────────────┼──────────┼──────┼───────────┼──────────┼──────────┤
│ 0  │ flask-api          │ fork     │ X    │ online    │ 0%       │ XXmb     │
│ 1  │ oracle-node        │ fork     │ X    │ online    │ 0%       │ XXmb     │
│ 2  │ arduino-forwarder  │ fork     │ X    │ online    │ 0%       │ XXmb     │
└────┴────────────────────┴──────────┴──────┴───────────┴──────────┴──────────┘
```

---

## 🔍 Kiểm tra Flow

### 1. Kiểm tra Arduino Forwarder

```bash
# Xem logs
pm2 logs arduino-forwarder --lines 50

# Kết quả mong đợi:
# ✅ Found Arduino at /dev/ttyUSB0
# ✅ Connected to /dev/ttyUSB0 at 9600 baud
# 📥 Received: {"time":1730000000,"temperature":25.5,...}
# ✅ Sent successfully: 200
```

### 2. Kiểm tra Flask API

```bash
# Xem logs
pm2 logs flask-api --lines 50

# Test endpoint
curl http://localhost:8000/api/sensors/latest

# Kết quả mong đợi: JSON với latest sensor data
```

### 3. Kiểm tra Database

```bash
# Kiểm tra data đã được lưu
psql $DB_URL -c "SELECT * FROM sensor_data ORDER BY time DESC LIMIT 10;"
```

### 4. Kiểm tra Oracle Node

```bash
# Xem logs
pm2 logs oracle-node --lines 50

# Health check
curl http://localhost:5001/oracle/health

# Kết quả mong đợi: {"ok":true,"status":"running",...}
```

### 5. Kiểm tra Blockchain

```bash
# Xem transaction trên blockchain
# Truy cập: https://zeroscan.org
# Tìm transaction hash từ Oracle Node logs
```

---

## 🐛 Troubleshooting

### Arduino Forwarder không tìm thấy Arduino?

```bash
# Kiểm tra USB device
lsusb
ls -l /dev/ttyUSB* /dev/ttyACM*

# Kiểm tra quyền
groups | grep dialout
sudo chmod 666 /dev/ttyUSB0  # Thay ttyUSB0 bằng port của bạn

# Restart forwarder
pm2 restart arduino-forwarder
pm2 logs arduino-forwarder
```

### Flask API không nhận được data?

```bash
# Kiểm tra Flask API đang chạy
pm2 status flask-api
curl http://localhost:8000/api/sensors/latest

# Kiểm tra API_KEY
cat flask-api/.env | grep API_KEY
# Phải khớp với device/ecosystem.config.js

# Xem logs
pm2 logs flask-api --lines 50
```

### Oracle Node không push lên blockchain?

```bash
# Kiểm tra Oracle Node
pm2 status oracle-node
curl http://localhost:5001/oracle/health

# Kiểm tra config
cat oracle-node/.env
# PRIVATE_KEY, CONTRACT_ADDRESS, RPC_URL phải đúng

# Xem logs
pm2 logs oracle-node --lines 50
```

### Data không lưu vào database?

```bash
# Kiểm tra database connection
cat flask-api/.env | grep DB_URL

# Test connection
psql $DB_URL -c "SELECT COUNT(*) FROM sensor_data;"

# Kiểm tra sensor IDs
psql $DB_URL -c "SELECT id FROM sensor WHERE id IN (7,8,9,10);"
```

---

## ✅ Checklist

- [ ] PM2 đã được cài đặt
- [ ] Flask API đang chạy (PM2)
- [ ] Oracle Node đang chạy (PM2)
- [ ] Arduino Forwarder đang chạy (PM2)
- [ ] Auto-start khi boot đã setup (`pm2 startup` + `pm2 save`)
- [ ] USB permissions OK (user trong dialout group)
- [ ] API_KEY khớp giữa forwarder và Flask API
- [ ] Database connection OK
- [ ] Oracle Node config OK (PRIVATE_KEY, CONTRACT_ADDRESS, RPC_URL)
- [ ] Test flow hoàn chỉnh: Arduino → DB → Blockchain

---

## 📝 Lưu ý

1. **API_KEY**: Phải giống nhau giữa:
   - `device/ecosystem.config.js` (FLASK_URL, API_KEY)
   - `flask-api/.env` (API_KEY)

2. **Sensor IDs**: Phải có trong database:
   - ID 7: Temperature
   - ID 8: Humidity
   - ID 9: Soil
   - ID 10: Light

3. **Auto-start**: Sau khi setup, services sẽ tự động chạy khi:
   - VPS reboot
   - PM2 restart
   - Service crash (PM2 tự động restart)

4. **USB Auto-detect**: Forwarder tự động tìm Arduino khi:
   - Cắm USB
   - PM2 restart forwarder

---

## 🎯 Kết quả mong đợi

Sau khi setup xong:
1. ✅ Cắm USB Arduino → Forwarder tự động kết nối
2. ✅ Arduino gửi data → Forwarder nhận và gửi lên Flask API
3. ✅ Flask API lưu vào PostgreSQL
4. ✅ Flask API tính hash và gửi lên Oracle Node
5. ✅ Oracle Node push hash lên PioneChain blockchain
6. ✅ Có thể xem transaction trên https://zeroscan.org

**Tất cả tự động, không cần can thiệp thủ công!** 🚀


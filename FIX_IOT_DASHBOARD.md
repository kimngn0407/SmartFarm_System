# 🔧 Fix Dashboard IoT Data - Hướng dẫn chi tiết

## Vấn đề: Dashboard vẫn hiển thị dữ liệu giả lập

## 🔍 Bước 1: Kiểm tra Database

### Trên VPS, chạy:

```bash
# Vào database
docker exec -it smartfarm-postgres psql -U postgres -d SmartFarm1

# 1. Kiểm tra có dữ liệu sensor_data không
SELECT COUNT(*) FROM "Sensor_data";

# 2. Xem dữ liệu mới nhất
SELECT sd.id, sd.value, sd."time", s.type, s."sensor_name" FROM "sensor_data" sd JOIN "sensor" s ON sd.sensor_id = s.id 
ORDER BY sd."time" DESC 
LIMIT 10;

# 3. Kiểm tra sensors có type đúng không
SELECT id, "sensor_name", type, status, farm_id, field_id 
FROM "Sensor" 
WHERE type IN ('Temperature', 'Humidity', 'Soil Moisture', 'Light');

# Thoát
\q
```

### Kết quả mong đợi:
- Có dữ liệu trong `Sensor_data`
- Có sensors với type: `Temperature`, `Humidity`, `Soil Moisture`, `Light`

---

## 🔧 Bước 2: Tạo Sensors nếu chưa có

### Nếu chưa có sensors, chạy script:

```bash
# Trên VPS
cd ~/projects/SmartFarm

# Copy script vào container và chạy
docker exec -i smartfarm-postgres psql -U postgres -d SmartFarm1 < create_test_sensors.sql
```

Hoặc tạo thủ công:

```bash
docker exec -it smartfarm-postgres psql -U postgres -d SmartFarm1

-- Lấy farm_id và field_id đầu tiên
SELECT id FROM "Farm" LIMIT 1;
SELECT id FROM "Field" LIMIT 1;

-- Tạo sensors (thay FARM_ID và FIELD_ID bằng ID thật)
INSERT INTO "Sensor" (farm_id, field_id, "sensor_name", lat, lng, type, status, installation_date)
VALUES 
  (FARM_ID, FIELD_ID, 'Temperature Sensor', 10.0, 106.0, 'Temperature', 'Active', NOW()),
  (FARM_ID, FIELD_ID, 'Humidity Sensor', 10.0, 106.0, 'Humidity', 'Active', NOW()),
  (FARM_ID, FIELD_ID, 'Soil Moisture Sensor', 10.0, 106.0, 'Soil Moisture', 'Active', NOW()),
  (FARM_ID, FIELD_ID, 'Light Sensor', 10.0, 106.0, 'Light', 'Active', NOW());
```

---

## 📤 Bước 3: Gửi dữ liệu test

### Cách 1: Qua Flask API (nếu Flask API đang chạy)

```bash
# Sửa IP trong send_test_data.sh
nano send_test_data.sh

# Chạy script
chmod +x send_test_data.sh
./send_test_data.sh
```

### Cách 2: Gửi trực tiếp qua curl

```bash
# Lấy timestamp hiện tại
TIMESTAMP=$(date +%s)

# Gửi dữ liệu test
curl -X POST http://YOUR_VPS_IP:8000/api/sensors \
  -H "Content-Type: application/json" \
  -H "x-api-key: MY_API_KEY" \
  -d "{
    \"sensorId\": 1,
    \"time\": ${TIMESTAMP},
    \"temperature\": 30.5,
    \"humidity\": 75.0,
    \"soil_pct\": 55.0,
    \"light\": 60.0
  }"
```

### Cách 3: Insert trực tiếp vào database

```bash
docker exec -it smartfarm-postgres psql -U postgres -d SmartFarm1

-- Lấy sensor_id (thay bằng ID thật từ bước 2)
SELECT id FROM "Sensor" WHERE type = 'Temperature' LIMIT 1;

-- Insert dữ liệu test (thay SENSOR_ID bằng ID thật)
INSERT INTO "Sensor_data" (sensor_id, value, "time")
VALUES 
  (SENSOR_ID, 30.5, NOW() - INTERVAL '11 hours'),
  (SENSOR_ID, 31.0, NOW() - INTERVAL '10 hours'),
  (SENSOR_ID, 29.8, NOW() - INTERVAL '9 hours'),
  (SENSOR_ID, 30.2, NOW() - INTERVAL '8 hours'),
  (SENSOR_ID, 31.5, NOW() - INTERVAL '7 hours'),
  (SENSOR_ID, 30.0, NOW() - INTERVAL '6 hours'),
  (SENSOR_ID, 29.5, NOW() - INTERVAL '5 hours'),
  (SENSOR_ID, 30.8, NOW() - INTERVAL '4 hours'),
  (SENSOR_ID, 31.2, NOW() - INTERVAL '3 hours'),
  (SENSOR_ID, 30.5, NOW() - INTERVAL '2 hours'),
  (SENSOR_ID, 30.0, NOW() - INTERVAL '1 hour'),
  (SENSOR_ID, 30.3, NOW());
```

Làm tương tự cho Humidity, Soil Moisture, và Light sensors.

---

## 🧪 Bước 4: Test API Endpoint

```bash
# Test endpoint dashboard
curl http://localhost:8080/api/sensor-data/dashboard

# Hoặc với authentication (nếu cần)
# Lấy token từ login
TOKEN="YOUR_JWT_TOKEN"
curl -H "Authorization: Bearer ${TOKEN}" http://localhost:8080/api/sensor-data/dashboard
```

### Kết quả mong đợi:
```json
{
  "temperature": [...],
  "humidity": [...],
  "soilMoisture": [...],
  "light": [...],
  "avgTemperature": 30.5,
  "avgHumidity": 75.0,
  ...
}
```

---

## 🔍 Bước 5: Kiểm tra Frontend

### 1. Mở browser console (F12)
### 2. Xem Network tab khi load dashboard
### 3. Kiểm tra request đến `/api/sensor-data/dashboard`
### 4. Xem response có dữ liệu không

### Nếu có lỗi CORS hoặc 401:
- Kiểm tra authentication
- Kiểm tra CORS settings trong backend

---

## ✅ Checklist

- [ ] Database có dữ liệu trong `Sensor_data`
- [ ] Có sensors với type đúng: `Temperature`, `Humidity`, `Soil Moisture`, `Light`
- [ ] API endpoint `/api/sensor-data/dashboard` trả về dữ liệu
- [ ] Frontend gọi API thành công (check Network tab)
- [ ] Dashboard hiển thị dữ liệu thật (không phải mock)

---

## 🚨 Troubleshooting

### Nếu API trả về empty:

1. **Kiểm tra type của sensors** - phải chính xác:
   - ✅ `Temperature` (không phải "temperature")
   - ✅ `Humidity` (không phải "humidity")  
   - ✅ `Soil Moisture` (không phải "Soil Moisture" hoặc "soil")
   - ✅ `Light` (không phải "light")

2. **Kiểm tra time range** - API mặc định lấy 12 giờ gần nhất

3. **Kiểm tra logs backend**:
```bash
docker compose logs backend | grep -i "sensor"
```

### Nếu Frontend không gọi API:

1. **Kiểm tra console có lỗi không**
2. **Kiểm tra Network tab** - request có được gửi không
3. **Kiểm tra authentication** - có token không

---

## 📞 Cần hỗ trợ?

Chạy các lệnh kiểm tra và gửi kết quả:
1. `SELECT COUNT(*) FROM "Sensor_data";`
2. `SELECT type FROM "Sensor" WHERE type IN ('Temperature', 'Humidity', 'Soil Moisture', 'Light');`
3. `curl http://localhost:8080/api/sensor-data/dashboard`


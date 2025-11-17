# 🔍 Kiểm tra Dữ liệu IoT trên Dashboard

## Vấn đề: Dashboard vẫn hiển thị dữ liệu giả lập

## ✅ Các bước kiểm tra:

### 1. Kiểm tra Database có dữ liệu không

```bash
# Trên VPS, chạy:
docker exec -it smartfarm-postgres psql -U postgres -d SmartFarm1

# Kiểm tra bảng sensor_data
SELECT COUNT(*) FROM "Sensor_data";

# Xem dữ liệu mới nhất
SELECT * FROM "Sensor_data" ORDER BY "time" DESC LIMIT 10;

# Kiểm tra sensors
SELECT id, "sensor_name", type, status FROM "Sensor" WHERE type IN ('Temperature', 'Humidity', 'Soil Moisture', 'Light');

# Thoát
\q
```

### 2. Kiểm tra API endpoint

```bash
# Test API endpoint mới
curl http://localhost:8080/api/sensor-data/dashboard

# Hoặc với authentication (nếu cần)
curl -H "Authorization: Bearer YOUR_TOKEN" http://localhost:8080/api/sensor-data/dashboard
```

### 3. Kiểm tra Sensors có type đúng không

Sensors cần có type:
- `Temperature` (không phải "temperature")
- `Humidity` (không phải "humidity")
- `Soil Moisture` (không phải "Soil Moisture" hoặc "soil")
- `Light` (không phải "light")

---

## 🔧 Giải pháp

### Nếu chưa có dữ liệu:

1. **Tạo sensors mẫu** (nếu chưa có)
2. **Gửi dữ liệu test** qua Flask API
3. **Kiểm tra lại dashboard**

### Nếu có dữ liệu nhưng không hiển thị:

1. **Kiểm tra type của sensors** - phải đúng chính xác
2. **Kiểm tra API response**
3. **Kiểm tra frontend console** có lỗi không


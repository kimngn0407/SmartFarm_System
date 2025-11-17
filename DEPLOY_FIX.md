# 🔧 Deploy Fix cho Dashboard IoT Data

## ✅ Đã sửa

1. **Sửa queries trong SensorDataRepository** - Dùng native query với tên bảng đúng:
   - `sensor_data` (lowercase) cho bảng sensor_data
   - `"Sensor"` (với quotes) cho bảng Sensor

2. **Sửa SensorDataService** - Bỏ Pageable không cần thiết

## 🚀 Deploy lại

### Trên VPS:

```bash
cd ~/projects/SmartFarm

# Pull code mới
git pull

# Rebuild backend
docker compose build --no-cache backend

# Restart backend
docker compose restart backend

# Xem logs
docker compose logs -f backend
```

### Kiểm tra:

```bash
# Test API endpoint
curl http://localhost:8080/api/sensor-data/dashboard

# Hoặc với authentication
curl -H "Authorization: Bearer YOUR_TOKEN" http://localhost:8080/api/sensor-data/dashboard
```

---

## ✅ Kết quả mong đợi

API sẽ trả về dữ liệu thật từ database:

```json
{
  "temperature": [
    {"time": "2025-11-09T06:49:41", "value": 25.5, "type": "Temperature", ...},
    ...
  ],
  "humidity": [...],
  "soilMoisture": [...],
  "light": [...],
  "avgTemperature": 30.5,
  "avgHumidity": 75.0,
  ...
}
```

---

## 🔍 Nếu vẫn không hoạt động

1. **Kiểm tra logs backend**:
```bash
docker compose logs backend | grep -i "error\|exception"
```

2. **Kiểm tra database có dữ liệu**:
```bash
docker exec -it smartfarm-postgres psql -U postgres -d SmartFarm1 -c "SELECT COUNT(*) FROM sensor_data;"
```

3. **Kiểm tra sensors có type đúng**:
```bash
docker exec -it smartfarm-postgres psql -U postgres -d SmartFarm1 -c "SELECT DISTINCT type FROM \"Sensor\";"
```


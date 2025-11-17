# 🧪 Test Dashboard API

## ✅ Đã sửa SecurityConfig

Endpoint `/api/sensor-data/dashboard` giờ đã được thêm vào `permitAll()` - không cần authentication.

## 🚀 Deploy lại

Trên VPS:

```bash
cd ~/projects/SmartFarm

# Pull code mới
git pull

# Rebuild backend
docker compose build --no-cache backend

# Restart backend
docker compose restart backend

# Đợi backend khởi động (30-60 giây)
sleep 30

# Test lại
curl http://localhost:8080/api/sensor-data/dashboard
```

## ✅ Kết quả mong đợi

API sẽ trả về JSON với dữ liệu:

```json
{
  "temperature": [...],
  "humidity": [...],
  "soilMoisture": [...],
  "light": [...],
  "avgTemperature": 30.5,
  "avgHumidity": 75.0,
  "avgSoilMoisture": 55.0,
  "avgLight": 60.0
}
```

## 🔍 Nếu vẫn 404

1. **Kiểm tra backend đã khởi động chưa**:
```bash
docker compose ps backend
docker compose logs backend | tail -20
```

2. **Kiểm tra endpoint có được register không**:
```bash
curl http://localhost:8080/actuator/mappings | grep dashboard
```

3. **Kiểm tra code đã được build chưa**:
```bash
docker compose logs backend | grep -i "started\|error"
```


# ✅ Kiểm tra Dashboard có hiển thị dữ liệu IoT thật

## 🔍 Cách kiểm tra

### 1. Kiểm tra API trả về dữ liệu thật

Trên VPS, chạy:

```bash
# Test API endpoint
curl http://localhost:8080/api/sensor-data/dashboard | jq .

# Hoặc nếu không có jq
curl http://localhost:8080/api/sensor-data/dashboard
```

### 2. So sánh với database

```bash
docker exec -it smartfarm-postgres psql -U postgres -d SmartFarm1

# Xem dữ liệu mới nhất trong database
SELECT sd.id, sd.value, sd."time", s.type, s."sensor_name" 
FROM sensor_data sd 
JOIN "Sensor" s ON sd.sensor_id = s.id 
ORDER BY sd."time" DESC 
LIMIT 10;

# So sánh với dữ liệu trên dashboard
```

### 3. Kiểm tra logs backend

```bash
# Xem logs khi gọi API
docker compose logs backend | grep -i "sensor\|dashboard" | tail -20
```

---

## ✅ Dấu hiệu dữ liệu THẬT:

1. ✅ **Dữ liệu thay đổi theo thời gian thật** (không phải random)
2. ✅ **Có timestamps thật** từ database
3. ✅ **Giá trị hợp lý** (nhiệt độ 25-35°C, độ ẩm 40-80%, etc.)
4. ✅ **API trả về dữ liệu** khi gọi `/api/sensor-data/dashboard`

---

## ❌ Dấu hiệu vẫn là MOCK DATA:

1. ❌ Dữ liệu quá đều, không thay đổi
2. ❌ Timestamps không khớp với database
3. ❌ API trả về empty hoặc lỗi
4. ❌ Console có lỗi "fallback to mock data"

---

## 🚀 Nếu vẫn chưa đúng:

1. **Kiểm tra backend logs**:
```bash
docker compose logs backend | tail -50
```

2. **Kiểm tra frontend console** (F12 trong browser):
   - Xem có lỗi không
   - Xem Network tab - request đến `/api/sensor-data/dashboard` có thành công không

3. **Test API trực tiếp**:
```bash
curl -v http://localhost:8080/api/sensor-data/dashboard
```


# ✅ Kiểm tra Soil và Light Sensor Data

## 📊 Dữ liệu IoT nhận được:

```json
{
  "time": 26,
  "sensorId": 0,
  "temperature": 24.50,
  "humidity": 28.00,
  "light_raw": 197,
  "light_pct": 12,
  "soil_raw": 1022,
  "soil_pct": 0
}
```

## 🔍 Kiểm tra Flask API xử lý:

### 1. Soil (soil_pct = 0)

**Code Flask API:**
```python
s = b.get("soil_pct")  # Lấy "soil_pct" từ JSON
if s is not None:      # Kiểm tra có giá trị (kể cả 0)
    # Lưu vào sensor_id = 9
    cn.execute(..., {"sid": SOIL_SENSOR_ID, "val": float(s), ...})
```

**Kết quả:**
- ✅ `soil_pct = 0` → `s = 0` (không phải None)
- ✅ `if s is not None` → True (vì 0 không phải None)
- ✅ Lưu vào database: `sensor_id = 9, value = 0.0`

### 2. Light (light_pct = 12)

**Code Flask API:**
```python
l = b.get("light_pct", b.get("light"))  # Ưu tiên light_pct
if l is not None:
    # Lưu vào sensor_id = 10
    cn.execute(..., {"sid": LIGHT_SENSOR_ID, "val": float(l), ...})
```

**Kết quả:**
- ✅ `light_pct = 12` → `l = 12`
- ✅ `if l is not None` → True
- ✅ Lưu vào database: `sensor_id = 10, value = 12.0`

---

## 🧪 Test trên VPS

### Bước 1: Test gửi data lên Flask API

```bash
curl -X POST http://173.249.48.25:8000/api/sensors \
  -H "Content-Type: application/json" \
  -H "x-api-key: MY_API_KEY" \
  -d '{
    "time": 26,
    "sensorId": 0,
    "temperature": 24.50,
    "humidity": 28.00,
    "light_pct": 12,
    "soil_pct": 0
  }'
```

**Kết quả mong đợi:**
```json
{
  "ok": true,
  "oracle": {...},
  "canonical": "...",
  "hash": "0x..."
}
```

### Bước 2: Kiểm tra database

```bash
# SSH vào VPS
ssh root@173.249.48.25

# Kiểm tra data mới nhất
psql $DB_URL -c "
SELECT 
  sensor_id,
  value,
  time
FROM sensor_data 
WHERE sensor_id IN (7, 8, 9, 10) 
ORDER BY time DESC 
LIMIT 10;
"
```

**Kết quả mong đợi:**
```
 sensor_id | value |        time         
-----------+-------+---------------------
         7 |  24.5 | 2025-11-19 10:30:00
         8 |    28 | 2025-11-19 10:30:00
         9 |     0 | 2025-11-19 10:30:00  ← Soil
        10 |    12 | 2025-11-19 10:30:00  ← Light
```

### Bước 3: Kiểm tra Dashboard

Truy cập: `http://173.249.48.25/dashboard`

**Kiểm tra:**
1. Stat card "Độ ẩm đất TB" → Hiển thị giá trị (có thể là 0% nếu chỉ có data mới)
2. Stat card "Ánh sáng TB" → Hiển thị ~12%
3. Chart → Có 4 đường, bao gồm đường vàng cho Light

---

## ⚠️ Lưu ý về giá trị 0

**Vấn đề tiềm ẩn:**
- `soil_pct = 0` có thể là giá trị hợp lệ (đất rất khô)
- Flask API sẽ lưu `0.0` vào database ✅
- Dashboard sẽ hiển thị `0%` ✅

**Nếu không thấy data:**
1. Kiểm tra logs Flask API: `pm2 logs flask-api`
2. Kiểm tra database có data không
3. Kiểm tra dashboard có fetch đúng sensor_id không

---

## ✅ Kết luận

**Flask API đã xử lý đúng:**
- ✅ `soil_pct` → sensor_id = 9
- ✅ `light_pct` → sensor_id = 10
- ✅ Giá trị 0 vẫn được lưu (vì `0 is not None`)

**Dashboard đã fetch đúng:**
- ✅ sensor_id = 9 cho Soil
- ✅ sensor_id = 10 cho Light

**Nếu không thấy data trên dashboard:**
- Kiểm tra database có data không
- Kiểm tra console logs trong browser (F12)
- Kiểm tra API response từ backend


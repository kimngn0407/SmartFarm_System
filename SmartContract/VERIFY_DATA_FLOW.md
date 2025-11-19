# ✅ Xác nhận Data Flow: Arduino → Forwarder → Flask API → Database

## 📊 Tình trạng hiện tại

### ✅ Arduino (Serial Monitor)
```json
{
  "time": 869,
  "sensorId": 0,
  "temperature": 24.50,
  "humidity": 28.00,
  "light_raw": 194,
  "light_pct": 11,    ← ✅ Có
  "soil_raw": 1022,
  "soil_pct": 0       ← ✅ Có
}
```

**Kết luận:** Arduino đang gửi đúng `soil_pct` và `light_pct`! ✅

---

### ✅ Forwarder (SmartContract)
```
📥 Received: {"time":29,"sensorId":0,"temperature":23.80,"humidity":29.00,"light_raw":228,"li...
✅ Sent successfully: 200
```

**Kết luận:** Forwarder đang nhận và gửi thành công! ✅

**Vấn đề:** Logs bị cắt (`...`), không thấy đầy đủ `soil_pct` và `light_pct`.

**Giải pháp:** Đã sửa code để hiển thị đầy đủ JSON và debug logs.

---

## 🔍 Kiểm tra tiếp theo

### Bước 1: Cập nhật forwarder trên máy local

```bash
# Pull code mới
cd E:\SmartFarm
git pull origin main

# Restart forwarder (nếu dùng PM2)
pm2 restart arduino-forwarder

# Hoặc chạy lại script
python SmartContract/device/forwarder_auto.py
```

### Bước 2: Xem logs forwarder mới

Bạn sẽ thấy:
```
📥 Received: {"time":869,"sensorId":0,"temperature":24.50,"humidity":28.00,"light_raw":194,"light_pct":11,"soil_raw":1022,"soil_pct":0}
📊 Parsed payload keys: ['time', 'sensorId', 'temperature', 'humidity', 'light_raw', 'light_pct', 'soil_raw', 'soil_pct']
   ✅ soil_pct: 0
   ✅ light_pct: 11
📤 Sending to Flask API: {"time":869,"sensorId":0,"temperature":24.50,"humidity":28.00,"light_raw":194,"light_pct":11,"soil_raw":1022,"soil_pct":0}
✅ Sent successfully: 200
```

### Bước 3: Kiểm tra Flask API logs trên VPS

```bash
# Xem output logs (có debug logs)
pm2 logs flask-api --out --lines 50
```

Bạn sẽ thấy:
```
📥 Received JSON keys: ['time', 'sensorId', 'temperature', 'humidity', 'light_raw', 'light_pct', 'soil_raw', 'soil_pct']
   - soil_pct: 0
   - light_pct: 11
   - light: MISSING
📊 Extracted values:
   - temperature: 24.5
   - humidity: 28.0
   - soil_pct: 0
   - light_pct/light: 11
💾 INSERTING soil_pct=0 → sensor_id=9
💾 INSERTING light_pct=11 → sensor_id=10
```

### Bước 4: Kiểm tra database

```bash
docker exec smartfarm-postgres psql -U postgres -d SmartFarm1 -c "
SELECT 
  sensor_id,
  CASE 
    WHEN sensor_id = 7 THEN 'Temperature'
    WHEN sensor_id = 8 THEN 'Humidity'
    WHEN sensor_id = 9 THEN 'Soil'
    WHEN sensor_id = 10 THEN 'Light'
  END as sensor_type,
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
 sensor_id | sensor_type | value |        time         
-----------+-------------+-------+---------------------
         7 | Temperature |  24.5 | 2025-11-19 ...
         8 | Humidity    |    28 | 2025-11-19 ...
         9 | Soil        |     0 | 2025-11-19 ...  ← soil_pct = 0
        10 | Light       |    11 | 2025-11-19 ...  ← light_pct = 11
```

---

## ✅ Checklist

- [x] Arduino gửi đúng `soil_pct` và `light_pct`
- [x] Forwarder nhận được data
- [x] Forwarder gửi thành công (200 OK)
- [ ] Forwarder hiển thị đầy đủ JSON (sau khi cập nhật code)
- [ ] Flask API nhận được `soil_pct` và `light_pct` (xem output logs)
- [ ] Flask API INSERT vào database (xem output logs)
- [ ] Database có data mới cho sensor_id 9 và 10

---

## 🎯 Kết luận

**Arduino:** ✅ Đang gửi đúng `soil_pct` và `light_pct`

**Forwarder:** ✅ Đang nhận và gửi thành công

**Cần kiểm tra:**
1. Forwarder có parse đúng JSON không? (sau khi cập nhật code)
2. Flask API có nhận được `soil_pct` và `light_pct` không? (xem output logs)
3. Database có data mới không?

**Bước tiếp theo:**
1. Cập nhật forwarder trên máy local
2. Xem logs forwarder mới (sẽ hiển thị đầy đủ JSON)
3. Xem Flask API output logs trên VPS (sẽ thấy debug logs)


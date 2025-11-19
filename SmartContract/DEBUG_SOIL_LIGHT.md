# 🐛 Debug: Soil và Light không nhận được từ Arduino

## 🔍 Vấn đề

Database có data cho sensor_id 9 (Soil) và 10 (Light), nhưng có thể:
- Data không được cập nhật mới từ Arduino
- Hoặc forwarder không gửi đúng `soil_pct` và `light_pct`

---

## ✅ Kiểm tra 1: Forwarder Logs

### Trên máy local (nơi chạy forwarder):

```bash
# Xem logs forwarder
# Nếu dùng PM2:
pm2 logs arduino-forwarder --lines 50

# Hoặc nếu chạy trực tiếp:
# Xem output trong terminal
```

**Tìm trong logs:**
```
📥 Received: {"time":26,"sensorId":0,"temperature":24.50,"humidity":28.00,"light_raw":197,"light_pct":12,"soil_raw":1022,"soil_pct":0}
✅ Sent to Flask API: 200 OK
```

**Kiểm tra:**
- ✅ JSON có `soil_pct` không?
- ✅ JSON có `light_pct` không?
- ✅ Response từ Flask API là 200 OK?

---

## ✅ Kiểm tra 2: Flask API Logs

### Trên VPS:

```bash
pm2 logs flask-api --lines 50
```

**Tìm trong logs:**
```
POST /api/sensors
Received: {"time":26,"temperature":24.50,"humidity":28.00,"soil_pct":0,"light_pct":12}
INSERT sensor_id=9, value=0.0
INSERT sensor_id=10, value=12.0
```

**Kiểm tra:**
- ✅ Flask API có nhận được `soil_pct` không?
- ✅ Flask API có nhận được `light_pct` không?
- ✅ Có INSERT vào database không?

---

## ✅ Kiểm tra 3: Test gửi data thủ công

### Trên VPS:

```bash
# Test gửi data với đầy đủ fields
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

### Sau đó kiểm tra database:

```bash
docker exec smartfarm-postgres psql -U postgres -d SmartFarm1 -c "
SELECT sensor_id, value, time 
FROM sensor_data 
WHERE sensor_id IN (9, 10) 
ORDER BY time DESC 
LIMIT 5;
"
```

**Kết quả mong đợi:**
```
 sensor_id | value |        time         
-----------+-------+---------------------
         9 |     0 | 2025-11-19 ...  ← Soil
        10 |    12 | 2025-11-19 ...  ← Light
```

---

## ✅ Kiểm tra 4: Arduino Output

### Trên máy local (nơi cắm Arduino):

Mở Serial Monitor trong Arduino IDE hoặc dùng:

```bash
# Windows (PowerShell):
Get-Content COM4 -Encoding ASCII

# Hoặc dùng Python:
python -c "import serial; ser = serial.Serial('COM4', 9600); [print(ser.readline().decode('utf-8', errors='ignore').strip()) for _ in range(10)]"
```

**Kiểm tra output từ Arduino:**
```json
{"time":26,"sensorId":0,"temperature":24.50,"humidity":28.00,"light_raw":197,"light_pct":12,"soil_raw":1022,"soil_pct":0}
```

**Kiểm tra:**
- ✅ Arduino có gửi `soil_pct` không?
- ✅ Arduino có gửi `light_pct` không?
- ✅ Format JSON có đúng không?

---

## 🔧 Sửa lỗi nếu không nhận được

### Vấn đề 1: Forwarder không parse đúng JSON

**Kiểm tra `forwarder_auto.py`:**
- Dòng 131: `payload = json.loads(line)` → Có parse đúng không?
- Dòng 147-149: Gửi `payload` lên Flask API → Có gửi đầy đủ fields không?

**Thêm debug logging:**

```python
# Trong forwarder_auto.py, sau dòng 131:
print(f"📊 Parsed payload: {payload}")
print(f"   - soil_pct: {payload.get('soil_pct', 'MISSING')}")
print(f"   - light_pct: {payload.get('light_pct', 'MISSING')}")
```

### Vấn đề 2: Flask API không nhận được fields

**Kiểm tra `app.py`:**
- Dòng 59: `s = b.get("soil_pct")` → Có nhận được không?
- Dòng 61: `l = b.get("light_pct", b.get("light"))` → Có nhận được không?

**Thêm debug logging:**

```python
# Trong app.py, sau dòng 42:
print(f"📥 Received JSON: {b}")
print(f"   - soil_pct: {b.get('soil_pct', 'MISSING')}")
print(f"   - light_pct: {b.get('light_pct', 'MISSING')}")
```

---

## 🎯 Checklist Debug

- [ ] Arduino Serial Monitor hiển thị `soil_pct` và `light_pct`
- [ ] Forwarder logs hiển thị JSON có `soil_pct` và `light_pct`
- [ ] Forwarder gửi thành công lên Flask API (200 OK)
- [ ] Flask API logs hiển thị nhận được `soil_pct` và `light_pct`
- [ ] Flask API INSERT vào database thành công
- [ ] Database có data mới cho sensor_id 9 và 10

---

## 📝 Lưu ý

1. **Giá trị 0 là hợp lệ:**
   - `soil_pct = 0` → Đất rất khô (hợp lệ)
   - Vẫn được lưu vào database

2. **Field names phải đúng:**
   - Arduino phải gửi: `soil_pct` (không phải `soil` hoặc `soil_raw`)
   - Arduino phải gửi: `light_pct` (không phải `light` hoặc `light_raw`)

3. **JSON format:**
   - Phải là valid JSON
   - Phải có dấu `{` và `}` đầy đủ

---

## 🚀 Quick Fix

Nếu Arduino không gửi `soil_pct` và `light_pct`, sửa code Arduino:

```cpp
// Thay vì:
Serial.println("{\"soil\":" + String(soilValue) + "}");

// Phải là:
Serial.println("{\"soil_pct\":" + String(soilPercent) + "}");
```

Tương tự cho `light_pct`.


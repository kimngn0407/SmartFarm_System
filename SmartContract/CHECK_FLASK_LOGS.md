# 🔍 Kiểm tra Flask API Logs để Debug Soil và Light

## 📊 Phân tích logs hiện tại

Từ logs bạn vừa gửi, tôi thấy:
- ✅ Flask API đã nhận nhiều POST requests (200 OK)
- ✅ Flask API đã restart lúc 04:09:38 (sau khi pull code mới)
- ❌ **KHÔNG thấy debug logs** (📥 Received JSON keys, 💾 INSERTING...)

**Nguyên nhân:** Debug logs đang ở **output log**, không phải **error log**!

---

## ✅ Cách xem đúng logs

### Cách 1: Xem output log (khuyến nghị)

```bash
# Xem output log (stdout) - nơi có debug logs
pm2 logs flask-api --out --lines 100

# Hoặc xem cả output và error
pm2 logs flask-api --lines 100
```

### Cách 2: Xem file log trực tiếp

```bash
# Output log (có debug logs)
tail -f /root/projects/SmartFarm/SmartContract/flask-api/logs/out.log

# Hoặc xem 100 dòng cuối
tail -100 /root/projects/SmartFarm/SmartContract/flask-api/logs/out.log
```

### Cách 3: Xem real-time logs

```bash
# Xem logs real-time khi có request mới
pm2 logs flask-api --lines 0
```

Sau đó đợi forwarder gửi data, bạn sẽ thấy:
```
📥 Received JSON keys: ['time', 'sensorId', 'temperature', 'humidity', 'soil_pct', 'light_pct']
   - soil_pct: 0
   - light_pct: 12
   - light: MISSING
📊 Extracted values:
   - temperature: 24.5
   - humidity: 28.0
   - soil_pct: 0
   - light_pct/light: 12
💾 INSERTING soil_pct=0 → sensor_id=9
💾 INSERTING light_pct=12 → sensor_id=10
```

---

## 🔍 Kiểm tra Flask API có nhận được soil_pct và light_pct

### Bước 1: Xem output log

```bash
pm2 logs flask-api --out --lines 200 | grep -E "(Received JSON|soil_pct|light_pct|INSERTING)"
```

**Kết quả mong đợi:**
```
📥 Received JSON keys: ['time', 'sensorId', 'temperature', 'humidity', 'soil_pct', 'light_pct']
   - soil_pct: 0
   - light_pct: 12
💾 INSERTING soil_pct=0 → sensor_id=9
💾 INSERTING light_pct=12 → sensor_id=10
```

### Bước 2: Nếu không thấy debug logs

**Có thể Flask API chưa restart với code mới:**

```bash
# Pull code mới
cd ~/projects/SmartFarm
git pull origin main

# Restart Flask API
pm2 restart flask-api

# Xem logs
pm2 logs flask-api --out --lines 50
```

### Bước 3: Test gửi data thủ công

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

Sau đó xem logs:
```bash
pm2 logs flask-api --out --lines 20
```

---

## 🐛 Nếu không thấy debug logs

### Kiểm tra 1: Code đã được cập nhật chưa?

```bash
cd ~/projects/SmartFarm/SmartContract/flask-api
git log --oneline -5
# Phải thấy commit: "Add debug logging for soil_pct and light_pct..."
```

### Kiểm tra 2: Flask API đã restart chưa?

```bash
pm2 restart flask-api
pm2 logs flask-api --out --lines 10
```

### Kiểm tra 3: Code có debug logs không?

```bash
grep -n "Received JSON keys" /root/projects/SmartFarm/SmartContract/flask-api/app.py
# Phải thấy dòng code
```

---

## 📝 Checklist

- [ ] Xem output log (không phải error log)
- [ ] Flask API đã restart với code mới
- [ ] Thấy debug logs: "📥 Received JSON keys"
- [ ] Thấy debug logs: "💾 INSERTING soil_pct"
- [ ] Thấy debug logs: "💾 INSERTING light_pct"

---

## 🎯 Kết luận

**Logs bạn vừa gửi là error log**, không có debug logs.

**Cần xem output log** để thấy debug logs về `soil_pct` và `light_pct`.

Chạy lệnh:
```bash
pm2 logs flask-api --out --lines 100
```

Và tìm các dòng có:
- `📥 Received JSON keys`
- `💾 INSERTING soil_pct`
- `💾 INSERTING light_pct`


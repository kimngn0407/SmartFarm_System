# 💡 Kiểm tra Light Sensor có lấy đúng từ IoT không

## ✅ Code Dashboard đã có Light Sensor

### 1. Fetch Light Data
```javascript
const lightSensorIds = [10]; // LIGHT_SENSOR_ID từ Flask API
const lightData = await fetchRealSensorData(lightSensorIds, 12);
```

### 2. Calculate Stats
```javascript
const lightStats = calculateStats(lightData);
setStats({
  ...
  avgLight: lightStats.avg.toFixed(1)
});
```

### 3. Display in Chart
```javascript
{
  label: 'Ánh sáng (%)',
  data: lightArr.length > 0 ? lightArr : Array(timeLabels.length).fill(0),
  borderColor: '#FFD700',
  backgroundColor: '#FFF9C4',
  tension: 0.4,
  yAxisID: 'y3',
}
```

### 4. Display Stat Card
```javascript
{
  label: 'Ánh sáng TB',
  value: formatPercentage(stats.avgLight),
  icon: <LightModeIcon fontSize="large" color="warning" />,
  color: '#fff9c4'
}
```

---

## 🔍 Cách kiểm tra

### Bước 1: Kiểm tra Database có data Light không

**Trên VPS:**
```bash
docker exec smartfarm-postgres psql -U postgres -d SmartFarm1 -c "
SELECT 
  sensor_id,
  value,
  time
FROM sensor_data 
WHERE sensor_id = 10 
ORDER BY time DESC 
LIMIT 10;
"
```

**Kết quả mong đợi:**
```
 sensor_id | value |        time         
-----------+-------+---------------------
        10 |    11 | 2025-11-19 ...  ← light_pct = 11
        10 |    12 | 2025-11-19 ...
        10 |    15 | 2025-11-19 ...
```

### Bước 2: Kiểm tra API có trả về Light data không

**Mở Browser Console (F12) → Network tab:**
1. Filter: `sensor-data`
2. Tìm request với `sensorId=10`
3. Xem Response → Có data không?

**Hoặc test trực tiếp:**
```bash
curl "http://173.249.48.25:8080/api/sensor-data?sensorId=10&from=2025-11-19T00:00:00Z&to=2025-11-19T23:59:59Z" \
  -H "Authorization: Bearer YOUR_TOKEN"
```

### Bước 3: Kiểm tra Console Logs trong Browser

**Mở Dashboard → F12 → Console tab, tìm:**
```
📡 Using Flask API sensor IDs for IoT data:
💡 Light: sensor_id = 10
✅ Sensor 10: Got X data points
💡 Sample light data: {id: X, sensorId: 10, value: 11, time: '...'}
✅ 💡 Light chart: Using IoT data (X points)
```

**Nếu thấy:**
```
⚠️ 💡 Light chart: Using SAMPLE data (no IoT data available)
```
→ **KHÔNG có data từ IoT!**

### Bước 4: Kiểm tra Chart có hiển thị Light không

**Trên Dashboard:**
1. Xem chart → Có 4 đường không?
   - 🟠 Nhiệt độ (°C)
   - 🔵 Độ ẩm không khí (%)
   - 🟤 Độ ẩm đất (%)
   - 🟡 **Ánh sáng (%)** ← Phải có đường vàng này!

2. Xem stat cards → Có 6 cards không?
   - ...
   - **Ánh sáng TB** → Hiển thị giá trị (ví dụ: 11.0%)

3. Xem badge trên chart → Có hiển thị "Dữ liệu IoT" không?

---

## 🐛 Nếu không thấy Light data

### Vấn đề 1: Database không có data

**Kiểm tra:**
```bash
docker exec smartfarm-postgres psql -U postgres -d SmartFarm1 -c "
SELECT COUNT(*) as count, MAX(time) as latest_time
FROM sensor_data 
WHERE sensor_id = 10;
"
```

**Nếu `count = 0`:**
- Flask API không lưu light data
- Kiểm tra Flask API logs: `pm2 logs flask-api --out --lines 50`
- Tìm: `💾 INSERTING light_pct=... → sensor_id=10`

### Vấn đề 2: API không trả về data

**Kiểm tra:**
- Console logs: `✅ Sensor 10: Got X data points`
- Nếu `X = 0` → API không trả về data
- Kiểm tra backend API có hoạt động không

### Vấn đề 3: Chart không hiển thị

**Kiểm tra:**
- Console logs: `✅ 💡 Light chart: Using IoT data`
- Nếu thấy: `⚠️ 💡 Light chart: Using SAMPLE data` → Không có IoT data
- Kiểm tra `lightArr` có data không: `console.log(lightArr)`

---

## ✅ Checklist

- [ ] Database có data cho sensor_id = 10
- [ ] API trả về data cho sensor_id = 10
- [ ] Console logs hiển thị: "✅ Sensor 10: Got X data points"
- [ ] Console logs hiển thị: "✅ 💡 Light chart: Using IoT data"
- [ ] Chart hiển thị 4 đường (bao gồm đường vàng cho Light)
- [ ] Stat card "Ánh sáng TB" hiển thị giá trị (không phải "N/A")
- [ ] Badge "Dữ liệu IoT" hiển thị trên chart

---

## 🎯 Quick Test

**Trên Dashboard, mở Console (F12) và chạy:**
```javascript
// Kiểm tra lightArr có data không
console.log('lightArr:', lightArr);
console.log('lightArr length:', lightArr.length);

// Kiểm tra stats
console.log('avgLight:', stats.avgLight);

// Kiểm tra dataSource
console.log('dataSource.light:', dataSource.light);
```

**Kết quả mong đợi:**
```
lightArr: [11, 12, 15, ...]  ← Có giá trị
lightArr length: 28  ← Có nhiều điểm
avgLight: "11.5"  ← Có giá trị trung bình
dataSource.light: "iot"  ← Đang dùng IoT data
```

---

## 🔧 Nếu không thấy Light data

### Sửa 1: Kiểm tra Flask API có lưu không

```bash
# Xem Flask API logs
pm2 logs flask-api --out --lines 100 | grep -E "(light_pct|INSERTING light)"
```

**Phải thấy:**
```
💾 INSERTING light_pct=11 → sensor_id=10
```

### Sửa 2: Kiểm tra Backend API có trả về không

```bash
# Test API endpoint
curl "http://173.249.48.25:8080/api/sensor-data?sensorId=10&from=2025-11-19T00:00:00Z&to=2025-11-19T23:59:59Z" \
  -H "Authorization: Bearer YOUR_TOKEN"
```

**Phải thấy JSON response với data.**

### Sửa 3: Rebuild Frontend

```bash
cd ~/projects/SmartFarm
git pull origin main
docker-compose build --no-cache frontend
docker-compose up -d frontend
```

---

## 📊 Kết luận

**Dashboard đã có code để:**
- ✅ Fetch light data từ sensor_id = 10
- ✅ Calculate stats
- ✅ Display trong chart (đường vàng)
- ✅ Display trong stat card

**Cần kiểm tra:**
1. Database có data không?
2. API có trả về data không?
3. Chart có hiển thị không?

Chạy các lệnh kiểm tra ở trên để xác nhận!


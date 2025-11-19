# ✅ Xác nhận Dashboard hiển thị đầy đủ 4 Sensor

## 📊 Database đã có data:

Từ query database, bạn đã có:
- ✅ **sensor_id = 7** (Temperature): 23.8°C
- ✅ **sensor_id = 8** (Humidity): 29%
- ✅ **sensor_id = 9** (Soil): 0 (soil_pct = 0)
- ✅ **sensor_id = 10** (Light): 15-16% (light_pct)

**Kết luận:** Flask API đã lưu đúng tất cả 4 loại sensor! ✅

---

## 🔍 Kiểm tra Dashboard

### Bước 1: Rebuild Frontend (nếu chưa)

```bash
cd ~/projects/SmartFarm
git pull origin main
docker-compose build --no-cache frontend
docker-compose up -d frontend
```

### Bước 2: Truy cập Dashboard

Mở: `http://173.249.48.25/dashboard`

### Bước 3: Kiểm tra Console (F12)

Mở Developer Tools (F12) → Console tab, tìm:

```
✅ Sensor 7: Got X data points
✅ Sensor 8: Got X data points
✅ Sensor 9: Got X data points  ← Soil
✅ Sensor 10: Got X data points ← Light
```

Và:
```
✅ ✅ ✅ CHART IS USING IOT DATA ✅ ✅ ✅
   - Temperature: ✅ IoT
   - Humidity: ✅ IoT
   - Soil: ✅ IoT
   - Light: ✅ IoT
```

### Bước 4: Kiểm tra Stat Cards

Bạn sẽ thấy **6 stat cards** trên cùng 1 dòng:
1. Tổng Cảm biến
2. Tổng Cảnh báo
3. Nhiệt độ TB → ~23.8°C
4. Độ ẩm TB → ~29%
5. Độ ẩm đất TB → ~0% (hoặc giá trị trung bình)
6. **Ánh sáng TB** → ~15-16% ✅

### Bước 5: Kiểm tra Chart

Chart sẽ có **4 đường**:
- 🟠 Nhiệt độ (°C) - đường cam
- 🔵 Độ ẩm không khí (%) - đường xanh dương
- 🟤 Độ ẩm đất (%) - đường nâu
- 🟡 **Ánh sáng (%)** - đường vàng ✅

---

## 🐛 Nếu không thấy Light trên Dashboard

### Kiểm tra 1: Console Logs

```javascript
// Trong browser console (F12)
// Tìm các dòng:
📡 API Request: .../api/sensor-data {sensorId: 10, ...}
✅ API Response for sensor 10: {status: 200, dataLength: X, ...}
```

### Kiểm tra 2: Network Tab

1. Mở Developer Tools (F12)
2. Tab **Network**
3. Filter: `sensor-data`
4. Tìm request với `sensorId=10`
5. Xem Response → Có data không?

### Kiểm tra 3: Backend API

```bash
# Test endpoint trực tiếp
curl "http://173.249.48.25:8080/api/sensor-data?sensorId=10&from=2025-11-19T00:00:00Z&to=2025-11-19T23:59:59Z" \
  -H "Authorization: Bearer YOUR_TOKEN"
```

---

## ✅ Checklist

- [x] Database có data cho sensor_id 7, 8, 9, 10
- [ ] Frontend đã rebuild với code mới (có Light sensor)
- [ ] Dashboard hiển thị 6 stat cards (bao gồm Ánh sáng TB)
- [ ] Chart hiển thị 4 đường (bao gồm đường vàng cho Light)
- [ ] Console logs hiển thị "✅ Sensor 10: Got X data points"
- [ ] Badge "Dữ liệu IoT" hiển thị trên chart

---

## 🎯 Kết luận

**Database:** ✅ Đã có đầy đủ 4 loại sensor data

**Dashboard:** Cần rebuild frontend để hiển thị Light sensor

**Sau khi rebuild:** Dashboard sẽ hiển thị đầy đủ 4 loại sensor với data thật từ IoT!


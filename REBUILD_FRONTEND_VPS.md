# 🔧 Rebuild Frontend Trên VPS Để Áp Dụng Sensor IDs Mới

## 🔍 Vấn Đề

**Frontend vẫn đang request sensor IDs cũ (1, 2, 3, 4) thay vì mới (7, 8, 9, 10):**

```
📡 API Request: ... {sensorId: 1, ...}
📡 API Request: ... {sensorId: 2, ...}
📡 API Request: ... {sensorId: 3, ...}
📡 API Request: ... {sensorId: 4, ...}
```

**Nguyên nhân:**
- Frontend container chưa được rebuild với code mới
- Browser cache chưa được clear

---

## ✅ Giải Pháp: Rebuild Frontend Trên VPS

### Bước 1: Pull Code Mới

**Trên VPS, chạy:**
```bash
cd /opt/SmartFarm

# Pull code mới từ GitHub
git pull origin main --no-rebase --no-edit

# Kiểm tra code đã được update
grep -n "sensor_id = 7\|sensor_id = 8\|sensor_id = 9\|sensor_id = 10" J2EE_Frontend/src/pages/dashboard/Dashboard.js

# Phải thấy các dòng có sensor_id = 7, 8, 9, 10
```

---

### Bước 2: Rebuild Frontend Container

**Trên VPS, chạy:**
```bash
cd /opt/SmartFarm

# Rebuild frontend container (không dùng cache để đảm bảo code mới)
docker compose build --no-cache frontend

# Restart frontend
docker compose restart frontend

# Đợi frontend khởi động (30-60 giây)
sleep 45

# Kiểm tra logs
docker compose logs frontend --tail=30
```

---

### Bước 3: Clear Browser Cache

**Trên máy local (browser):**

1. **Mở Developer Tools** (F12)
2. **Right-click vào nút Refresh** (hoặc Ctrl+Shift+R)
3. **Chọn "Empty Cache and Hard Reload"**

**Hoặc:**
- **Chrome/Edge:** Ctrl+Shift+Delete → Clear browsing data → Cached images and files
- **Firefox:** Ctrl+Shift+Delete → Cache → Clear Now

---

### Bước 4: Kiểm Tra Sau Khi Rebuild

**Mở browser console và kiểm tra:**

**Phải thấy:**
```
📡 Using ESP32 sensor IDs for IoT data:
🌡️ Temperature: sensor_id = 7
💧 Humidity: sensor_id = 8
🌱 Soil: sensor_id = 9
💡 Light: sensor_id = 10

📡 API Request: ... {sensorId: 7, ...}
📡 API Request: ... {sensorId: 8, ...}
📡 API Request: ... {sensorId: 9, ...}
📡 API Request: ... {sensorId: 10, ...}
```

**KHÔNG còn thấy:**
```
🌡️ Temperature: sensor_id = 1
💧 Humidity: sensor_id = 2
🌱 Soil: sensor_id = 3
💡 Light: sensor_id = 4

📡 API Request: ... {sensorId: 1, ...}
```

---

## 🔍 Debug Nếu Vẫn Không Hoạt Động

### Kiểm Tra Code Trên VPS

**Trên VPS, chạy:**
```bash
cd /opt/SmartFarm

# Kiểm tra file Dashboard.js có sensor IDs mới không
grep -A 5 "tempSensorIds = " J2EE_Frontend/src/pages/dashboard/Dashboard.js

# Phải thấy:
# const tempSensorIds = [7];
# const humSensorIds = [8];
# const soilSensorIds = [9];
# const lightSensorIds = [10];
```

**Nếu vẫn thấy [1], [2], [3], [4]:**
- Code chưa được pull đúng
- Thử pull lại: `git pull origin main --no-rebase --no-edit`

---

### Kiểm Tra Frontend Container

**Trên VPS, chạy:**
```bash
cd /opt/SmartFarm

# Kiểm tra frontend container có chạy không
docker compose ps frontend

# Kiểm tra logs để xem có lỗi build không
docker compose logs frontend --tail=100 | grep -i "error\|fail\|warning"
```

---

## 📋 Checklist

- [ ] Đã pull code mới từ GitHub
- [ ] Đã kiểm tra code có sensor IDs 7, 8, 9, 10
- [ ] Đã rebuild frontend container (--no-cache)
- [ ] Đã restart frontend container
- [ ] Đã clear browser cache
- [ ] Đã kiểm tra browser console thấy sensor IDs 7, 8, 9, 10
- [ ] Đã kiểm tra API requests thấy sensorId: 7, 8, 9, 10

---

## 🎯 Kết Quả Mong Đợi

**Sau khi rebuild:**
- ✅ Frontend request sensor IDs 7, 8, 9, 10
- ✅ API responses có data (không còn 0 data points)
- ✅ Dashboard hiển thị sensor data đúng

---

**Hãy rebuild frontend trên VPS và clear browser cache!** 🔧✨

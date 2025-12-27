# 🔧 Fix Arduino Sensor IDs - Match Với Frontend

## 🔍 Vấn Đề

**Frontend đang request sensor data với IDs:**
- Sensor ID 7 (Temperature)
- Sensor ID 8 (Humidity)
- Sensor ID 9 (Soil)
- Sensor ID 10 (Light)

**Nhưng Arduino code đang gửi với IDs:**
- Sensor ID 1 (Temperature)
- Sensor ID 2 (Humidity)
- Sensor ID 3 (Soil)
- Sensor ID 4 (Light)

**Kết quả:** Frontend không nhận được data vì IDs không match.

---

## ✅ Giải Pháp: Sửa Sensor IDs Trong Arduino Code

**Đã sửa các file Arduino:**

### 1. `Arduino_SmartFarm_Demo/Arduino_SmartFarm_Demo.ino`
```cpp
const long SENSOR_ID_TEMPERATURE = 7;  // Match với frontend sensor ID
const long SENSOR_ID_HUMIDITY = 8;     // Match với frontend sensor ID
const long SENSOR_ID_SOIL = 9;         // Match với frontend sensor ID
const long SENSOR_ID_LIGHT = 10;       // Match với frontend sensor ID
```

### 2. `Arduino_SmartFarm_IoT.ino`
```cpp
const long SENSOR_ID_TEMPERATURE = 7;  // Match với frontend sensor ID
const long SENSOR_ID_HUMIDITY = 8;      // Match với frontend sensor ID
const long SENSOR_ID_SOIL = 9;         // Match với frontend sensor ID
const long SENSOR_ID_LIGHT = 10;       // Match với frontend sensor ID
```

---

## 📋 Các Bước Tiếp Theo

### Bước 1: Upload Code Mới Lên ESP32

1. **Mở Arduino IDE**
2. **Mở file:** `Arduino_SmartFarm_Demo/Arduino_SmartFarm_Demo.ino`
3. **Kiểm tra:** Sensor IDs đã được sửa (7, 8, 9, 10)
4. **Upload** code lên ESP32

---

### Bước 2: Kiểm Tra Serial Monitor

**Sau khi upload, mở Serial Monitor và kiểm tra:**

```
📡 Gửi dữ liệu sensor lên server...
  - Sensor ID: 7 (Temperature)
  - Sensor ID: 8 (Humidity)
  - Sensor ID: 9 (Soil)
  - Sensor ID: 10 (Light)
```

**Phải thấy:** Sensor IDs là 7, 8, 9, 10 (không phải 1, 2, 3, 4)

---

### Bước 3: Kiểm Tra Frontend

**Mở browser console và kiểm tra:**

```
📡 API Request: https://smartfarm.kimngn.cfd/api/sensor-data {sensorId: 7, ...}
✅ API Response for sensor 7: Object (có data)
📡 API Request: https://smartfarm.kimngn.cfd/api/sensor-data {sensorId: 8, ...}
✅ API Response for sensor 8: Object (có data)
📡 API Request: https://smartfarm.kimngn.cfd/api/sensor-data {sensorId: 9, ...}
✅ API Response for sensor 9: Object (có data)
📡 API Request: https://smartfarm.kimngn.cfd/api/sensor-data {sensorId: 10, ...}
✅ API Response for sensor 10: Object (có data)
```

**KHÔNG còn thấy:**
```
✅ Sensor 7: Got 0 data points No data
✅ Sensor 8: Got 0 data points No data
✅ Sensor 9: Got 0 data points No data
✅ Sensor 10: Got 0 data points No data
```

---

## 🎯 Kết Quả Mong Đợi

**Sau khi fix:**
- ✅ Arduino gửi data với sensor IDs: 7, 8, 9, 10
- ✅ Frontend request data với sensor IDs: 7, 8, 9, 10
- ✅ IDs match → Frontend nhận được data
- ✅ Dashboard hiển thị sensor data đúng

---

## 📋 Checklist

- [ ] Đã sửa sensor IDs trong Arduino code (7, 8, 9, 10)
- [ ] Đã upload code mới lên ESP32
- [ ] Đã kiểm tra Serial Monitor thấy sensor IDs đúng
- [ ] Đã kiểm tra frontend nhận được data (không còn 0 data points)
- [ ] Đã kiểm tra Dashboard hiển thị sensor data

---

**Hãy upload code mới lên ESP32!** 🔧✨

# 🔧 Sửa Lỗi Sensor - Soil 100% và Light 0%

## ✅ Tin Tốt: Dữ Liệu Đang Được Gửi Lên Server!

Database cho thấy:
- ✅ **Temperature (ID 1):** 26.2°C - Hoạt động tốt
- ✅ **Humidity (ID 2):** 53-54% - Hoạt động tốt
- ❌ **Soil (ID 3):** Luôn 100% - Cần sửa
- ❌ **Light (ID 4):** Luôn 0% - Cần sửa

---

## 🔍 Vấn Đề 1: Soil Sensor Luôn 100%

### Nguyên Nhân:
- Giá trị raw từ sensor có thể đang ở mức cao (đất khô)
- Logic mapping có thể cần điều chỉnh

### Cách Sửa:

**Bước 1: Kiểm tra giá trị raw từ Serial Monitor**

Mở Serial Monitor và tìm dòng:
```
DEBUG - Soil Raw: XXXX
```

**Bước 2: Hiệu chuẩn lại giá trị**

Trong code, tìm dòng:
```cpp
int SOIL_RAW_DRY = 4095;
int SOIL_RAW_WET = 2000;
```

**Nếu giá trị raw luôn cao (ví dụ: 3500-4095):**
- Đây là đất **KHÔ** → Cần điều chỉnh `SOIL_RAW_DRY` xuống thấp hơn
- Thử: `SOIL_RAW_DRY = 3500;` hoặc giá trị bạn thấy trong Serial Monitor

**Nếu giá trị raw luôn thấp (ví dụ: 0-2000):**
- Đây là đất **ẨM** → Cần điều chỉnh `SOIL_RAW_WET` lên cao hơn
- Thử: `SOIL_RAW_WET = 1000;` hoặc giá trị bạn thấy trong Serial Monitor

**Bước 3: Test với nước**

1. Nhúng sensor vào nước → Xem giá trị raw
2. Để sensor khô → Xem giá trị raw
3. Cập nhật `SOIL_RAW_DRY` và `SOIL_RAW_WET` theo giá trị thực tế

---

## 🔍 Vấn Đề 2: Light Sensor Luôn 0%

### Nguyên Nhân:
- LDR Module có thể đảo ngược logic
- `INPUT_PULLUP` có thể làm logic ngược

### Cách Sửa:

**Bước 1: Đảo ngược logic**

Trong code, tìm dòng:
```cpp
lightPct = (lightValue == HIGH) ? 100 : 0;
```

**Thử đổi thành:**
```cpp
lightPct = (lightValue == LOW) ? 100 : 0;
```

**Bước 2: Kiểm tra Serial Monitor**

Xem dòng:
```
DEBUG - Light Digital: X
```

- Nếu `X = 0` (LOW) khi có ánh sáng → Dùng logic: `(lightValue == LOW) ? 100 : 0`
- Nếu `X = 1` (HIGH) khi có ánh sáng → Dùng logic: `(lightValue == HIGH) ? 100 : 0`

**Bước 3: Test**

1. Che sensor → Xem giá trị
2. Chiếu sáng → Xem giá trị
3. Chọn logic phù hợp

---

## 🎯 Các Bước Thực Hiện

### 1. Mở Serial Monitor
- Baud rate: 115200
- Tìm dòng `DEBUG - Soil Raw:` và `DEBUG - Light Digital:`

### 2. Ghi lại giá trị:
- **Soil Raw:** Khi khô = ? Khi ướt = ?
- **Light Digital:** Khi sáng = ? Khi tối = ?

### 3. Sửa code:

**Sửa Soil:**
```cpp
// Thay đổi giá trị hiệu chuẩn
int SOIL_RAW_DRY = 3500;  // Giá trị khi đất khô (từ Serial Monitor)
int SOIL_RAW_WET = 1500;  // Giá trị khi đất ướt (từ Serial Monitor)
```

**Sửa Light:**
```cpp
// Đảo ngược logic
lightPct = (lightValue == LOW) ? 100 : 0;
```

### 4. Upload lại code và kiểm tra database

---

## 📊 Kiểm Tra Sau Khi Sửa

```bash
# Trên VPS
cd /opt/SmartFarm
docker compose exec postgres psql -U postgres -d SmartFarm1 -c "SELECT sensor_id, value, time FROM sensor_data ORDER BY time DESC LIMIT 10;"
```

**Kết quả mong đợi:**
- Soil (ID 3): Giá trị thay đổi từ 0-100% (không còn luôn 100%)
- Light (ID 4): Giá trị thay đổi từ 0-100% (không còn luôn 0%)

---

## 💡 Lưu Ý

**Soil Sensor:**
- Giá trị raw cao = Đất khô = % thấp
- Giá trị raw thấp = Đất ướt = % cao
- Cần hiệu chuẩn theo môi trường thực tế

**Light Sensor:**
- LDR Module có thể có logic đảo ngược
- Cần test thực tế để xác định logic đúng

---

**Hãy kiểm tra Serial Monitor trước, sau đó sửa code theo giá trị thực tế!** 🔍✨

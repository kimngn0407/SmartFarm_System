# 🔧 Sửa Lỗi Soil Sensor Đọc Giá Trị 0

## 🔍 Vấn Đề

**Soil Raw: 0** → Soil Percentage: 100%

**Nguyên nhân:**
- Sensor đang đọc được giá trị 0 (không hoạt động)
- Code clamp giá trị 0 về `SOIL_RAW_WET` (2000)
- Sau đó map từ (4095, 2000) sang (0, 100) → Kết quả 100%

---

## ✅ Giải Pháp

### Bước 1: Kiểm Tra Wiring

**Pin hiện tại:** `SOIL_PIN = 2` (GPIO2)

**Cần kiểm tra:**
1. Sensor có được nối đúng pin không?
2. Sensor có nguồn (VCC) không?
3. Sensor có GND không?
4. Dây tín hiệu (A0/Signal) có nối đúng GPIO2 không?

**Sơ đồ nối đúng:**
```
Soil Moisture Sensor:
  VCC ────> ESP32 3.3V (hoặc 5V)
  GND ────> ESP32 GND
  A0/Signal ────> ESP32 GPIO2 (D2)
```

---

### Bước 2: Test Các Pin Analog Khác

Code đã được thêm debug để đọc nhiều pin:
```
DEBUG - Soil Raw: 0 | GPIO2: X | GPIO32: Y | GPIO33: Z | GPIO34: A | GPIO35: B
```

**Xem Serial Monitor:**
- Nếu GPIO32 có giá trị khác 0 → Thử đổi `SOIL_PIN` sang GPIO32
- Nếu GPIO33 có giá trị khác 0 → Thử đổi `SOIL_PIN` sang GPIO33
- Nếu tất cả đều 0 → Kiểm tra wiring hoặc sensor bị hỏng

---

### Bước 3: Đổi Pin Nếu Cần

**Nếu GPIO32 có giá trị:**

Trong code, đổi:
```cpp
#define SOIL_PIN     2        // Cũ
```

Thành:
```cpp
#define SOIL_PIN     32       // Mới (GPIO32)
```

**Lưu ý:** GPIO32 là pin analog tốt cho ESP32 (ADC1_CH4)

---

### Bước 4: Kiểm Tra Sensor

**Test thủ công:**
1. Nhúng sensor vào nước → Xem giá trị raw
2. Để sensor khô → Xem giá trị raw
3. Nếu cả 2 trường hợp đều = 0 → Sensor có thể bị hỏng

**Giá trị mong đợi:**
- Đất khô: 800-1000 (hoặc cao hơn)
- Đất ướt: 200-300 (hoặc thấp hơn)
- Nếu giá trị = 0 → Sensor không hoạt động

---

## 🔧 Code Đã Sửa

**Thêm cảnh báo khi giá trị = 0:**
```cpp
if (soilRaw == 0 || soilRaw < 10) {
  Serial.print(" ⚠️ Sensor có thể chưa nối đúng!");
  soilRaw = SOIL_RAW_WET;  // Tạm thời set về giá trị ướt
}
```

**Thêm debug đọc nhiều pin:**
```cpp
Serial.print(" | GPIO2: ");
Serial.print(analogRead(2));
Serial.print(" | GPIO32: ");
Serial.print(analogRead(32));
// ... các pin khác
```

---

## 📋 Checklist

- [ ] Kiểm tra wiring: VCC, GND, Signal
- [ ] Xem Serial Monitor để tìm pin có giá trị khác 0
- [ ] Đổi `SOIL_PIN` nếu cần (thử GPIO32)
- [ ] Test sensor bằng cách nhúng vào nước
- [ ] Kiểm tra sensor có bị hỏng không

---

## 🎯 Kết Quả Mong Đợi

**Sau khi sửa:**
- ✅ Soil Raw có giá trị > 0 (ví dụ: 200-1000)
- ✅ Soil Percentage thay đổi theo độ ẩm thực tế
- ✅ Không còn cảnh báo "Sensor có thể chưa nối đúng!"

---

**Hãy kiểm tra wiring và xem Serial Monitor để tìm pin đúng!** 🔧✨

# 🔧 Fix Soil & Light Sensor Luôn Đọc 0 hoặc 100%

## 🔍 Vấn Đề

**Soil sensor và Light sensor luôn đọc được:**
- Soil: 0% hoặc 100%
- Light: 0% hoặc 100%

**Nguyên nhân có thể:**
1. **Soil sensor:**
   - Sensor chưa nối đúng pin
   - Giá trị raw = 0 → code set về 100% (hoặc ngược lại)
   - Calibration values (SOIL_RAW_DRY, SOIL_RAW_WET) không đúng
   - Sensor đọc ngược (khô = thấp, ướt = cao)

2. **Light sensor:**
   - Logic đọc sai (HIGH/LOW ngược)
   - Sensor luôn HIGH hoặc luôn LOW
   - Cần đảo ngược logic

---

## ✅ Giải Pháp

### Bước 1: Kiểm Tra Serial Monitor

**Sau khi upload code, mở Serial Monitor và xem:**

```
DEBUG - Soil Raw: 0 | GPIO2: 0 | GPIO32: 1234 | GPIO33: 567 | ...
```

**Tìm pin nào có giá trị thay đổi khi:**
- Chạm tay vào sensor (soil)
- Che/không che ánh sáng (light)

**Nếu thấy:**
- `GPIO32: 1234` thay đổi → Sensor nối vào GPIO32, không phải GPIO2
- `GPIO33: 567` thay đổi → Sensor nối vào GPIO33

---

### Bước 2: Sửa Pin Nếu Sai

**Nếu tìm thấy pin đúng (ví dụ GPIO32), sửa trong code:**

```cpp
#define SOIL_PIN     32        // Thay vì GPIO2
```

**Hoặc nếu light sensor nối sai pin:**

```cpp
#define LIGHT_PIN    19        // Thay vì GPIO5
```

---

### Bước 3: Hiệu Chỉnh Soil Sensor Calibration

**Nếu sensor đọc được giá trị nhưng luôn 0% hoặc 100%:**

1. **Đọc giá trị raw khi đất khô:**
   - Xem Serial Monitor: `Soil Raw: 4095` (ví dụ)
   - Ghi lại giá trị này

2. **Đọc giá trị raw khi đất ướt:**
   - Nhúng sensor vào nước
   - Xem Serial Monitor: `Soil Raw: 500` (ví dụ)
   - Ghi lại giá trị này

3. **Sửa calibration values:**

```cpp
// Nếu đất khô = 4095, đất ướt = 500
int SOIL_RAW_DRY = 4095;   // Giá trị khi đất khô
int SOIL_RAW_WET = 500;     // Giá trị khi đất ướt
```

**Nếu sensor đọc ngược (khô = thấp, ướt = cao):**

```cpp
// Đảo ngược: khô = 500, ướt = 4095
int SOIL_RAW_DRY = 500;     // Giá trị khi đất khô (thấp)
int SOIL_RAW_WET = 4095;     // Giá trị khi đất ướt (cao)
```

---

### Bước 4: Sửa Logic Light Sensor

**Nếu light sensor luôn 0% hoặc 100%:**

1. **Kiểm tra giá trị digital:**
   - Xem Serial Monitor: `Light Digital: 1` (HIGH) hoặc `0` (LOW)
   - Che ánh sáng → giá trị thay đổi không?

2. **Nếu giá trị không thay đổi:**
   - Sensor có thể bị lỗi hoặc nối sai pin
   - Thử đổi pin khác

3. **Nếu giá trị thay đổi nhưng logic sai:**
   - Uncomment dòng đảo ngược logic trong code:

```cpp
// Thay vì:
lightPct = (lightValue == HIGH) ? 100 : 0;

// Thử:
lightPct = (lightValue == LOW) ? 100 : 0;
```

---

### Bước 5: Test Lại

**Sau khi sửa, test lại:**

1. **Soil sensor:**
   - Khô tay → Phải thấy giá trị thay đổi (không phải luôn 0% hoặc 100%)
   - Ướt tay → Phải thấy giá trị thay đổi

2. **Light sensor:**
   - Che ánh sáng → Phải thấy giá trị thay đổi
   - Không che → Phải thấy giá trị thay đổi

---

## 🔍 Debug Chi Tiết

**Nếu vẫn không hoạt động, thêm debug code:**

```cpp
// Trong loop(), thêm:
Serial.print(" | Soil Raw: ");
Serial.print(soilRaw);
Serial.print(" | Soil %: ");
Serial.print(soilPct);
Serial.print(" | Light Digital: ");
Serial.print(lightValue);
Serial.print(" | Light %: ");
Serial.println(lightPct);
```

**Xem giá trị thay đổi như thế nào khi:**
- Chạm vào soil sensor
- Che/không che light sensor

---

## 📋 Checklist

- [ ] Đã kiểm tra Serial Monitor để tìm pin đúng
- [ ] Đã sửa pin nếu sai
- [ ] Đã hiệu chỉnh SOIL_RAW_DRY và SOIL_RAW_WET
- [ ] Đã thử đảo ngược logic light sensor
- [ ] Đã test lại và thấy giá trị thay đổi

---

## 🎯 Kết Quả Mong Đợi

**Sau khi fix:**
- ✅ Soil sensor đọc được giá trị thay đổi (không phải luôn 0% hoặc 100%)
- ✅ Light sensor đọc được giá trị thay đổi (không phải luôn 0% hoặc 100%)
- ✅ Giá trị phản ánh đúng trạng thái thực tế

---

**Hãy kiểm tra Serial Monitor và sửa pin/calibration!** 🔧✨

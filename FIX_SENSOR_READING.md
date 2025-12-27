# 🔧 Fix Cảm Biến Độ Ẩm Đất và Ánh Sáng

## ❌ Vấn Đề

- **Độ ẩm đất:** Luôn hiển thị 100% không đổi
- **Cảm biến ánh sáng:** Luôn hiển thị 100% không đổi

---

## ✅ Giải Pháp 1: Hiệu Chuẩn Lại Cảm Biến Đất

### Vấn Đề:
Giá trị hiệu chuẩn `SOIL_RAW_DRY` và `SOIL_RAW_WET` có thể không đúng với cảm biến của bạn.

### Cách Sửa:

1. **Thêm code debug để xem giá trị thô:**
   - Xem giá trị `soilRaw` trong Serial Monitor
   - Ghi lại giá trị khi đất khô hoàn toàn
   - Ghi lại giá trị khi đất ướt hoàn toàn

2. **Cập nhật giá trị hiệu chuẩn:**
   ```cpp
   // Thay đổi các giá trị này dựa trên giá trị thực tế
   int SOIL_RAW_DRY = 4095;   // Giá trị khi đất khô (thường là 4095)
   int SOIL_RAW_WET = 2000;   // Giá trị khi đất ướt (có thể là 1500-2500)
   ```

---

## ✅ Giải Pháp 2: Sửa Logic Đọc Ánh Sáng

### Vấn Đề:
Logic đọc LDR có thể sai - đang đọc digital nhưng logic có thể không đúng.

### Cách Sửa:

**Thay đổi code đọc ánh sáng:**

```cpp
// Đọc ánh sáng (LDR Module - Digital)
int lightPct = 0;
int highCount = 0;
for (int i = 0; i < 5; i++) {
  if (digitalRead(LIGHT_PIN) == HIGH) highCount++;
  delay(2);
}
lightPct = (highCount * 100) / 5;
```

**Thành:**

```cpp
// Đọc ánh sáng (LDR Module - Digital)
// HIGH = Sáng, LOW = Tối
int lightValue = digitalRead(LIGHT_PIN);
int lightPct = lightValue == HIGH ? 100 : 0;
```

**Hoặc nếu LDR Module có logic ngược (HIGH = Tối, LOW = Sáng):**

```cpp
// Đọc ánh sáng (LDR Module - Digital)
// Nếu HIGH = Tối, LOW = Sáng
int lightValue = digitalRead(LIGHT_PIN);
int lightPct = lightValue == LOW ? 100 : 0;
```

---

## ✅ Giải Pháp 3: Thêm Debug Code

Thêm code để xem giá trị thô của cảm biến:

```cpp
// Trong loop(), sau khi đọc sensors:
Serial.print("DEBUG - Soil Raw: ");
Serial.print(soilRaw);
Serial.print(", Light Digital: ");
Serial.println(digitalRead(LIGHT_PIN));
```

---

## 🎯 Các Bước Thực Hiện

### Bước 1: Thêm Debug Code

Thêm dòng này vào code để xem giá trị thô:

```cpp
Serial.print("DEBUG - Soil Raw: ");
Serial.print(soilRaw);
Serial.print(", Light Digital: ");
Serial.println(digitalRead(LIGHT_PIN));
```

### Bước 2: Upload và Xem Serial Monitor

1. **Upload code**
2. **Xem Serial Monitor**
3. **Ghi lại giá trị:**
   - `Soil Raw` khi đất khô
   - `Soil Raw` khi đất ướt
   - `Light Digital` khi sáng (HIGH hay LOW?)
   - `Light Digital` khi tối (HIGH hay LOW?)

### Bước 3: Cập Nhật Giá Trị Hiệu Chuẩn

Dựa trên giá trị thực tế, cập nhật:
- `SOIL_RAW_DRY` và `SOIL_RAW_WET`
- Logic đọc ánh sáng

---

## 💡 Lưu Ý

**Cảm biến đất:**
- Giá trị cao (4095) = Đất khô
- Giá trị thấp (1500-2500) = Đất ướt
- Cần hiệu chuẩn dựa trên cảm biến thực tế

**Cảm biến ánh sáng (LDR Module):**
- Có thể HIGH = Sáng, LOW = Tối
- Hoặc ngược lại: HIGH = Tối, LOW = Sáng
- Cần test để xác định logic

---

**Hãy thêm debug code và cho tôi biết giá trị thô bạn thấy!** 🔧✨



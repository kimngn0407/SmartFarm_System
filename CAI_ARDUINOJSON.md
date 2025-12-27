# 📚 Cài ArduinoJson Library

## ✅ Tin Tốt!

**Lỗi DHT.h đã được fix!** 🎉

Bây giờ cần cài thư viện **ArduinoJson**.

---

## ✅ Giải Pháp: Cài ArduinoJson Library

### Cách 1: Cài Qua Library Manager (Khuyên Dùng)

1. **Mở Arduino IDE**

2. **Tools** → **Manage Libraries...** (hoặc `Ctrl + Shift + I`)

3. **Tìm thư viện:**
   - Gõ: **`ArduinoJson`**
   - Tìm: **`ArduinoJson by Benoit Blanchon`**

4. **Click "Install"**
   - Chọn version **6.x.x** hoặc **7.x.x** (khuyên dùng 6.x.x cho ESP32)
   - Đợi cài xong

5. **Restart Arduino IDE:**
   - **File** → **Exit**
   - Mở lại Arduino IDE

6. **Mở lại file code:**
   - **File** → **Open**
   - Chọn: `E:\SmartFarm\Arduino_SmartFarm_Demo\Arduino_SmartFarm_Demo.ino`

7. **Chọn Board ESP32:**
   - **Tools** → **Board** → **ESP32 Arduino** → **ESP32 Dev Module**

8. **Compile lại:** **Ctrl + R**

---

### Cách 2: Copy Thư Viện Vào E:\lib\libraries

**Nếu đã cài ArduinoJson nhưng vẫn lỗi:**

1. **Mở File Explorer**

2. **Tìm thư viện ArduinoJson:**
   - Vào: `C:\Users\ASUS\AppData\Local\Arduino15\libraries`
   - Tìm thư mục: `ArduinoJson`

3. **Copy thư mục:**
   - Từ: `C:\Users\ASUS\AppData\Local\Arduino15\libraries\ArduinoJson`
   - Đến: `E:\lib\libraries\ArduinoJson`

4. **Restart Arduino IDE**

5. **Compile lại**

---

## 🎯 Checklist

- [ ] Đã cài **ArduinoJson by Benoit Blanchon**
- [ ] Đã restart Arduino IDE
- [ ] Đã mở lại file code
- [ ] Đã chọn Board: **ESP32 Dev Module**
- [ ] Đã compile lại
- [ ] Không còn lỗi

---

## 💡 Lưu Ý

**Version ArduinoJson:**
- **Version 6.x.x:** Khuyên dùng cho ESP32 (ổn định)
- **Version 7.x.x:** Mới hơn, nhưng có thể cần code thay đổi

**Sau khi cài:**
- Phải restart Arduino IDE
- Phải chọn Board ESP32
- Phải mở lại file code

---

**Hãy làm theo Cách 1 (Cài qua Library Manager) - Đây là cách đơn giản nhất!** 📚✨



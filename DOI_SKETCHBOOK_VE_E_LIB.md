# 🔧 Đổi Sketchbook Location Về E:\lib

## ✅ Phát Hiện

- ✅ Thư viện DHT vẫn còn ở: `E:\lib\libraries\DHT_sensor_library\DHT.h`
- ❌ Sketchbook location hiện tại: `c:\Users\ASUS\OneDrive\Tài liệu\Arduino`
- ❌ Arduino IDE không tìm thấy thư viện ở `E:\lib` nữa!

---

## ✅ Giải Pháp: Đổi Sketchbook Location

### Bước 1: Đổi Sketchbook Location

1. **Mở Arduino IDE**

2. **Tools** → **Preferences** (hoặc **File** → **Preferences**)

3. **Sketchbook location:** Click nút **BROWSE**

4. **Chọn thư mục:** `E:\lib`

5. **Click OK**

6. **Arduino IDE sẽ hỏi:** "The sketchbook folder has been changed. The IDE will restart."
   - Click **OK**

7. **Arduino IDE sẽ tự động restart**

---

### Bước 2: Mở Lại File Code

1. **Sau khi Arduino IDE restart:**

2. **File** → **Open**

3. Chọn: `E:\SmartFarm\Arduino_SmartFarm_Demo\Arduino_SmartFarm_Demo.ino`

---

### Bước 3: Chọn Board ESP32

1. **Tools** → **Board** → **ESP32 Arduino** → **ESP32 Dev Module**

2. **Nếu không thấy "ESP32 Arduino":**
   - **Tools** → **Board** → **Boards Manager...**
   - Tìm: **`esp32`**
   - Cài: **`esp32 by Espressif Systems`**

---

### Bước 4: Compile Lại

1. **Compile:** **Ctrl + R**

2. **Kết quả:**
   - ✅ **Nếu compile được:** Đã fix!
   - ❌ **Nếu vẫn lỗi:** Xem Bước 5

---

### Bước 5: Kiểm Tra Thư Viện (Nếu Vẫn Lỗi)

1. **Mở File Explorer**

2. Vào: `E:\lib\libraries\DHT_sensor_library`

3. **Phải có file:** `DHT.h`

4. **Nếu không có:**
   - Copy từ: `C:\Users\ASUS\AppData\Local\Arduino15\libraries\DHT_sensor_library`
   - Đến: `E:\lib\libraries\DHT_sensor_library`

---

## 🎯 Checklist

- [ ] Đã đổi Sketchbook location về `E:\lib`
- [ ] Arduino IDE đã restart
- [ ] Đã mở lại file code
- [ ] Đã chọn Board: **ESP32 Dev Module**
- [ ] Đã compile lại
- [ ] Không còn lỗi

---

## 💡 Lưu Ý

**Tại sao cần đổi Sketchbook location?**
- Arduino IDE tìm thư viện ở: `Sketchbook location\libraries`
- Nếu Sketchbook location là `E:\lib` → IDE sẽ tìm ở `E:\lib\libraries`
- Thư viện DHT đã có ở `E:\lib\libraries\DHT_sensor_library` → IDE sẽ tìm thấy!

**Sau khi đổi:**
- Arduino IDE sẽ tự động restart
- Phải mở lại file code
- Phải chọn Board ESP32

---

**Hãy làm theo Bước 1 → Bước 4 và cho tôi biết kết quả!** 🔧✨



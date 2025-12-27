# ✅ Bước Tiếp Theo Sau Khi Cài DHT Library

## 🎉 Bạn Đã Cài Thành Công!

Thư viện **DHT sensor library by Adafruit (1.4.6)** đã được cài đặt!

---

## 📋 Các Bước Tiếp Theo

### Bước 1: Kiểm Tra Các Thư Viện Khác

Code SmartFarm cần các thư viện sau:

1. ✅ **DHT sensor library** - Đã cài (1.4.6)
2. ⚠️ **ArduinoJson** - Cần kiểm tra
3. ✅ **WiFi, HTTPClient, time** - Có sẵn trong ESP32

**Kiểm tra ArduinoJson:**
1. Mở **Tools** → **Manage Libraries...**
2. Tìm: **`ArduinoJson`**
3. Tìm: **`ArduinoJson by Benoit Blanchon`**
4. Nếu chưa có → Click **Install**

---

### Bước 2: Mở File Code Đúng

**Quan trọng:** Mở file code chính:
- ✅ `e:\SmartFarm\Arduino_SmartFarm_Demo.ino`
- ❌ KHÔNG dùng `sketch_dec24a.ino`

**Cách mở:**
1. **File** → **Open**
2. Chọn: `e:\SmartFarm\Arduino_SmartFarm_Demo.ino`

---

### Bước 3: Cấu Hình Board và Port

**Trong Arduino IDE:**

1. **Tools** → **Board** → **ESP32 Arduino** → **ESP32 Dev Module**

2. **Tools** → **Port** → Chọn COM port của ESP32 (ví dụ: COM9)

3. **Tools** → **Upload Speed** → **115200**

4. **Tools** → **Erase All Flash Before Sketch Upload** → **Enabled** (nếu có)

---

### Bước 4: Compile Code

1. **Nhấn Ctrl + R** (hoặc **Sketch** → **Verify/Compile**)

2. **Đợi compile hoàn tất**

3. **Nếu thành công:**
   - Sẽ thấy: `Sketch uses XXXXX bytes (XX%) of program storage space`
   - Không có lỗi màu đỏ

4. **Nếu có lỗi:**
   - Đọc thông báo lỗi
   - Kiểm tra xem còn thiếu thư viện nào không

---

### Bước 5: Upload Code

1. **Nhấn nút Upload** (mũi tên →) hoặc **Ctrl + U**

2. **Nhấn nút RESET** trên ESP32 (nếu được yêu cầu)

3. **Đợi upload hoàn tất**

4. **Nếu thành công:**
   - Sẽ thấy: `Hard resetting via RTS pin...`
   - ESP32 sẽ tự động chạy code mới

---

### Bước 6: Mở Serial Monitor

1. **Tools** → **Serial Monitor** (hoặc **Ctrl + Shift + M**)

2. **Baud rate:** `115200` (QUAN TRỌNG!)

3. **Xem log:**
   - Kết nối WiFi
   - Đọc sensors
   - Gửi dữ liệu lên server

---

## ✅ Checklist Hoàn Chỉnh

### Trước Khi Compile:
- [x] Đã cài `DHT sensor library by Adafruit` (1.4.6)
- [ ] Đã cài `ArduinoJson` (nếu chưa có)
- [ ] Đã mở file `Arduino_SmartFarm_Demo.ino`
- [ ] Đã chọn Board: **ESP32 Dev Module**
- [ ] Đã chọn Port: **COM?** (số port của ESP32)

### Sau Khi Compile:
- [ ] Compile thành công (không có lỗi)
- [ ] Upload thành công
- [ ] Serial Monitor hiển thị log đúng

---

## 🆘 Nếu Vẫn Gặp Lỗi

### Lỗi: "ArduinoJson.h: No such file or directory"
**Giải pháp:**
1. Cài `ArduinoJson by Benoit Blanchon`
2. Compile lại

### Lỗi: "WiFi.h: No such file or directory"
**Giải pháp:**
1. Kiểm tra đã chọn Board: **ESP32 Dev Module** chưa
2. Nếu chưa → Chọn lại Board

### Lỗi: Upload failed
**Giải pháp:**
1. Nhấn nút **RESET** trên ESP32
2. Thử upload lại
3. Kiểm tra cáp USB và COM port

---

## 🎯 Tóm Tắt

1. ✅ Đã cài DHT library
2. ⏭️ Cài ArduinoJson (nếu cần)
3. ⏭️ Mở file `Arduino_SmartFarm_Demo.ino`
4. ⏭️ Chọn Board và Port
5. ⏭️ Compile và Upload
6. ⏭️ Mở Serial Monitor xem log

---

**Chúc bạn thành công!** 🚀✨



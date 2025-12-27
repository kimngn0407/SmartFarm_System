# 📚 Cách Cài Đặt Thư Viện DHT.h

## ❌ Lỗi
```
fatal error: DHT.h: No such file or directory
```

**Nguyên nhân:** Chưa cài đặt thư viện DHT Sensor Library

---

## ✅ Giải Pháp: Cài Đặt Thư Viện

### Cách 1: Qua Library Manager (Khuyến nghị)

**Bước 1: Mở Library Manager**
1. Mở **Arduino IDE**
2. Vào menu **Tools** → **Manage Libraries...**
   - Hoặc nhấn `Ctrl + Shift + I`

**Bước 2: Tìm và Cài Đặt**
1. Trong ô tìm kiếm, gõ: **`DHT sensor library`**
2. Tìm thư viện: **`DHT sensor library by Adafruit`**
3. Click **Install** (có thể cần cài thêm `Adafruit Unified Sensor` nếu được hỏi)

**Bước 3: Xác Nhận**
- Đợi cài đặt hoàn tất
- Đóng Library Manager

**Bước 4: Kiểm Tra**
- Mở lại file code
- Compile lại (Ctrl + R)
- Nếu không còn lỗi → ✅ Thành công!

---

### Cách 2: Qua GitHub (Nếu cách 1 không được)

**Bước 1: Download**
1. Truy cập: https://github.com/adafruit/DHT-sensor-library
2. Click **Code** → **Download ZIP**

**Bước 2: Cài Đặt**
1. Mở **Arduino IDE**
2. Vào menu **Sketch** → **Include Library** → **Add .ZIP Library...**
3. Chọn file ZIP vừa download
4. Click **Open**

**Bước 3: Kiểm Tra**
- Compile lại code
- Nếu không còn lỗi → ✅ Thành công!

---

## 📋 Thư Viện Cần Thiết Cho SmartFarm

### 1. DHT Sensor Library
- **Tên:** `DHT sensor library by Adafruit`
- **Dùng cho:** DHT11, DHT22
- **Cài:** Tools → Manage Libraries → Tìm "DHT sensor"

### 2. Adafruit Unified Sensor (Tự động cài cùng DHT)
- **Tên:** `Adafruit Unified Sensor`
- **Dùng cho:** Hỗ trợ DHT library
- **Cài:** Tự động khi cài DHT

### 3. ArduinoJson (Đã có trong code)
- **Tên:** `ArduinoJson by Benoit Blanchon`
- **Dùng cho:** Gửi JSON lên server
- **Cài:** Tools → Manage Libraries → Tìm "ArduinoJson"

---

## ✅ Checklist Sau Khi Cài

- [ ] Đã cài `DHT sensor library by Adafruit`
- [ ] Đã cài `Adafruit Unified Sensor` (nếu được hỏi)
- [ ] Đã cài `ArduinoJson` (nếu chưa có)
- [ ] Đã compile lại code
- [ ] Không còn lỗi `DHT.h: No such file or directory`

---

## 🆘 Nếu Vẫn Gặp Lỗi

### Lỗi 1: Vẫn báo thiếu DHT.h
**Giải pháp:**
1. Đóng Arduino IDE hoàn toàn
2. Mở lại Arduino IDE
3. Compile lại code

### Lỗi 2: Không tìm thấy thư viện trong Library Manager
**Giải pháp:**
1. Kiểm tra kết nối internet
2. Cập nhật Arduino IDE lên phiên bản mới nhất
3. Thử cách 2 (cài qua GitHub)

### Lỗi 3: Lỗi khi compile sau khi cài
**Giải pháp:**
1. Xóa thư viện cũ (nếu có):
   - Vào `C:\Users\ASUS\Documents\Arduino\libraries`
   - Xóa thư mục `DHT-sensor-library` (nếu có)
2. Cài lại thư viện mới
3. Restart Arduino IDE

---

## 📝 Lưu Ý

- **Phải cài đúng thư viện:** `DHT sensor library by Adafruit`
- **Không phải:** `DHT11` hoặc `DHT` (các thư viện khác)
- **Sau khi cài:** Phải restart Arduino IDE hoặc đóng/mở lại

---

**Sau khi cài xong, compile lại code và cho tôi biết kết quả!** 📚✨



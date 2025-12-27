# 🔧 Fix Lỗi DHT.h Ngay Lập Tức

## ❌ Lỗi Hiện Tại
```
E:\SmartFarm\Arduino_SmartFarm_Demo\Arduino_SmartFarm_Demo.ino:10:10: 
fatal error: DHT.h: No such file or directory
```

---

## ✅ Giải Pháp Từng Bước (Làm Theo Thứ Tự)

### Bước 1: Kiểm Tra Board Đã Chọn Đúng

**QUAN TRỌNG:** Phải chọn Board ESP32 trước khi compile!

1. **Tools** → **Board** → **ESP32 Arduino** → **ESP32 Dev Module**

2. **Nếu không thấy "ESP32 Arduino":**
   - Cần cài ESP32 Board trước
   - **Tools** → **Board** → **Boards Manager...**
   - Tìm: **`esp32`**
   - Cài: **`esp32 by Espressif Systems`**
   - Đợi cài xong (có thể mất 5-10 phút)

3. **Sau khi cài xong:**
   - **Tools** → **Board** → **ESP32 Arduino** → **ESP32 Dev Module**

---

### Bước 2: Restart Arduino IDE

**BẮT BUỘC:** Sau khi cài thư viện, phải restart!

1. **Đóng Arduino IDE hoàn toàn:**
   - Click **X** để đóng
   - Hoặc **File** → **Exit**

2. **Mở lại Arduino IDE**

3. **Mở lại file code:**
   - **File** → **Open**
   - Chọn: `E:\SmartFarm\Arduino_SmartFarm_Demo\Arduino_SmartFarm_Demo.ino`

---

### Bước 3: Kiểm Tra Thư Viện Đã Cài

1. **Tools** → **Manage Libraries...**

2. Tìm: **`DHT sensor`**

3. Kiểm tra:
   - ✅ Có hiển thị **"installed"** không?
   - ✅ Version là **1.4.6** hoặc mới hơn?

4. **Nếu chưa có "installed":**
   - Click **Install** lại
   - Đợi cài xong
   - **Restart Arduino IDE**

---

### Bước 4: Cài Adafruit Unified Sensor

**QUAN TRỌNG:** DHT library cần thư viện này!

1. **Tools** → **Manage Libraries...**

2. Tìm: **`Adafruit Unified Sensor`**

3. Tìm: **`Adafruit Unified Sensor by Adafruit`**

4. Click **Install**

5. **Restart Arduino IDE**

---

### Bước 5: Compile Lại

1. **Đảm bảo:**
   - ✅ Board: **ESP32 Dev Module**
   - ✅ Đã restart Arduino IDE
   - ✅ Đã cài DHT sensor library
   - ✅ Đã cài Adafruit Unified Sensor

2. **Compile:**
   - Nhấn **Ctrl + R** (hoặc **Sketch** → **Verify/Compile**)

3. **Nếu vẫn lỗi:**
   - Xem thông báo lỗi mới
   - Gửi cho tôi để xử lý tiếp

---

## 🎯 Checklist Nhanh

- [ ] **Tools** → **Board** → **ESP32 Dev Module** (QUAN TRỌNG!)
- [ ] Đã **restart Arduino IDE** sau khi cài thư viện
- [ ] Đã cài **DHT sensor library by Adafruit**
- [ ] Đã cài **Adafruit Unified Sensor**
- [ ] Đã mở lại file code sau khi restart
- [ ] Đã compile lại

---

## 🆘 Nếu Vẫn Lỗi

**Gửi cho tôi:**
1. **Thông báo lỗi đầy đủ** (copy toàn bộ)
2. **Board đã chọn:** Tools → Board → ?
3. **Thư viện đã cài:** Tools → Manage Libraries → DHT sensor → ?

---

**Hãy thử Bước 1 (Chọn Board ESP32) trước - Đây là nguyên nhân phổ biến nhất!** 🔧✨



# 🔧 Fix Lỗi DHT.h - Giải Pháp Cuối Cùng

## ❌ Vấn Đề

Đã cài **DHT sensor library** nhưng vẫn báo lỗi:
```
fatal error: DHT.h: No such file or directory
```

---

## ✅ Giải Pháp Chắc Chắn

### Bước 1: Kiểm Tra Board ESP32 (QUAN TRỌNG NHẤT!)

**Nguyên nhân chính:** Chưa chọn Board ESP32 → Arduino IDE không tìm thấy thư viện!

1. **Mở Arduino IDE**

2. **Tools** → **Board** → Xem đang chọn gì?

3. **Nếu KHÔNG thấy "ESP32 Arduino":**
   - **Tools** → **Board** → **Boards Manager...**
   - Tìm: **`esp32`**
   - Cài: **`esp32 by Espressif Systems`** (version 3.x.x)
   - Đợi cài xong (5-10 phút)

4. **Sau khi cài xong:**
   - **Tools** → **Board** → **ESP32 Arduino** → **ESP32 Dev Module**
   - **QUAN TRỌNG:** Phải chọn Board này trước khi compile!

---

### Bước 2: Xóa và Cài Lại Thư Viện

**Nếu Board đã đúng nhưng vẫn lỗi:**

1. **Xóa thư viện cũ:**
   - Vào: `C:\Users\ASUS\Documents\Arduino\libraries`
   - Xóa thư mục: `DHT_sensor_library` (nếu có)
   - Xóa thư mục: `DHT-sensor-library` (nếu có)

2. **Cài lại:**
   - **Tools** → **Manage Libraries...**
   - Tìm: **`DHT sensor library by Adafruit`**
   - Click **Remove** (nếu có)
   - Click **Install** lại
   - Chọn version **1.4.6** hoặc mới hơn

3. **Cài Adafruit Unified Sensor:**
   - **Tools** → **Manage Libraries...**
   - Tìm: **`Adafruit Unified Sensor by Adafruit`**
   - Click **Install**

---

### Bước 3: Restart Arduino IDE

**BẮT BUỘC:** Sau mỗi lần cài thư viện!

1. **Đóng Arduino IDE hoàn toàn:**
   - **File** → **Exit**
   - Hoặc click **X**

2. **Mở lại Arduino IDE**

3. **Mở lại file code:**
   - **File** → **Open**
   - Chọn: `E:\SmartFarm\Arduino_SmartFarm_Demo\Arduino_SmartFarm_Demo.ino`

---

### Bước 4: Kiểm Tra Lại

1. **Tools** → **Board** → Phải là **ESP32 Dev Module**

2. **Tools** → **Manage Libraries...**
   - Tìm: **`DHT sensor`**
   - Phải thấy: **"installed"** (màu xanh)

3. **Compile:**
   - **Ctrl + R**
   - Xem kết quả

---

## 🔍 Kiểm Tra Thủ Công

### Kiểm Tra Thư Viện Đã Cài:

1. **Mở File Explorer**

2. Vào: `C:\Users\ASUS\Documents\Arduino\libraries`

3. Kiểm tra có thư mục: **`DHT_sensor_library`** không?

4. **Nếu có:**
   - Mở thư mục đó
   - Kiểm tra có file **`DHT.h`** không?
   - Nếu không có → Cài lại thư viện

5. **Nếu không có:**
   - Cài lại thư viện
   - Restart Arduino IDE

---

## 🎯 Checklist Đầy Đủ

### Trước Khi Compile:
- [ ] **Tools** → **Board** → **ESP32 Dev Module** ✅ (QUAN TRỌNG!)
- [ ] Đã cài **ESP32 Board** trong Boards Manager
- [ ] Đã cài **DHT sensor library by Adafruit**
- [ ] Đã cài **Adafruit Unified Sensor**
- [ ] Đã **restart Arduino IDE** sau khi cài
- [ ] Đã mở lại file code

### Khi Compile:
- [ ] Nhấn **Ctrl + R**
- [ ] Xem thông báo lỗi (nếu có)

---

## 🆘 Nếu Vẫn Lỗi

**Vui lòng cung cấp:**

1. **Tools** → **Board** → Đang chọn gì? (chụp màn hình hoặc ghi rõ)
2. **Tools** → **Manage Libraries...** → DHT sensor → Có hiển thị "installed" không?
3. **Thông báo lỗi đầy đủ** (copy toàn bộ)

---

## 💡 Mẹo

**Nếu Board chưa được chọn:**
- Arduino IDE sẽ không tìm thấy thư viện ESP32
- Phải chọn Board ESP32 trước khi compile!

**Nếu đã chọn Board nhưng vẫn lỗi:**
- Restart Arduino IDE
- Xóa và cài lại thư viện
- Kiểm tra thư mục libraries có file DHT.h không

---

**Hãy kiểm tra Bước 1 (Chọn Board ESP32) - Đây là nguyên nhân 90% các trường hợp!** 🔧✨



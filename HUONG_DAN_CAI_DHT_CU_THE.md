# 📚 Hướng Dẫn Cài DHT Library - Cụ Thể Từng Bước

## ❌ Vấn Đề

Thư viện DHT **KHÔNG có** trong thư mục libraries → Cần cài lại!

---

## ✅ Cách Cài: Qua Library Manager

### Bước 1: Mở Library Manager

1. **Mở Arduino IDE**

2. **Tools** → **Manage Libraries...**
   - Hoặc nhấn: **`Ctrl + Shift + I`**

---

### Bước 2: Tìm và Cài DHT Sensor Library

1. **Trong ô tìm kiếm**, gõ: **`DHT sensor`**

2. **Tìm thư viện:**
   - **`DHT sensor library by Adafruit`**
   - Version: **1.4.6** hoặc mới hơn

3. **Click vào thư viện**

4. **Nếu thấy nút "Remove":**
   - Click **Remove** trước (để xóa version cũ nếu có)

5. **Click "Install"**
   - Đợi cài xong (có thể mất 1-2 phút)

6. **Nếu được hỏi cài "Adafruit Unified Sensor":**
   - Click **Install All** hoặc **Install**

---

### Bước 3: Cài Adafruit Unified Sensor (Nếu Chưa Có)

1. **Trong Library Manager**, tìm: **`Adafruit Unified Sensor`**

2. **Tìm:**
   - **`Adafruit Unified Sensor by Adafruit`**

3. **Click "Install"**

---

### Bước 4: Chọn Board ESP32

**QUAN TRỌNG:** Phải chọn Board trước khi compile!

1. **Tools** → **Board** → **ESP32 Arduino** → **ESP32 Dev Module**

2. **Nếu không thấy "ESP32 Arduino":**
   - **Tools** → **Board** → **Boards Manager...**
   - Tìm: **`esp32`**
   - Cài: **`esp32 by Espressif Systems`**
   - Đợi cài xong

---

### Bước 5: Restart Arduino IDE

1. **Đóng Arduino IDE hoàn toàn:**
   - **File** → **Exit**

2. **Mở lại Arduino IDE**

3. **Mở lại file code:**
   - **File** → **Open**
   - Chọn: `E:\SmartFarm\Arduino_SmartFarm_Demo\Arduino_SmartFarm_Demo.ino`

---

### Bước 6: Compile

1. **Kiểm tra:**
   - ✅ Board: **ESP32 Dev Module**
   - ✅ Đã cài DHT sensor library
   - ✅ Đã restart Arduino IDE

2. **Compile:**
   - Nhấn **Ctrl + R**

3. **Nếu thành công:**
   - Sẽ thấy: `Sketch uses XXXXX bytes...`
   - Không có lỗi màu đỏ

---

## 🔍 Kiểm Tra Sau Khi Cài

### Cách 1: Qua Library Manager

1. **Tools** → **Manage Libraries...**

2. Tìm: **`DHT sensor`**

3. **Phải thấy:**
   - ✅ **"installed"** (màu xanh)
   - ✅ Version: **1.4.6** hoặc mới hơn

---

### Cách 2: Qua File Explorer

1. **Mở File Explorer**

2. Vào: `C:\Users\ASUS\AppData\Local\Arduino15\libraries`

3. **Kiểm tra có thư mục:**
   - ✅ **`DHT_sensor_library`**

4. **Mở thư mục đó:**
   - Phải có file: **`DHT.h`**
   - Phải có file: **`DHT.cpp`**

---

## 🆘 Nếu Vẫn Lỗi

### Lỗi: "Board not selected"
**Giải pháp:**
- **Tools** → **Board** → **ESP32 Dev Module**

### Lỗi: "Library not found"
**Giải pháp:**
1. Xóa thư viện cũ (nếu có)
2. Cài lại qua Library Manager
3. Restart Arduino IDE

### Lỗi: "Adafruit Unified Sensor required"
**Giải pháp:**
1. Cài **Adafruit Unified Sensor by Adafruit**
2. Restart Arduino IDE

---

## 📝 Checklist

- [ ] Đã mở Library Manager
- [ ] Đã tìm "DHT sensor library by Adafruit"
- [ ] Đã click Install
- [ ] Đã cài Adafruit Unified Sensor
- [ ] Đã chọn Board: **ESP32 Dev Module**
- [ ] Đã restart Arduino IDE
- [ ] Đã compile lại
- [ ] Không còn lỗi

---

## 💡 Lưu Ý

- **Phải chọn Board ESP32** trước khi compile
- **Phải restart Arduino IDE** sau khi cài thư viện
- **Phải cài cả 2 thư viện:** DHT sensor library + Adafruit Unified Sensor

---

**Hãy làm theo các bước trên và cho tôi biết kết quả!** 📚✨



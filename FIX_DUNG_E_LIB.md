# 🔧 Fix DHT - Dùng E:\lib Như Lúc Đầu

## ✅ Phát Hiện

Bạn nói **lúc đầu để ở `e:/lib` thì không lỗi DHT**!

**Giải pháp:** Copy thư viện vào `e:/lib` hoặc cấu hình Arduino IDE tìm ở đó.

---

## ✅ Giải Pháp 1: Copy Thư Viện Vào E:\lib

### Bước 1: Copy Thư Viện

1. **Mở File Explorer**

2. **Copy thư mục:**
   - Từ: `C:\Users\ASUS\AppData\Local\Arduino15\libraries\DHT_sensor_library`
   - Đến: `E:\lib\libraries\DHT_sensor_library`

3. **Copy thư mục:**
   - Từ: `C:\Users\ASUS\AppData\Local\Arduino15\libraries\Adafruit_Unified_Sensor`
   - Đến: `E:\lib\libraries\Adafruit_Unified_Sensor`

---

### Bước 2: Kiểm Tra

1. **Mở File Explorer**

2. Vào: `E:\lib\libraries\DHT_sensor_library`

3. **Phải có file:** `DHT.h`

---

### Bước 3: Restart Arduino IDE

1. **Đóng Arduino IDE hoàn toàn**

2. **Mở lại Arduino IDE**

3. **Mở lại file code**

4. **Chọn Board ESP32:**
   - **Tools** → **Board** → **ESP32 Arduino** → **ESP32 Dev Module**

---

### Bước 4: Compile Lại

1. **Compile:** **Ctrl + R**

2. **Xem kết quả**

---

## ✅ Giải Pháp 2: Đổi Sketchbook Location Về E:\lib

### Bước 1: Đổi Sketchbook Location

1. **Tools** → **Preferences**

2. **Sketchbook location:** Click **BROWSE**

3. **Chọn:** `E:\lib` (hoặc `E:\lib\libraries` nếu có thư mục libraries)

4. **Click OK**

5. **Restart Arduino IDE** (sẽ được hỏi)

---

### Bước 2: Copy Thư Viện Vào Sketchbook

1. **Mở File Explorer**

2. Vào: `E:\lib\libraries` (hoặc tạo thư mục `libraries` nếu chưa có)

3. **Copy thư mục:**
   - `DHT_sensor_library`
   - `Adafruit_Unified_Sensor`

---

### Bước 3: Restart và Compile

1. **Restart Arduino IDE**

2. **Mở lại file code**

3. **Chọn Board ESP32**

4. **Compile:** **Ctrl + R**

---

## ✅ Giải Pháp 3: Giữ Nguyên và Copy Vào Cả 2 Nơi

**An toàn nhất:** Copy thư viện vào cả 2 nơi!

1. **Giữ nguyên:** `C:\Users\ASUS\AppData\Local\Arduino15\libraries\DHT_sensor_library`
2. **Copy thêm:** `E:\lib\libraries\DHT_sensor_library`

**Arduino IDE sẽ tìm ở cả 2 nơi!**

---

## 🎯 Khuyên Dùng

**Giải Pháp 1 (Copy vào E:\lib)** - Đơn giản nhất!

1. Copy thư viện vào `E:\lib\libraries\`
2. Restart Arduino IDE
3. Chọn Board ESP32
4. Compile

---

## 💡 Lưu Ý

**Tại sao E:\lib hoạt động?**
- Có thể Arduino IDE đã được cấu hình tìm ở đó
- Hoặc có một cấu hình nào đó đã thêm `E:\lib` vào library path
- Hoặc sketchbook location trước đó là `E:\lib`

**Sau khi copy:**
- Phải restart Arduino IDE
- Phải chọn Board ESP32
- Phải mở lại file code

---

**Hãy thử Giải Pháp 1 (Copy vào E:\lib) - Đây là cách nhanh nhất!** 🔧✨



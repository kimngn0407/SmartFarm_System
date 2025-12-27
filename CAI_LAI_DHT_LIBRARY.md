# 🔧 Cài Lại DHT Library - Hướng Dẫn Chi Tiết

## ❌ Vấn Đề

Thư viện DHT **KHÔNG có** trong thư mục libraries mặc dù đã cài!

---

## ✅ Giải Pháp: Cài Lại Thư Viện

### Bước 1: Xóa Thư Viện Cũ (Nếu Có)

1. **Mở File Explorer**

2. Vào: `C:\Users\ASUS\Documents\Arduino\libraries`

3. **Tìm và xóa** các thư mục:
   - `DHT_sensor_library`
   - `DHT-sensor-library`
   - `DHT11` (nếu có)
   - `DHT` (nếu có)

4. **Kiểm tra thư mục khác:**
   - Vào: `C:\Users\ASUS\AppData\Local\Arduino15\libraries`
   - Xóa các thư mục DHT tương tự (nếu có)

---

### Bước 2: Cài Lại Thư Viện Qua Library Manager

1. **Mở Arduino IDE**

2. **Tools** → **Manage Libraries...** (hoặc `Ctrl + Shift + I`)

3. **Tìm thư viện:**
   - Gõ: **`DHT sensor`**
   - Tìm: **`DHT sensor library by Adafruit`**

4. **Xóa thư viện cũ (nếu có):**
   - Click vào thư viện
   - Click **Remove** (nếu có nút này)

5. **Cài lại:**
   - Click **Install**
   - Chọn version **1.4.6** hoặc mới hơn
   - Đợi cài xong

6. **Cài Adafruit Unified Sensor:**
   - Tìm: **`Adafruit Unified Sensor`**
   - Cài: **`Adafruit Unified Sensor by Adafruit`**

---

### Bước 3: Kiểm Tra Thư Viện Đã Cài

1. **Mở File Explorer**

2. Vào: `C:\Users\ASUS\Documents\Arduino\libraries`

3. **Kiểm tra:**
   - Phải có thư mục: **`DHT_sensor_library`**
   - Mở thư mục đó
   - Phải có file: **`DHT.h`**

4. **Nếu không có:**
   - Cài lại thư viện
   - Restart Arduino IDE

---

### Bước 4: Chọn Board ESP32

**QUAN TRỌNG:** Phải chọn Board trước khi compile!

1. **Tools** → **Board** → **ESP32 Arduino** → **ESP32 Dev Module**

2. **Nếu không thấy "ESP32 Arduino":**
   - ESP32 Board đã được cài (đã kiểm tra)
   - Có thể cần restart Arduino IDE
   - Hoặc cài lại ESP32 Board

---

### Bước 5: Restart Arduino IDE

1. **Đóng Arduino IDE hoàn toàn:**
   - **File** → **Exit**

2. **Mở lại Arduino IDE**

3. **Mở lại file code:**
   - **File** → **Open**
   - Chọn: `E:\SmartFarm\Arduino_SmartFarm_Demo\Arduino_SmartFarm_Demo.ino`

---

### Bước 6: Compile Lại

1. **Đảm bảo:**
   - ✅ Board: **ESP32 Dev Module**
   - ✅ Đã cài DHT sensor library
   - ✅ Đã restart Arduino IDE

2. **Compile:**
   - **Ctrl + R**

3. **Nếu vẫn lỗi:**
   - Gửi thông báo lỗi mới cho tôi

---

## 🔍 Kiểm Tra Thủ Công

### Kiểm Tra Thư Viện:

**Mở PowerShell và chạy:**
```powershell
Get-ChildItem "C:\Users\ASUS\Documents\Arduino\libraries" | Where-Object { $_.Name -like '*DHT*' }
```

**Nếu không có kết quả:**
- Thư viện chưa được cài
- Cần cài lại

---

## 🎯 Checklist

- [ ] Đã xóa thư viện cũ (nếu có)
- [ ] Đã cài **DHT sensor library by Adafruit** (1.4.6)
- [ ] Đã cài **Adafruit Unified Sensor**
- [ ] Đã kiểm tra thư mục libraries có `DHT_sensor_library` không
- [ ] Đã chọn Board: **ESP32 Dev Module**
- [ ] Đã restart Arduino IDE
- [ ] Đã compile lại

---

## 🆘 Nếu Vẫn Không Được

**Thử cách 2: Cài Qua GitHub**

1. **Download:**
   - Truy cập: https://github.com/adafruit/DHT-sensor-library
   - Click **Code** → **Download ZIP**

2. **Cài đặt:**
   - **Sketch** → **Include Library** → **Add .ZIP Library...**
   - Chọn file ZIP vừa download
   - Click **Open**

3. **Restart Arduino IDE**

4. **Compile lại**

---

**Hãy làm theo các bước trên và cho tôi biết kết quả!** 🔧✨



# 📚 Giải Thích Ý Nghĩa Các Đường Dẫn

## 🔗 1. Additional Boards Manager URLs

### URL trong Preferences:
```
https://raw.githubusercontent.com/espressif/arduino-esp32/gh-pages/package_esp32_index.json
```

### Ý nghĩa:
- **Đây là URL để Arduino IDE tải danh sách Board ESP32**
- **Không phải đường dẫn thư mục trên máy tính!**
- **Là địa chỉ trên Internet** để IDE biết:
  - Có những Board ESP32 nào?
  - Version nào?
  - Cách cài đặt?

### Cách hoạt động:
1. **Arduino IDE** đọc URL này
2. **Tải file JSON** từ GitHub
3. **Hiển thị danh sách Board ESP32** trong Boards Manager
4. **Cho phép bạn cài** Board ESP32

### Tại sao cần?
- **Không có URL này:** Arduino IDE không biết Board ESP32 ở đâu
- **Có URL này:** IDE biết tải Board ESP32 từ đâu

---

## 📁 2. Sketchbook Location

### Đường dẫn hiện tại:
```
c:\Users\ASUS\OneDrive\Tài liệu\Arduino
```

### Ý nghĩa:
- **Đây là thư mục chính** của Arduino IDE trên máy bạn
- **Arduino IDE sẽ tìm:**
  - **Sketches (file code):** `Sketchbook location\`
  - **Libraries (thư viện):** `Sketchbook location\libraries\`

### Ví dụ:
- **Sketchbook location:** `E:\lib`
- **IDE sẽ tìm thư viện ở:** `E:\lib\libraries\`
- **IDE sẽ tìm sketches ở:** `E:\lib\`

### Tại sao quan trọng?
- **Nếu thư viện ở:** `E:\lib\libraries\DHT_sensor_library`
- **Nhưng Sketchbook location là:** `c:\Users\ASUS\OneDrive\Tài liệu\Arduino`
- **IDE sẽ KHÔNG tìm thấy thư viện!**
- **Phải đổi Sketchbook location về:** `E:\lib`

---

## 📂 3. Các Đường Dẫn Thư Mục

### a) Thư mục Libraries Mặc Định:
```
C:\Users\ASUS\AppData\Local\Arduino15\libraries
```

**Ý nghĩa:**
- **Thư mục chung** cho tất cả Arduino projects
- **Arduino IDE tự động tìm ở đây**
- **Không phụ thuộc vào Sketchbook location**

### b) Thư Mục Libraries Trong Sketchbook:
```
Sketchbook location\libraries
```

**Ví dụ:**
- Nếu Sketchbook location = `E:\lib`
- Thì libraries = `E:\lib\libraries`

**Ý nghĩa:**
- **Thư mục riêng** cho sketchbook của bạn
- **IDE sẽ tìm ở đây TRƯỚC** thư mục mặc định

### c) Thư Mục Thư Viện DHT:
```
E:\lib\libraries\DHT_sensor_library
```

**Ý nghĩa:**
- **Nơi chứa thư viện DHT**
- **Phải có file:** `DHT.h` trong thư mục này
- **IDE sẽ tìm file này khi compile**

---

## 🎯 Tóm Tắt

### URL (Internet):
- **Additional Boards Manager URLs:** Địa chỉ để tải Board ESP32
- **Không phải đường dẫn thư mục!**

### Đường Dẫn Thư Mục (Máy Tính):
- **Sketchbook location:** Thư mục chính của Arduino IDE
- **Libraries:** Thư mục chứa thư viện
  - `Sketchbook location\libraries` (ưu tiên)
  - `C:\Users\ASUS\AppData\Local\Arduino15\libraries` (mặc định)

---

## 💡 Lưu Ý

**Arduino IDE tìm thư viện theo thứ tự:**
1. ✅ **Sketchbook location\libraries** (ưu tiên cao nhất)
2. ✅ **C:\Users\ASUS\AppData\Local\Arduino15\libraries** (mặc định)

**Vì vậy:**
- Nếu thư viện ở `E:\lib\libraries\` → Phải đổi Sketchbook location về `E:\lib`
- Hoặc copy thư viện vào `C:\Users\ASUS\AppData\Local\Arduino15\libraries\`

---

**Hy vọng giải thích này giúp bạn hiểu rõ hơn!** 📚✨



# Hướng dẫn thiết lập ESP32 cho SmartFarm

## 🎯 Tại sao dùng ESP32?

- ✅ **KHÔNG CẦN** máy tính chạy 24/7
- ✅ **KHÔNG CẦN** cắm USB vào máy
- ✅ Gửi dữ liệu **TRỰC TIẾP** lên VPS qua WiFi
- ✅ Chạy độc lập, chỉ cần nguồn 5V
- ✅ Chi phí thấp (~100k-200k VNĐ)

## 📦 Phần cứng cần thiết

1. **ESP32 Development Board** (có WiFi tích hợp)
   - ✅ **KHUYẾN NGHỊ**: ESP32 CP2102 - 30Pin hoặc 38Pin
   - ❌ Tránh: ESP32 CH340 (driver kém ổn định hơn)
   - Giá: ~97k-130k VNĐ
   - **Lưu ý**: CP2102 ổn định hơn CH340, dễ cài driver

2. **Cảm biến** (giống Arduino):
   - DHT22 (nhiệt độ, độ ẩm)
   - Cảm biến độ ẩm đất (analog)
   - Cảm biến ánh sáng (analog)

3. **Nguồn điện**:
   - USB 5V (có thể dùng power bank)
   - Hoặc adapter 5V (ổn định hơn)

## 🔧 Cài đặt

### Bước 1: Cài đặt Arduino IDE cho ESP32

1. Mở Arduino IDE
2. Vào **File → Preferences**
3. Thêm URL vào **Additional Board Manager URLs**:
   ```
   https://raw.githubusercontent.com/espressif/arduino-esp32/gh-pages/package_esp32_index.json
   ```
4. Vào **Tools → Board → Boards Manager**
5. Tìm "ESP32" và cài đặt

### Bước 2: Cài đặt thư viện

Vào **Sketch → Include Library → Manage Libraries**, cài:
- **DHT sensor library** (Adafruit)
- **ArduinoJson** (bởi Benoit Blanchon)

### Bước 3: Cấu hình code

Mở file `esp32_sensor.ino` và sửa:

```cpp
// 1. Thông tin WiFi
const char* ssid = "TEN_WIFI_CUA_BAN";
const char* password = "MAT_KHAU_WIFI";

// 2. Địa chỉ VPS
const char* VPS_URL = "http://173.249.48.25:8000/api/sensors";  // ← Đổi IP VPS

// 3. API Key (phải khớp với VPS)
const char* API_KEY = "MY_API_KEY";

// 4. Sensor ID (nếu có nhiều cảm biến)
int sensorId = 1;
```

### Bước 4: Upload code

1. Chọn board: **Tools → Board → ESP32 Dev Module**
2. Chọn Port: **Tools → Port → COMx** (port USB của ESP32)
3. Upload: **Sketch → Upload**

### Bước 5: Kiểm tra

1. Mở Serial Monitor (115200 baud)
2. Xem log kết nối WiFi
3. Kiểm tra dữ liệu gửi lên VPS

## 🔌 Kết nối phần cứng

```
ESP32    →    Cảm biến
------        --------
GPIO 4   →    DHT22 Data
3.3V     →    DHT22 VCC
GND      →    DHT22 GND
GPIO 34  →    Cảm biến độ ẩm đất (analog)
GPIO 35  →    Cảm biến ánh sáng (analog)
```

**Lưu ý**: ESP32 chỉ đọc được analog trên GPIO 32-39 (ADC1)

## ⚡ Nguồn điện

- **Tùy chọn 1**: USB 5V (power bank) - dễ di chuyển
- **Tùy chọn 2**: Adapter 5V 2A - ổn định hơn
- **Tùy chọn 3**: Pin LiPo + module sạc - hoàn toàn độc lập

## 🛠️ Xử lý sự cố

### WiFi không kết nối được
- Kiểm tra SSID và password
- Đảm bảo ESP32 trong phạm vi WiFi
- Thử reset ESP32

### Không gửi được dữ liệu lên VPS
- Kiểm tra IP VPS có đúng không
- Kiểm tra port 8000 có mở không
- Kiểm tra API key có khớp không
- Xem log trong Serial Monitor

### Dữ liệu không chính xác
- Kiểm tra kết nối cảm biến
- Calibrate lại cảm biến analog
- Kiểm tra nguồn điện (thiếu điện → đọc sai)

## 📊 So sánh với Arduino + Forwarder

| Tiêu chí | Arduino + Forwarder | ESP32 |
|----------|---------------------|-------|
| Cần máy tính | ✅ Có | ❌ Không |
| Cần USB 24/7 | ✅ Có | ❌ Không |
| Tiêu thụ điện | Cao (máy tính) | Thấp (~100mA) |
| Chi phí | Thấp (nếu có máy) | ~150k VNĐ |
| Ổn định | Phụ thuộc máy tính | Cao |
| Dễ triển khai | Trung bình | Dễ |

## 🚀 Bước tiếp theo

Sau khi ESP32 chạy ổn định:
1. Đặt ESP32 ở vị trí cố định (có WiFi)
2. Cấp nguồn ổn định
3. Monitor dữ liệu trên VPS
4. Có thể thêm nhiều ESP32 cho nhiều vị trí


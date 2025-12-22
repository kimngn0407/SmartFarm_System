# 🚀 Quick Setup - Gửi Dữ liệu IoT từ Arduino lên VPS

## Bước 1: Cài đặt Thư viện Arduino

Trong Arduino IDE:
1. **Tools → Manage Libraries**
2. Tìm và cài:
   - **DHT sensor library** (by Adafruit)
   - **ArduinoJson** (by Benoit Blanchon) - Version 6.x
   - **WiFi** (có sẵn cho ESP32/ESP8266)
   - **HTTPClient** (có sẵn cho ESP32/ESP8266)

## Bước 2: Cấu hình WiFi và Sensor IDs

Mở file `Arduino_SmartFarm_IoT.ino` và sửa:

```cpp
// WiFi
const char* ssid = "YOUR_WIFI_SSID";           // Thay bằng SSID thực
const char* password = "YOUR_WIFI_PASSWORD";   // Thay bằng password thực

// Sensor IDs (từ database)
const long SENSOR_ID_TEMPERATURE = 1;  // Thay bằng ID thực
const long SENSOR_ID_HUMIDITY = 2;      // Thay bằng ID thực
const long SENSOR_ID_SOIL = 3;         // Thay bằng ID thực
const long SENSOR_ID_LIGHT = 4;        // Thay bằng ID thực
```

## Bước 3: Kiểm tra Sensor IDs trong Database

Trên VPS:

```bash
ssh root@109.205.180.72
cd /opt/SmartFarm

# Xem danh sách sensors
docker compose exec postgres psql -U postgres -d SmartFarm1 -c "SELECT id, sensor_name, type, field_id FROM sensor ORDER BY id;"
```

Ghi lại các ID tương ứng với:
- Temperature sensor
- Humidity sensor
- Soil Moisture sensor
- Light sensor

## Bước 4: Deploy Backend Code (Nếu chưa deploy)

```bash
cd /opt/SmartFarm

# Pull code mới (có endpoint /iot)
git pull origin main

# Rebuild backend
docker compose build backend

# Restart backend
docker compose restart backend

# Kiểm tra logs
docker compose logs backend --tail=20
```

## Bước 5: Upload Code lên Arduino/ESP32

1. Mở `Arduino_SmartFarm_IoT.ino` trong Arduino IDE
2. Chọn board: **Tools → Board → ESP32 Dev Module** (hoặc ESP8266)
3. Chọn Port: **Tools → Port → COMx** (Windows) hoặc `/dev/ttyUSB0` (Linux)
4. Upload code

## Bước 6: Test

1. Mở Serial Monitor: **Tools → Serial Monitor** (115200 baud)
2. Xem logs:
   - `✅ WiFi connected!`
   - `📊 DHT: T=28.50°C H=75.20% | Soil: 44% | Light: 82%`
   - `📤 Sending to server: ...`
   - `✅ HTTP Response code: 200`

## Bước 7: Kiểm tra Dữ liệu trên VPS

```bash
# Xem dữ liệu mới nhất
docker compose exec postgres psql -U postgres -d SmartFarm1 -c "SELECT * FROM sensor_data ORDER BY time DESC LIMIT 10;"
```

## Troubleshooting

### WiFi không kết nối được
- Kiểm tra SSID và password
- Kiểm tra ESP32/ESP8266 có trong range WiFi

### Lỗi HTTP 403/401
- Kiểm tra endpoint: `/api/sensor-data/iot` (không phải `/api/sensor-data`)
- Kiểm tra backend đã được rebuild chưa

### Lỗi "Sensor not found"
- Kiểm tra Sensor IDs có đúng không
- Kiểm tra sensors có tồn tại trong database

### DHT11 đọc fail
- Kiểm tra kết nối DHT11
- Kiểm tra điện trở kéo lên 10k
- Thử delay lâu hơn giữa các lần đọc

## Lưu ý

- Code gửi dữ liệu mỗi **60 giây** (có thể thay đổi `SEND_PERIOD`)
- Đọc cảm biến mỗi **1 giây** (có thể thay đổi `READ_PERIOD`)
- Thời gian tự động sync từ NTP server
- Nếu không sync được NTP, dùng thời gian từ millis()

# 🔌 Hướng dẫn Setup ESP32 cho SmartFarm IoT

## 📦 Phần cứng cần thiết

- **ESP32 Development Board** (ESP32-WROOM-32 hoặc tương đương)
- **DHT11** - Cảm biến nhiệt độ và độ ẩm không khí
- **Soil Moisture Sensor** - Cảm biến độ ẩm đất (analog)
- **LDR (Light Dependent Resistor)** - Cảm biến ánh sáng + điện trở phân áp 10kΩ
- **Điện trở 10kΩ** - Cho DHT11 (pull-up resistor)
- **Dây nối** - Jumper wires

## 🔌 Sơ đồ kết nối ESP32

```
ESP32          Component
-----          ---------
3.3V    -----> DHT11 VCC
3.3V    -----> Soil Sensor VCC
3.3V    -----> LDR (một đầu) + 10kΩ (một đầu)
GND     -----> DHT11 GND
GND     -----> Soil Sensor GND
GND     -----> LDR (đầu còn lại) + 10kΩ (đầu còn lại)
GPIO4   -----> DHT11 DATA (qua điện trở 10kΩ lên 3.3V)
GPIO32  -----> Soil Sensor A0 (analog output)
GPIO33  -----> LDR + 10kΩ (điểm giữa phân áp)
GPIO2   -----> LED (tùy chọn, có sẵn trên board)
```

### Chi tiết kết nối:

**DHT11:**
- VCC → 3.3V
- GND → GND
- DATA → GPIO4 (có điện trở 10kΩ kéo lên 3.3V)

**Soil Moisture Sensor:**
- VCC → 3.3V
- GND → GND
- A0 → GPIO32 (ADC1_CH4)

**LDR với phân áp:**
- LDR một đầu → 3.3V
- LDR đầu kia → GPIO33 (ADC1_CH5)
- GPIO33 → 10kΩ → GND

## 📚 Cài đặt Thư viện Arduino IDE

1. **Mở Arduino IDE**
2. **File → Preferences → Additional Boards Manager URLs**
   - Thêm: `https://raw.githubusercontent.com/espressif/arduino-esp32/gh-pages/package_esp32_index.json`
3. **Tools → Board → Boards Manager**
   - Tìm "esp32" và cài "esp32 by Espressif Systems"
4. **Cài các thư viện:**
   - **Tools → Manage Libraries**
   - Tìm và cài:
     - `DHT sensor library` (by Adafruit)
     - `ArduinoJson` (by Benoit Blanchon) - Version 6.x

## ⚙️ Cấu hình Arduino IDE cho ESP32

1. **Tools → Board → ESP32 Arduino → ESP32 Dev Module**
2. **Tools → Port → Chọn COM port của ESP32**
3. **Tools → Upload Speed → 115200** (hoặc 921600 nếu nhanh)
4. **Tools → CPU Frequency → 240MHz (WiFi/BT)**
5. **Tools → Flash Frequency → 80MHz**
6. **Tools → Flash Size → 4MB (32Mb)**

## 🔧 Cấu hình Code

Mở file `Arduino_SmartFarm_IoT.ino` và sửa:

```cpp
// 1. WiFi credentials
const char* ssid = "YOUR_WIFI_SSID";
const char* password = "YOUR_WIFI_PASSWORD";

// 2. Sensor IDs (từ database trên VPS)
const long SENSOR_ID_TEMPERATURE = 1;  // Thay bằng ID thực
const long SENSOR_ID_HUMIDITY = 2;
const long SENSOR_ID_SOIL = 3;
const long SENSOR_ID_LIGHT = 4;
```

## 📊 Kiểm tra Sensor IDs trên VPS

```bash
ssh root@109.205.180.72
cd /opt/SmartFarm

# Xem danh sách sensors
docker compose exec postgres psql -U postgres -d SmartFarm1 -c "SELECT id, sensor_name, type, field_id FROM sensor ORDER BY id;"
```

Ghi lại các ID và cập nhật vào code.

## 🔍 Hiệu chuẩn Analog Sensors

ESP32 có ADC 12-bit (0-4095) thay vì 10-bit (0-1023) như Arduino Uno.

### Hiệu chuẩn Soil Sensor:

1. **Đo khi đất khô hoàn toàn:**
   ```cpp
   int SOIL_RAW_DRY = 4095;  // Giá trị raw khi khô
   ```

2. **Đo khi đất ướt hoàn toàn:**
   ```cpp
   int SOIL_RAW_WET = 2000;  // Giá trị raw khi ướt (tùy sensor)
   ```

3. **Test và điều chỉnh:**
   - Upload code và mở Serial Monitor
   - Xem giá trị `soil_raw` khi khô và ướt
   - Cập nhật `SOIL_RAW_DRY` và `SOIL_RAW_WET` cho phù hợp

### Hiệu chuẩn LDR:

1. **Đo khi tối hoàn toàn:**
   ```cpp
   int LDR_RAW_DARK = 100;  // Giá trị raw khi tối
   ```

2. **Đo khi sáng hoàn toàn:**
   ```cpp
   int LDR_RAW_BRIGHT = 3500;  // Giá trị raw khi sáng (tùy mạch)
   ```

## 📤 Upload Code

1. **Kiểm tra kết nối:**
   - ESP32 đã kết nối USB
   - Đã chọn đúng Port trong Arduino IDE

2. **Upload:**
   - Click **Upload** (mũi tên →) hoặc `Ctrl + U`
   - Đợi compile và upload (có thể mất 30-60 giây)

3. **Mở Serial Monitor:**
   - Click **Serial Monitor** hoặc `Ctrl + Shift + M`
   - **Baud rate: 115200**
   - Phải thấy:
     ```
     === SmartFarm IoT - Kết nối WiFi ===
     ✅ WiFi connected!
     📡 IP address: 192.168.x.x
     ⏰ Đang sync thời gian từ NTP (GMT+7)...
     === Bắt đầu đọc và gửi dữ liệu ===
     ```

## ✅ Kiểm tra hoạt động

### 1. Kiểm tra Serial Monitor:

```
📊 DHT: T=28.50°C H=75.20% | Soil: 44% | Light: 82%
🚀 Bắt đầu gửi dữ liệu lên server...
📤 Sending to server: {"sensorId":1,"value":28.5,"time":"2024-12-20T10:30:00Z"}
✅ HTTP Response code: 200
📥 Response: {"id":123,"sensorId":1,"value":28.5,"time":"2024-12-20T10:30:00Z"}
✅ Đã gửi xong tất cả dữ liệu!
```

### 2. Kiểm tra trên VPS:

```bash
# Xem dữ liệu mới nhất
docker compose exec postgres psql -U postgres -d SmartFarm1 -c "SELECT * FROM sensor_data ORDER BY time DESC LIMIT 10;"
```

## 🔧 Troubleshooting

### ESP32 không upload được:

1. **Giữ nút BOOT khi upload** (một số board cần)
2. **Kiểm tra driver USB:** Cài CP2102 hoặc CH340 driver
3. **Thử Port khác:** Tools → Port → Chọn port khác
4. **Giảm Upload Speed:** Tools → Upload Speed → 115200

### WiFi không kết nối:

1. **Kiểm tra SSID và password** đúng chưa
2. **Kiểm tra ESP32 trong range WiFi**
3. **Thử reset ESP32:** Nhấn nút RESET

### DHT11 đọc fail:

1. **Kiểm tra kết nối:** VCC, GND, DATA
2. **Kiểm tra điện trở 10kΩ** kéo lên 3.3V
3. **Thử delay lâu hơn** giữa các lần đọc

### Analog đọc sai:

1. **ESP32 ADC có thể không chính xác** - cần hiệu chuẩn
2. **Kiểm tra nguồn 3.3V** ổn định
3. **Thử pin analog khác:** GPIO32, GPIO33, GPIO34, GPIO35, GPIO36, GPIO39

### Không gửi được lên server:

1. **Kiểm tra WiFi đã kết nối:**
   ```
   Serial Monitor phải thấy: ✅ WiFi connected!
   ```

2. **Kiểm tra server URL:**
   ```cpp
   const char* serverUrl = "http://109.205.180.72:8080/api/sensor-data/iot";
   ```

3. **Kiểm tra Sensor IDs** có đúng không

4. **Kiểm tra server đang chạy:**
   ```bash
   curl http://109.205.180.72:8080/api/sensor-data/iot -X POST -H "Content-Type: application/json" -d '{"sensorId":1,"value":28.5,"time":"2024-12-20T10:30:00Z"}'
   ```

## 📝 Lưu ý quan trọng

- ✅ ESP32 có ADC 12-bit (0-4095), không phải 10-bit (0-1023)
- ✅ GPIO32-39 là ADC1, GPIO0,2,4,12-15 là ADC2 (không dùng khi WiFi active)
- ✅ DHT11 cần delay ít nhất 2 giây giữa các lần đọc
- ✅ ESP32 có thể bị nóng khi chạy lâu - đảm bảo thông gió tốt
- ✅ Nếu dùng pin ADC2 (GPIO0,2,4,12-15), WiFi có thể không hoạt động tốt

## 🔋 Nguồn điện

- **USB:** 5V (ổn định cho development)
- **Pin ngoài:** 3.3V hoặc 5V (cần ổn áp)
- **Lưu ý:** ESP32 tiêu thụ ~80-240mA khi hoạt động

## 📚 Tài liệu tham khảo

- [ESP32 Arduino Core Documentation](https://github.com/espressif/arduino-esp32)
- [ESP32 Pinout Reference](https://randomnerdtutorials.com/esp32-pinout-reference-gpios/)
- [DHT11 Library](https://github.com/adafruit/DHT-sensor-library)

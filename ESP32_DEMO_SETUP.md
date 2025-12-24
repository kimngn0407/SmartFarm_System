# 🌾 Hướng dẫn Demo SmartFarm với ESP32

## 📦 Phần cứng cần thiết

- ✅ **ESP32 30 chân (Type-C)**
- ✅ **DHT11** - Nhiệt độ, độ ẩm không khí
- ✅ **Soil Moisture Sensor** - Độ ẩm đất (analog)
- ✅ **LDR (Light Dependent Resistor)** - Cảm biến ánh sáng
- ✅ **Relay Module** - Điều khiển máy bơm (1 kênh)
- ✅ **Máy bơm mini 5V** - Tưới nước tự động
- ✅ **LED:** Xanh, Vàng, Đỏ (mỗi LED cần điện trở 220Ω)
- ✅ **Điện trở 10kΩ** - Cho DHT11 (pull-up)
- ✅ **Điện trở 220Ω x3** - Cho LED (giới hạn dòng)
- ✅ **Dây nối, breadboard**

## 🔌 Sơ đồ kết nối ESP32

### Sensors:

```
ESP32          Component
-----          ---------
3.3V    -----> DHT11 VCC
3.3V    -----> Soil Sensor VCC
3.3V    -----> LDR (một đầu)
GND     -----> DHT11 GND
GND     -----> Soil Sensor GND
GND     -----> LDR (đầu kia) + 10kΩ (một đầu)
GPIO4   -----> DHT11 DATA (qua 10kΩ lên 3.3V)
GPIO32  -----> Soil Sensor A0
GPIO33  -----> LDR + 10kΩ (điểm giữa phân áp)
```

### Actuators (Điều khiển):

```
ESP32          Component
-----          ---------
5V      -----> Relay VCC
GND     -----> Relay GND
GPIO25  -----> Relay IN (Signal)

Relay NO -----> Máy bơm + (dương)
Relay COM -----> 5V (từ nguồn riêng cho máy bơm)
Máy bơm - -----> GND

GPIO26  -----> LED Xanh (qua 220Ω) -----> GND
GPIO27  -----> LED Vàng (qua 220Ω) -----> GND
GPIO14  -----> LED Đỏ (qua 220Ω) -----> GND
```

### Chi tiết kết nối Relay và Máy bơm:

```
Nguồn 5V (USB hoặc adapter)
  |
  +---> Relay COM
  |
  +---> Máy bơm + (qua Relay NO khi relay ON)

Relay NO (Normally Open) -----> Máy bơm +
Máy bơm - -----> GND

Khi GPIO25 = HIGH: Relay ON → Máy bơm chạy
Khi GPIO25 = LOW: Relay OFF → Máy bơm tắt
```

### Chi tiết kết nối LED:

```
GPIO26 → [220Ω] → LED Xanh → GND
GPIO27 → [220Ω] → LED Vàng → GND
GPIO14 → [220Ω] → LED Đỏ → GND

Lưu ý: LED có cực dương (+), cực âm (-)
- Cực dương (chân dài) → GPIO qua điện trở
- Cực âm (chân ngắn) → GND
```

## 📋 Bảng Pin ESP32

| Chức năng | GPIO | Mô tả |
|-----------|------|-------|
| DHT11 DATA | GPIO4 | Digital input |
| Soil Sensor | GPIO32 | Analog input (ADC1_CH4) |
| LDR | GPIO33 | Analog input (ADC1_CH5) |
| Relay | GPIO25 | Digital output (điều khiển máy bơm) |
| LED Xanh | GPIO26 | Digital output |
| LED Vàng | GPIO27 | Digital output |
| LED Đỏ | GPIO14 | Digital output |

## ⚙️ Cấu hình Code

1. **Mở file `Arduino_SmartFarm_Demo.ino`**

2. **Sửa WiFi:**
   ```cpp
   const char* ssid = "YOUR_WIFI_SSID";
   const char* password = "YOUR_WIFI_PASSWORD";
   ```

3. **Sửa Sensor IDs** (từ database):
   ```cpp
   const long SENSOR_ID_TEMPERATURE = 1;
   const long SENSOR_ID_HUMIDITY = 2;
   const long SENSOR_ID_SOIL = 3;
   const long SENSOR_ID_LIGHT = 4;
   ```

4. **Tùy chỉnh ngưỡng tự động tưới** (nếu cần):
   ```cpp
   const int SOIL_THRESHOLD_DRY = 30;   // Bắt đầu tưới khi < 30%
   const int SOIL_THRESHOLD_WET = 70;   // Đất đủ ẩm khi > 70%
   const unsigned long PUMP_DURATION = 5000;  // Bơm 5 giây mỗi lần
   ```

## 🚀 Upload Code

1. **Cài ESP32 board** trong Arduino IDE (nếu chưa)
2. **Cài thư viện:**
   - DHT sensor library (Adafruit)
   - ArduinoJson (Benoit Blanchon)
3. **Chọn board:** Tools → Board → ESP32 Dev Module
4. **Chọn Port:** Tools → Port → COMx
5. **Upload:** Click Upload hoặc `Ctrl + U`

## ✅ Kiểm tra hoạt động

### 1. Serial Monitor (115200 baud):

```
=== SmartFarm Demo - Hệ thống Tự động hóa ===
📡 Đang kết nối WiFi...
✅ WiFi connected!
📡 IP: 192.168.x.x
⏰ Đang sync thời gian...
=== Hệ thống sẵn sàng ===
💡 LED Xanh: Đất đủ ẩm
💡 LED Vàng: Đất hơi khô
💡 LED Đỏ: Đất khô hoặc đang tưới
💧 Máy bơm tự động khi đất < 30%

📊 T=28.5°C H=75.2% | Soil: 25% | Light: 82% | Pump: OFF
🌱 Đất khô - Bắt đầu tưới tự động
💧 Máy bơm BẬT
💧 Máy bơm TẮT
✅ Đã tưới xong
📊 T=28.5°C H=75.2% | Soil: 45% | Light: 82% | Pump: OFF
```

### 2. Kiểm tra LED:

- **LED Xanh sáng:** Đất đủ ẩm (>70%)
- **LED Vàng sáng:** Đất hơi khô (30-70%)
- **LED Đỏ sáng:** Đất khô (<30%)
- **LED Đỏ nhấp nháy:** Đang tưới nước

### 3. Kiểm tra máy bơm:

- Khi đất < 30%: Máy bơm tự động bật trong 5 giây
- Sau khi tưới: Chờ 1 phút trước khi có thể tưới lại (cooldown)

### 4. Kiểm tra dữ liệu trên VPS:

```bash
ssh root@109.205.180.72
cd /opt/SmartFarm

# Xem dữ liệu mới nhất
docker compose exec postgres psql -U postgres -d SmartFarm1 -c "SELECT * FROM sensor_data ORDER BY time DESC LIMIT 10;"
```

## 🎯 Demo Scenario

### Scenario 1: Đất khô - Tự động tưới

1. **Đặt cảm biến đất vào chậu khô** (hoặc không có nước)
2. **Quan sát:**
   - LED Đỏ sáng
   - Serial Monitor: "🌱 Đất khô - Bắt đầu tưới tự động"
   - Máy bơm tự động bật (5 giây)
   - LED Đỏ nhấp nháy khi đang tưới
   - Sau khi tưới: LED chuyển sang Vàng hoặc Xanh

### Scenario 2: Đất đủ ẩm - Không tưới

1. **Đặt cảm biến đất vào chậu ướt** (hoặc có nước)
2. **Quan sát:**
   - LED Xanh sáng
   - Máy bơm không bật
   - Serial Monitor: Soil > 70%

### Scenario 3: Gửi dữ liệu lên VPS

1. **Đợi 60 giây** (SEND_PERIOD)
2. **Quan sát Serial Monitor:**
   - "🚀 Gửi dữ liệu lên server..."
   - "✅ HTTP Response: 200"
   - "✅ Đã gửi xong!"
3. **Kiểm tra database trên VPS** (xem lệnh ở trên)

## 🔧 Troubleshooting

### Máy bơm không chạy:

1. **Kiểm tra relay:**
   - Relay có đèn báo không? (phải sáng khi GPIO25 = HIGH)
   - Kiểm tra nguồn 5V cho relay

2. **Kiểm tra máy bơm:**
   - Máy bơm có nguồn 5V riêng không?
   - Kết nối đúng cực: + và -

3. **Kiểm tra code:**
   - Serial Monitor có hiện "💧 Máy bơm BẬT" không?
   - Nếu không, kiểm tra logic `autoWatering()`

### LED không sáng:

1. **Kiểm tra điện trở 220Ω** đã nối đúng chưa
2. **Kiểm tra cực LED** (chân dài = +, chân ngắn = -)
3. **Test LED trực tiếp:** Nối LED qua 220Ω vào 3.3V và GND

### Dữ liệu không gửi lên VPS:

1. **Kiểm tra WiFi:** Serial Monitor phải thấy "✅ WiFi connected!"
2. **Kiểm tra server URL:** `http://109.205.180.72:8080/api/sensor-data/iot`
3. **Kiểm tra Sensor IDs** có đúng không
4. **Test server:**
   ```bash
   curl http://109.205.180.72:8080/api/sensor-data/iot -X POST -H "Content-Type: application/json" -d '{"sensorId":1,"value":28.5,"time":"2024-12-20T10:30:00Z"}'
   ```

## 📊 Hiệu chuẩn Sensors

### Soil Sensor:

1. **Đo khi đất khô hoàn toàn:**
   - Xem giá trị `soil_raw` trong Serial Monitor
   - Cập nhật `SOIL_RAW_DRY` trong code

2. **Đo khi đất ướt hoàn toàn:**
   - Xem giá trị `soil_raw` trong Serial Monitor
   - Cập nhật `SOIL_RAW_WET` trong code

### LDR:

1. **Đo khi tối:** Cập nhật `LDR_RAW_DARK`
2. **Đo khi sáng:** Cập nhật `LDR_RAW_BRIGHT`

## 🔋 Nguồn điện

- **ESP32:** USB 5V hoặc adapter
- **Relay:** 5V từ ESP32 hoặc nguồn riêng
- **Máy bơm:** 5V từ nguồn riêng (qua relay)
- **LED:** 3.3V từ ESP32 (qua điện trở 220Ω)

**Lưu ý:** Máy bơm có thể tiêu thụ nhiều dòng (~200-500mA), nên dùng nguồn riêng cho máy bơm, không lấy từ ESP32.

## 🎬 Video Demo Checklist

- [ ] Giới thiệu phần cứng
- [ ] Kết nối sensors và actuators
- [ ] Upload code và kết nối WiFi
- [ ] Demo đọc dữ liệu sensors (Serial Monitor)
- [ ] Demo LED báo trạng thái (Xanh/Vàng/Đỏ)
- [ ] Demo tự động tưới khi đất khô
- [ ] Demo gửi dữ liệu lên VPS
- [ ] Demo kiểm tra dữ liệu trên database

## 📝 Lưu ý an toàn

- ⚠️ **Máy bơm nước:** Đảm bảo không rò rỉ điện
- ⚠️ **Relay:** Kiểm tra cách ly điện đúng cách
- ⚠️ **Nguồn điện:** Dùng nguồn ổn định, tránh quá tải
- ⚠️ **Nước:** Tránh nước vào board ESP32

# 📡 Hướng dẫn Gửi Dữ liệu IoT lên CSDL trên VPS

## Tổng quan

Backend SmartFarm có API endpoint để nhận dữ liệu từ thiết bị IoT và lưu vào PostgreSQL database.

## API Endpoints

### Endpoint 1: Public Endpoint cho IoT (Khuyến nghị - Không cần authentication)

**URL:** `http://109.205.180.72:8080/api/sensor-data/iot`  
**Method:** `POST`  
**Content-Type:** `application/json`  
**Authentication:** Không cần

### Endpoint 2: Endpoint có Authentication (Cần JWT token)

**URL:** `http://109.205.180.72:8080/api/sensor-data`  
**Method:** `POST`  
**Content-Type:** `application/json`  
**Authentication:** Cần JWT token

## Format Dữ liệu

### Request Body (JSON)

```json
{
  "sensorId": 1,
  "value": 28.5,
  "time": "2024-12-20T10:30:00Z"
}
```

### Các trường:

- **sensorId** (Long, bắt buộc): ID của sensor trong database
- **value** (Float, bắt buộc): Giá trị đo được (nhiệt độ, độ ẩm, độ ẩm đất, ánh sáng)
- **time** (String, bắt buộc): Thời gian đo (ISO 8601 format với UTC timezone, có suffix 'Z')

## Authentication

### Cách 1: Sử dụng Public Endpoint `/iot` (Khuyến nghị - Không cần token)

**Endpoint:** `http://109.205.180.72:8080/api/sensor-data/iot`

Không cần authentication, có thể gửi trực tiếp từ IoT devices.

### Cách 2: Sử dụng JWT Token (Nếu muốn bảo mật hơn)

1. **Lấy JWT token từ login:**

```bash
# Login để lấy token
curl -X POST http://109.205.180.72:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "username": "your_username",
    "password": "your_password"
  }'

# Response sẽ có token:
# {
#   "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
#   ...
# }
```

2. **Gửi dữ liệu với token:**

```bash
curl -X POST http://109.205.180.72:8080/api/sensor-data \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -d '{
    "sensorId": 1,
    "value": 28.5,
    "time": "2024-12-20T10:30:00Z"
  }'
```

### Cách 2: Tạo Endpoint Public cho IoT (Cần sửa code)

Nếu muốn gửi không cần authentication, cần thêm endpoint public trong SecurityConfig.

## Ví dụ Code cho Arduino/ESP32

### Arduino/ESP32 với WiFi

```cpp
#include <WiFi.h>
#include <HTTPClient.h>
#include <ArduinoJson.h>
#include <time.h>

// WiFi credentials
const char* ssid = "YOUR_WIFI_SSID";
const char* password = "YOUR_WIFI_PASSWORD";

// Backend URL - Sử dụng public endpoint /iot (không cần token)
const char* serverUrl = "http://109.205.180.72:8080/api/sensor-data/iot";

// Sensor ID (từ database)
const int SENSOR_ID = 1;

void setup() {
  Serial.begin(115200);
  
  // Connect WiFi
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("WiFi connected!");
  
  // Config NTP để lấy thời gian
  configTime(0, 0, "pool.ntp.org");
}

void loop() {
  // Đọc giá trị từ sensor (ví dụ: DHT22)
  float temperature = 28.5; // Thay bằng giá trị thực từ sensor
  float humidity = 75.2;
  
  // Gửi nhiệt độ
  sendSensorData(SENSOR_ID, temperature, "Temperature");
  delay(1000);
  
  // Gửi độ ẩm
  sendSensorData(SENSOR_ID + 1, humidity, "Humidity");
  delay(1000);
  
  // Đợi 5 phút trước khi gửi tiếp
  delay(300000); // 5 phút
}

void sendSensorData(int sensorId, float value, String sensorType) {
  if (WiFi.status() != WL_CONNECTED) {
    Serial.println("WiFi not connected!");
    return;
  }
  
  HTTPClient http;
  http.begin(serverUrl);
  http.addHeader("Content-Type", "application/json");
  // Không cần Authorization header khi dùng /iot endpoint
  
  // Lấy thời gian hiện tại (UTC)
  struct tm timeinfo;
  if (!getLocalTime(&timeinfo)) {
    Serial.println("Failed to obtain time");
    return;
  }
  
  // Format: 2024-12-20T10:30:00Z
  char timeStr[25];
  sprintf(timeStr, "%04d-%02d-%02dT%02d:%02d:%02dZ",
          timeinfo.tm_year + 1900,
          timeinfo.tm_mon + 1,
          timeinfo.tm_mday,
          timeinfo.tm_hour,
          timeinfo.tm_min,
          timeinfo.tm_sec);
  
  // Tạo JSON payload
  StaticJsonDocument<200> doc;
  doc["sensorId"] = sensorId;
  doc["value"] = value;
  doc["time"] = timeStr;
  
  String jsonPayload;
  serializeJson(doc, jsonPayload);
  
  Serial.println("Sending: " + jsonPayload);
  
  int httpResponseCode = http.POST(jsonPayload);
  
  if (httpResponseCode > 0) {
    Serial.print("HTTP Response code: ");
    Serial.println(httpResponseCode);
    String response = http.getString();
    Serial.println("Response: " + response);
  } else {
    Serial.print("Error code: ");
    Serial.println(httpResponseCode);
  }
  
  http.end();
}
```

## Ví dụ với Python

```python
import requests
import json
from datetime import datetime, timezone

# Backend URL - Sử dụng public endpoint /iot (không cần token)
BASE_URL = "http://109.205.180.72:8080"
API_URL = f"{BASE_URL}/api/sensor-data/iot"

def send_sensor_data(sensor_id, value):
    """
    Gửi dữ liệu sensor lên backend
    
    Args:
        sensor_id: ID của sensor trong database
        value: Giá trị đo được (float)
    """
    # Thời gian hiện tại (UTC)
    current_time = datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")
    
    # Payload
    payload = {
        "sensorId": sensor_id,
        "value": float(value),
        "time": current_time
    }
    
    # Headers - Không cần Authorization khi dùng /iot endpoint
    headers = {
        "Content-Type": "application/json"
    }
    
    # Gửi request
    try:
        response = requests.post(API_URL, json=payload, headers=headers)
        response.raise_for_status()
        print(f"✅ Đã gửi dữ liệu: {payload}")
        return response.json()
    except requests.exceptions.RequestException as e:
        print(f"❌ Lỗi khi gửi dữ liệu: {e}")
        return None

# Ví dụ sử dụng
if __name__ == "__main__":
    # Gửi nhiệt độ (sensor ID = 1)
    send_sensor_data(1, 28.5)
    
    # Gửi độ ẩm (sensor ID = 2)
    send_sensor_data(2, 75.2)
```

## Kiểm tra Sensor ID trong Database

Trước khi gửi dữ liệu, cần biết `sensorId` trong database:

```bash
# SSH vào VPS
ssh root@109.205.180.72

# Kiểm tra sensors
docker compose exec postgres psql -U postgres -d SmartFarm1 -c "SELECT id, sensor_name, type FROM sensor LIMIT 10;"
```

## Test với curl

### Cách 1: Sử dụng Public Endpoint (Đơn giản nhất)

```bash
# Gửi dữ liệu sensor - không cần token
curl -X POST http://109.205.180.72:8080/api/sensor-data/iot \
  -H "Content-Type: application/json" \
  -d '{
    "sensorId": 1,
    "value": 28.5,
    "time": "2024-12-20T10:30:00Z"
  }'
```

### Cách 2: Sử dụng Endpoint có Authentication

```bash
# 1. Login để lấy token
TOKEN=$(curl -X POST http://109.205.180.72:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"your_username","password":"your_password"}' \
  | jq -r '.token')

# 2. Gửi dữ liệu sensor với token
curl -X POST http://109.205.180.72:8080/api/sensor-data \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "sensorId": 1,
    "value": 28.5,
    "time": "2024-12-20T10:30:00Z"
  }'
```

## Lưu ý

1. **Sensor ID phải tồn tại trong database** - Nếu không sẽ lỗi "Sensor not found"
2. **Time format phải đúng ISO 8601 với UTC** - Format: `YYYY-MM-DDTHH:mm:ssZ`
3. **Value phải là số thực** (Float) - Không phải string
4. **Public endpoint `/iot` không cần authentication** - Dễ sử dụng cho IoT devices
5. **Nếu muốn bảo mật hơn**, có thể sử dụng endpoint `/api/sensor-data` với JWT token

## Kiểm tra Sensor ID

Trước khi gửi dữ liệu, cần biết `sensorId` trong database:

```bash
# SSH vào VPS
ssh root@109.205.180.72

# Kiểm tra sensors
docker compose exec postgres psql -U postgres -d SmartFarm1 -c "SELECT id, sensor_name, type, field_id FROM sensor ORDER BY id LIMIT 20;"
```

## Ví dụ Test Nhanh

```bash
# Test gửi dữ liệu nhiệt độ (sensor ID = 1)
curl -X POST http://109.205.180.72:8080/api/sensor-data/iot \
  -H "Content-Type: application/json" \
  -d '{
    "sensorId": 1,
    "value": 28.5,
    "time": "2024-12-20T10:30:00Z"
  }'

# Response thành công:
# {"id":123,"sensorId":1,"value":28.5,"time":"2024-12-20T10:30:00Z"}
```

/**
 * SmartFarm - Đọc 3 cảm biến (DHT11, Độ ẩm đất, LDR) và gửi lên VPS
 * Tác giả: SmartFarm Team
 * Board: ESP8266 (NodeMCU hoặc Wemos D1 Mini)
 * 
 * Phần cứng:
 *   - DHT11: VCC -> 3.3V, GND -> GND, DATA -> D4 (GPIO2) (có điện trở kéo lên 10k nếu cần)
 *   - Soil moisture (analog): A0 (ESP8266 chỉ có 1 pin analog)
 *   - LDR + phân áp (analog): Dùng A0 với multiplexer hoặc dùng 1 sensor tại 1 thời điểm
 *   - LED báo: LED_BUILTIN (GPIO16 hoặc GPIO2)
 * 
 * WiFi: Cần cấu hình SSID và password
 * Backend: http://109.205.180.72:8080/api/sensor-data/iot
 */

#include "DHT.h"
#include <ESP8266WiFi.h>      // Cho ESP8266
#include <ESP8266HTTPClient.h> // Cho ESP8266
#include <WiFiClient.h>
#include <ArduinoJson.h>      // Cần cài thư viện ArduinoJson
#include <time.h>            // Để lấy thời gian từ NTP

// ================== Cấu hình WiFi ==================
const char* ssid = "YOUR_WIFI_SSID";           // Thay bằng SSID WiFi của bạn
const char* password = "YOUR_WIFI_PASSWORD";   // Thay bằng password WiFi

// ================== Cấu hình Backend ==================
const char* serverUrl = "http://109.205.180.72:8080/api/sensor-data/iot";

// ================== Cấu hình Sensor IDs (từ database) ==================
// ⚠️ QUAN TRỌNG: Cần kiểm tra sensor IDs trong database trước!
// Chạy: docker compose exec postgres psql -U postgres -d SmartFarm1 -c "SELECT id, sensor_name, type FROM sensor;"
const long SENSOR_ID_TEMPERATURE = 1;  // Thay bằng ID thực tế của sensor nhiệt độ
const long SENSOR_ID_HUMIDITY = 2;      // Thay bằng ID thực tế của sensor độ ẩm không khí
const long SENSOR_ID_SOIL = 3;         // Thay bằng ID thực tế của sensor độ ẩm đất
const long SENSOR_ID_LIGHT = 4;        // Thay bằng ID thực tế của sensor ánh sáng

// ================== Cấu hình cảm biến & chân ==================
// ESP8266 Pin Configuration
#define DHTPIN   2        // Chân DATA của DHT11 (GPIO2 = D4 trên NodeMCU)
#define DHTTYPE  DHT11    // Loại cảm biến: DHT11

// ESP8266 chỉ có 1 pin analog (A0)
#define SOIL_PIN   A0     // Cảm biến độ ẩm đất (analog - A0)
// Lưu ý: ESP8266 chỉ có 1 pin analog, nếu cần cả Soil và LDR, cần dùng multiplexer
// Hoặc đọc từng sensor một cách luân phiên

// LED báo trạng thái
#ifndef LED_BUILTIN
  #define LED_BUILTIN 16  // ESP8266: GPIO16 hoặc GPIO2
#endif
#define LEDPIN LED_BUILTIN

// ========== Tham số đọc mẫu & hiệu chỉnh ==========
const uint8_t AVG_SAMPLES = 5;

// Hiệu chuẩn Soil (ESP8266 có ADC 10-bit: 0-1023, nhưng thực tế chỉ 0-1024)
int SOIL_RAW_DRY  = 1024;  // Đất khô (ESP8266: 10-bit ADC)
int SOIL_RAW_WET  = 400;   // Đất ướt (ESP8266: 10-bit ADC)

// Hiệu chuẩn LDR (nếu dùng multiplexer hoặc đọc luân phiên)
int LDR_RAW_DARK   = 50;   // Tối
int LDR_RAW_BRIGHT = 900;  // Sáng (ESP8266: 10-bit ADC)

// ================== Biến toàn cục ==================
DHT dht(DHTPIN, DHTTYPE);

unsigned long lastRead = 0;                    // Thời gian đọc gần nhất
unsigned long lastSend = 0;                    // Thời gian gửi gần nhất
const unsigned long READ_PERIOD = 1000;        // Đọc cảm biến mỗi 1 giây
const unsigned long SEND_PERIOD = 60000;       // Gửi lên server mỗi 60 giây (1 phút)

// ================== Hàm tiện ích ==================

/**
 * Đọc analog nhiều lần rồi lấy trung bình để giảm nhiễu
 */
int analogReadAvg(uint8_t pin, uint8_t n) {
  long s = 0;
  for (uint8_t i = 0; i < n; i++) {
    s += analogRead(pin);
    delay(2);
  }
  return (int)(s / n);
}

/**
 * Map với kẹp biên (clamp)
 */
int mapClamp(long x, long in_min, long in_max, long out_min, long out_max) {
  if (in_min == in_max) return (int)out_min;
  long v = (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
  if (v < out_min) v = out_min;
  if (v > out_max) v = out_max;
  return (int)v;
}

/**
 * Lấy thời gian hiện tại (UTC) dạng ISO 8601: YYYY-MM-DDTHH:mm:ssZ
 * Nếu chưa sync được NTP, trả về thời gian từ millis()
 */
String getCurrentTimeISO() {
  time_t now = time(nullptr);
  struct tm timeinfo;
  
  if (getLocalTime(&timeinfo)) {
    // Đã sync NTP thành công
    char timeStr[25];
    sprintf(timeStr, "%04d-%02d-%02dT%02d:%02d:%02dZ",
            timeinfo.tm_year + 1900,
            timeinfo.tm_mon + 1,
            timeinfo.tm_mday,
            timeinfo.tm_hour,
            timeinfo.tm_min,
            timeinfo.tm_sec);
    return String(timeStr);
  } else {
    // Chưa sync được, dùng thời gian từ millis (tính từ khi boot)
    unsigned long seconds = millis() / 1000;
    unsigned long hours = (seconds % 86400) / 3600;
    unsigned long minutes = (seconds % 3600) / 60;
    unsigned long secs = seconds % 60;
    
    // Giả sử bắt đầu từ 2024-12-20T00:00:00Z
    char timeStr[25];
    sprintf(timeStr, "2024-12-20T%02lu:%02lu:%02luZ", hours, minutes, secs);
    return String(timeStr);
  }
}

/**
 * Gửi dữ liệu sensor lên server
 * sensorId: ID của sensor trong database
 * value: Giá trị đo được (float)
 */
bool sendSensorDataToServer(long sensorId, float value) {
  if (WiFi.status() != WL_CONNECTED) {
    Serial.println("❌ WiFi not connected!");
    return false;
  }

  WiFiClient client;
  HTTPClient http;
  
  http.begin(client, serverUrl);
  http.addHeader("Content-Type", "application/json");

  // Tạo JSON payload
  String currentTime = getCurrentTimeISO();
  
  StaticJsonDocument<200> doc;
  doc["sensorId"] = sensorId;
  doc["value"] = value;
  doc["time"] = currentTime;

  String jsonPayload;
  serializeJson(doc, jsonPayload);

  Serial.print("📤 Sending to server: ");
  Serial.println(jsonPayload);

  int httpResponseCode = http.POST(jsonPayload);

  if (httpResponseCode > 0) {
    Serial.print("✅ HTTP Response code: ");
    Serial.println(httpResponseCode);
    String response = http.getString();
    Serial.print("📥 Response: ");
    Serial.println(response);
    http.end();
    return true;
  } else {
    Serial.print("❌ Error code: ");
    Serial.println(httpResponseCode);
    http.end();
    return false;
  }
}

// ================== Vòng đời chương trình ==================
void setup() {
  Serial.begin(115200);
  delay(1000);

  Serial.println("=== SmartFarm IoT - Kết nối WiFi ===");
  
  // Kết nối WiFi
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("");
  Serial.println("✅ WiFi connected!");
  Serial.print("📡 IP address: ");
  Serial.println(WiFi.localIP());

  // Khởi tạo DHT
  dht.begin();

  // Cấu hình pin
  pinMode(LEDPIN, OUTPUT);
  pinMode(SOIL_PIN, INPUT);

  // Cấu hình NTP để lấy thời gian (ESP8266 cần timezone)
  // GMT+7 (Vietnam): 7 * 3600 = 25200 seconds
  configTime(25200, 0, "pool.ntp.org", "time.nist.gov", "time.google.com");
  Serial.println("⏰ Đang sync thời gian từ NTP (GMT+7)...");
  delay(2000);

  Serial.println("=== Bắt đầu đọc và gửi dữ liệu ===");
}

void loop() {
  unsigned long now = millis();

  // Đọc cảm biến mỗi READ_PERIOD (1 giây)
  if (now - lastRead >= READ_PERIOD) {
    lastRead = now;

    // --------- Đọc DHT11 (nhiệt độ/độ ẩm không khí) ---------
    float h = dht.readHumidity();
    float t = dht.readTemperature();
    
    if (isnan(h) || isnan(t)) {
      delay(50);
      h = dht.readHumidity();
      t = dht.readTemperature();
    }
    bool dhtFail = isnan(h) || isnan(t);

    // LED bật khi độ ẩm > 55% và đọc DHT thành công
    if (!dhtFail && h > 55.0) {
      digitalWrite(LEDPIN, HIGH);
    } else {
      digitalWrite(LEDPIN, LOW);
    }

    // --------- Đọc độ ẩm đất (ESP8266 chỉ có 1 pin analog) ---------
    int soilRaw = analogReadAvg(SOIL_PIN, AVG_SAMPLES);
    int soilPct = mapClamp(soilRaw, SOIL_RAW_DRY, SOIL_RAW_WET, 0, 100);

    // Lưu ý: ESP8266 chỉ có 1 pin analog (A0)
    // Nếu cần cả Soil và LDR, cần dùng multiplexer hoặc đọc luân phiên
    // Ở đây chỉ đọc Soil, LDR có thể bỏ qua hoặc dùng multiplexer
    int lightPct = 0; // Placeholder - cần multiplexer để đọc LDR

    // --------- In ra Serial để debug ---------
    Serial.print("📊 DHT: ");
    if (dhtFail) {
      Serial.print("FAIL | ");
    } else {
      Serial.print("T=");
      Serial.print(t, 2);
      Serial.print("°C H=");
      Serial.print(h, 2);
      Serial.print("% | ");
    }
    Serial.print("Soil: ");
    Serial.print(soilPct);
    Serial.print("% | Light: ");
    Serial.print(lightPct);
    Serial.println("% (LDR cần multiplexer)");

    // --------- Gửi lên server mỗi SEND_PERIOD (60 giây) ---------
    if (now - lastSend >= SEND_PERIOD) {
      lastSend = now;
      
      Serial.println("🚀 Bắt đầu gửi dữ liệu lên server...");

      // Gửi nhiệt độ
      if (!dhtFail) {
        sendSensorDataToServer(SENSOR_ID_TEMPERATURE, t);
        delay(500);
      }

      // Gửi độ ẩm không khí
      if (!dhtFail) {
        sendSensorDataToServer(SENSOR_ID_HUMIDITY, h);
        delay(500);
      }

      // Gửi độ ẩm đất
      sendSensorDataToServer(SENSOR_ID_SOIL, (float)soilPct);
      delay(500);

      // Gửi độ sáng (nếu có multiplexer)
      // sendSensorDataToServer(SENSOR_ID_LIGHT, (float)lightPct);
      // delay(500);

      Serial.println("✅ Đã gửi xong tất cả dữ liệu!");
      Serial.println("---");
    }
  }

  delay(100); // Tránh loop quá nhanh
}

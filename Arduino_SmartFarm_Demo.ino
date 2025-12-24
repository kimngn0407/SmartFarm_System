/**
 * SmartFarm Demo - Hệ thống tự động hóa nông nghiệp thông minh
 * Board: ESP32 30 chân (Type-C)
 * 
 * Tính năng:
 * 1. Đọc dữ liệu từ sensors (DHT11, Soil, Light)
 * 2. Gửi dữ liệu lên VPS qua WiFi
 * 3. Tự động tưới nước khi đất khô
 * 4. LED báo trạng thái (Xanh/Vàng/Đỏ)
 * 
 * Phần cứng:
 *   - DHT11: Nhiệt độ, độ ẩm không khí
 *   - Soil Moisture Sensor: Độ ẩm đất (analog)
 *   - LDR: Cảm biến ánh sáng (analog)
 *   - Relay: Điều khiển máy bơm 5V
 *   - LED: Xanh (OK), Vàng (Cảnh báo), Đỏ (Cần tưới)
 *   - Máy bơm mini 5V: Tưới nước tự động
 */

#include "DHT.h"
#include <WiFi.h>
#include <HTTPClient.h>
#include <ArduinoJson.h>
#include <time.h>

// ================== Cấu hình WiFi ==================
const char* ssid = "YOUR_WIFI_SSID";
const char* password = "YOUR_WIFI_PASSWORD";

// ================== Cấu hình Backend ==================
const char* serverUrl = "http://109.205.180.72:8080/api/sensor-data/iot";

// ================== Cấu hình Sensor IDs ==================
const long SENSOR_ID_TEMPERATURE = 1;
const long SENSOR_ID_HUMIDITY = 2;
const long SENSOR_ID_SOIL = 3;
const long SENSOR_ID_LIGHT = 4;

// ================== Cấu hình Pin ==================
// Sensors
#define DHTPIN       4        // DHT11 DATA (GPIO4)
#define DHTTYPE      DHT11
#define SOIL_PIN     32       // Soil sensor analog (GPIO32 - ADC1_CH4)
#define LIGHT_PIN    33       // LDR analog (GPIO33 - ADC1_CH5)

// Actuators
#define RELAY_PIN    25       // Relay điều khiển máy bơm (GPIO25)
#define LED_GREEN    26       // LED xanh - Trạng thái OK (GPIO26)
#define LED_YELLOW   27       // LED vàng - Cảnh báo (GPIO27)
#define LED_RED      14       // LED đỏ - Cần tưới (GPIO14)

// ================== Cấu hình Tự động hóa ==================
const int SOIL_THRESHOLD_DRY = 30;      // Ngưỡng đất khô (%)
const int SOIL_THRESHOLD_WET = 70;      // Ngưỡng đất đủ ẩm (%)
const unsigned long PUMP_DURATION = 5000;  // Thời gian bơm nước (ms) - 5 giây
const unsigned long PUMP_COOLDOWN = 60000; // Thời gian chờ giữa các lần bơm (ms) - 1 phút

// ================== Hiệu chuẩn Sensors ==================
const uint8_t AVG_SAMPLES = 5;
int SOIL_RAW_DRY = 4095;      // ESP32 ADC 12-bit
int SOIL_RAW_WET = 2000;
int LDR_RAW_DARK = 100;
int LDR_RAW_BRIGHT = 3500;

// ================== Biến toàn cục ==================
DHT dht(DHTPIN, DHTTYPE);

unsigned long lastRead = 0;
unsigned long lastSend = 0;
unsigned long lastPumpTime = 0;
const unsigned long READ_PERIOD = 1000;     // Đọc sensor mỗi 1 giây
const unsigned long SEND_PERIOD = 60000;    // Gửi dữ liệu mỗi 60 giây

bool pumpRunning = false;
unsigned long pumpStartTime = 0;

// ================== Hàm tiện ích ==================

int analogReadAvg(uint8_t pin, uint8_t n) {
  long s = 0;
  for (uint8_t i = 0; i < n; i++) {
    s += analogRead(pin);
    delay(2);
  }
  return (int)(s / n);
}

int mapClamp(long x, long in_min, long in_max, long out_min, long out_max) {
  if (in_min == in_max) return (int)out_min;
  long v = (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
  if (v < out_min) v = out_min;
  if (v > out_max) v = out_max;
  return (int)v;
}

String getCurrentTimeISO() {
  struct tm timeinfo;
  if (getLocalTime(&timeinfo)) {
    char timeStr[25];
    sprintf(timeStr, "%04d-%02d-%02dT%02d:%02d:%02dZ",
            timeinfo.tm_year + 1900, timeinfo.tm_mon + 1, timeinfo.tm_mday,
            timeinfo.tm_hour, timeinfo.tm_min, timeinfo.tm_sec);
    return String(timeStr);
  } else {
    unsigned long seconds = millis() / 1000;
    unsigned long hours = (seconds % 86400) / 3600;
    unsigned long minutes = (seconds % 3600) / 60;
    unsigned long secs = seconds % 60;
    char timeStr[25];
    sprintf(timeStr, "2024-12-20T%02lu:%02lu:%02luZ", hours, minutes, secs);
    return String(timeStr);
  }
}

bool sendSensorDataToServer(long sensorId, float value) {
  if (WiFi.status() != WL_CONNECTED) {
    Serial.println("❌ WiFi not connected!");
    return false;
  }

  HTTPClient http;
  http.begin(serverUrl);
  http.addHeader("Content-Type", "application/json");

  String currentTime = getCurrentTimeISO();
  StaticJsonDocument<200> doc;
  doc["sensorId"] = sensorId;
  doc["value"] = value;
  doc["time"] = currentTime;

  String jsonPayload;
  serializeJson(doc, jsonPayload);

  Serial.print("📤 Sending: ");
  Serial.println(jsonPayload);

  int httpResponseCode = http.POST(jsonPayload);

  if (httpResponseCode > 0) {
    Serial.print("✅ HTTP Response: ");
    Serial.println(httpResponseCode);
    http.end();
    return true;
  } else {
    Serial.print("❌ Error: ");
    Serial.println(httpResponseCode);
    http.end();
    return false;
  }
}

// ================== Hàm điều khiển ==================

/**
 * Bật/tắt máy bơm
 */
void setPump(bool on) {
  if (on) {
    digitalWrite(RELAY_PIN, HIGH);  // Relay ON = Bơm chạy
    pumpRunning = true;
    pumpStartTime = millis();
    Serial.println("💧 Máy bơm BẬT");
  } else {
    digitalWrite(RELAY_PIN, LOW);   // Relay OFF = Bơm tắt
    pumpRunning = false;
    Serial.println("💧 Máy bơm TẮT");
  }
}

/**
 * Cập nhật LED báo trạng thái
 * Xanh: Đất đủ ẩm (>70%)
 * Vàng: Đất hơi khô (30-70%)
 * Đỏ: Đất khô (<30%) hoặc đang tưới
 */
void updateStatusLED(int soilPercent) {
  // Tắt tất cả LED trước
  digitalWrite(LED_GREEN, LOW);
  digitalWrite(LED_YELLOW, LOW);
  digitalWrite(LED_RED, LOW);

  if (pumpRunning) {
    // Đang tưới - LED đỏ nhấp nháy
    digitalWrite(LED_RED, (millis() / 200) % 2);
  } else if (soilPercent >= SOIL_THRESHOLD_WET) {
    // Đất đủ ẩm - LED xanh
    digitalWrite(LED_GREEN, HIGH);
  } else if (soilPercent >= SOIL_THRESHOLD_DRY) {
    // Đất hơi khô - LED vàng
    digitalWrite(LED_YELLOW, HIGH);
  } else {
    // Đất khô - LED đỏ
    digitalWrite(LED_RED, HIGH);
  }
}

/**
 * Logic tự động tưới nước
 */
void autoWatering(int soilPercent) {
  unsigned long now = millis();

  // Nếu máy bơm đang chạy, kiểm tra thời gian
  if (pumpRunning) {
    if (now - pumpStartTime >= PUMP_DURATION) {
      // Đã bơm đủ thời gian, tắt máy bơm
      setPump(false);
      lastPumpTime = now;
      Serial.println("✅ Đã tưới xong");
    }
    return;
  }

  // Kiểm tra cooldown (tránh bơm liên tục)
  if (now - lastPumpTime < PUMP_COOLDOWN) {
    return;
  }

  // Logic tự động: Nếu đất khô hơn ngưỡng, bật máy bơm
  if (soilPercent < SOIL_THRESHOLD_DRY) {
    Serial.println("🌱 Đất khô - Bắt đầu tưới tự động");
    setPump(true);
  }
}

// ================== Setup ==================
void setup() {
  Serial.begin(115200);
  delay(1000);

  Serial.println("=== SmartFarm Demo - Hệ thống Tự động hóa ===");

  // Cấu hình pin
  pinMode(RELAY_PIN, OUTPUT);
  pinMode(LED_GREEN, OUTPUT);
  pinMode(LED_YELLOW, OUTPUT);
  pinMode(LED_RED, OUTPUT);
  pinMode(SOIL_PIN, INPUT);
  pinMode(LIGHT_PIN, INPUT);

  // Tắt tất cả ban đầu
  digitalWrite(RELAY_PIN, LOW);
  digitalWrite(LED_GREEN, LOW);
  digitalWrite(LED_YELLOW, LOW);
  digitalWrite(LED_RED, LOW);

  // Khởi tạo DHT
  dht.begin();

  // Kết nối WiFi
  Serial.println("📡 Đang kết nối WiFi...");
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("");
  Serial.println("✅ WiFi connected!");
  Serial.print("📡 IP: ");
  Serial.println(WiFi.localIP());

  // Cấu hình NTP
  configTime(25200, 0, "pool.ntp.org", "time.nist.gov", "time.google.com");
  Serial.println("⏰ Đang sync thời gian...");
  delay(2000);

  Serial.println("=== Hệ thống sẵn sàng ===");
  Serial.println("💡 LED Xanh: Đất đủ ẩm");
  Serial.println("💡 LED Vàng: Đất hơi khô");
  Serial.println("💡 LED Đỏ: Đất khô hoặc đang tưới");
  Serial.println("💧 Máy bơm tự động khi đất < 30%");
}

// ================== Loop ==================
void loop() {
  unsigned long now = millis();

  // Đọc sensors mỗi READ_PERIOD
  if (now - lastRead >= READ_PERIOD) {
    lastRead = now;

    // Đọc DHT11
    float h = dht.readHumidity();
    float t = dht.readTemperature();
    if (isnan(h) || isnan(t)) {
      delay(50);
      h = dht.readHumidity();
      t = dht.readTemperature();
    }
    bool dhtFail = isnan(h) || isnan(t);

    // Đọc độ ẩm đất
    int soilRaw = analogReadAvg(SOIL_PIN, AVG_SAMPLES);
    int soilPct = mapClamp(soilRaw, SOIL_RAW_DRY, SOIL_RAW_WET, 0, 100);

    // Đọc ánh sáng
    int lightRaw = analogReadAvg(LIGHT_PIN, AVG_SAMPLES);
    int lightPct = mapClamp(lightRaw, LDR_RAW_DARK, LDR_RAW_BRIGHT, 0, 100);

    // In ra Serial
    Serial.print("📊 ");
    if (dhtFail) {
      Serial.print("DHT: FAIL | ");
    } else {
      Serial.print("T=");
      Serial.print(t, 1);
      Serial.print("°C H=");
      Serial.print(h, 1);
      Serial.print("% | ");
    }
    Serial.print("Soil: ");
    Serial.print(soilPct);
    Serial.print("% | Light: ");
    Serial.print(lightPct);
    Serial.print("% | Pump: ");
    Serial.print(pumpRunning ? "ON" : "OFF");
    Serial.println();

    // Tự động tưới nước
    autoWatering(soilPct);

    // Cập nhật LED báo trạng thái
    updateStatusLED(soilPct);

    // Gửi dữ liệu lên server mỗi SEND_PERIOD
    if (now - lastSend >= SEND_PERIOD) {
      lastSend = now;
      Serial.println("🚀 Gửi dữ liệu lên server...");

      if (!dhtFail) {
        sendSensorDataToServer(SENSOR_ID_TEMPERATURE, t);
        delay(300);
        sendSensorDataToServer(SENSOR_ID_HUMIDITY, h);
        delay(300);
      }
      sendSensorDataToServer(SENSOR_ID_SOIL, (float)soilPct);
      delay(300);
      sendSensorDataToServer(SENSOR_ID_LIGHT, (float)lightPct);
      delay(300);

      Serial.println("✅ Đã gửi xong!");
    }
  }

  delay(100);
}

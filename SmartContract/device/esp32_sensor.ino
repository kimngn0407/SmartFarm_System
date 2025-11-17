/*
 * ESP32 SmartFarm - Gửi dữ liệu trực tiếp lên VPS qua WiFi
 * KHÔNG CẦN máy tính trung gian!
 * 
 * Phần cứng cần:
 * - ESP32 (có WiFi tích hợp)
 * - DHT22 (nhiệt độ, độ ẩm)
 * - Cảm biến độ ẩm đất (analog)
 * - Cảm biến ánh sáng (analog)
 */

#include <WiFi.h>
#include <HTTPClient.h>
#include <DHT.h>
#include <ArduinoJson.h>
#include <time.h>

// ========== CẤU HÌNH WIFI ==========
const char* ssid = "YOUR_WIFI_SSID";        // ← Đổi tên WiFi của bạn
const char* password = "YOUR_WIFI_PASSWORD"; // ← Đổi mật khẩu WiFi

// ========== CẤU HÌNH VPS ==========
const char* VPS_URL = "http://YOUR_VPS_IP:8000/api/sensors"; // ← Đổi IP VPS của bạn
const char* API_KEY = "MY_API_KEY";                          // ← Đổi API key

// ========== CẤU HÌNH CẢM BIẾN ==========
#define DHTPIN 4          // Chân DHT22 (có thể đổi)
#define DHTTYPE DHT22
DHT dht(DHTPIN, DHTTYPE);

#define SOIL_PIN 34       // GPIO34 (ADC1) - Cảm biến độ ẩm đất
#define LIGHT_PIN 35      // GPIO35 (ADC1) - Cảm biến ánh sáng

// ========== CẤU HÌNH NTP (để lấy thời gian chính xác) ==========
const char* ntpServer = "pool.ntp.org";
const long gmtOffset_sec = 7 * 3600;  // GMT+7 (Việt Nam)
const int daylightOffset_sec = 0;

// ========== BIẾN TOÀN CỤC ==========
unsigned long lastSendTime = 0;
const unsigned long sendInterval = 5000;  // Gửi mỗi 5 giây
int sensorId = 1;  // ID cảm biến (đổi theo nhu cầu)

void setup() {
  Serial.begin(115200);
  delay(1000);
  
  Serial.println("\n\n=== ESP32 SmartFarm Sensor ===");
  
  // Khởi tạo cảm biến
  dht.begin();
  pinMode(SOIL_PIN, INPUT);
  pinMode(LIGHT_PIN, INPUT);
  
  // Kết nối WiFi
  connectWiFi();
  
  // Cấu hình NTP để lấy thời gian
  configTime(gmtOffset_sec, daylightOffset_sec, ntpServer);
  
  Serial.println("Setup hoàn tất!");
}

void loop() {
  // Kiểm tra kết nối WiFi
  if (WiFi.status() != WL_CONNECTED) {
    Serial.println("WiFi mất kết nối! Đang kết nối lại...");
    connectWiFi();
    return;
  }
  
  // Gửi dữ liệu theo chu kỳ
  unsigned long currentTime = millis();
  if (currentTime - lastSendTime >= sendInterval) {
    sendSensorData();
    lastSendTime = currentTime;
  }
  
  delay(100);  // Delay nhỏ để tránh quá tải
}

void connectWiFi() {
  Serial.print("Đang kết nối WiFi: ");
  Serial.println(ssid);
  
  WiFi.mode(WIFI_STA);
  WiFi.begin(ssid, password);
  
  int attempts = 0;
  while (WiFi.status() != WL_CONNECTED && attempts < 20) {
    delay(500);
    Serial.print(".");
    attempts++;
  }
  
  if (WiFi.status() == WL_CONNECTED) {
    Serial.println("\n✅ Kết nối WiFi thành công!");
    Serial.print("IP Address: ");
    Serial.println(WiFi.localIP());
  } else {
    Serial.println("\n❌ Không thể kết nối WiFi!");
  }
}

void sendSensorData() {
  // Đọc cảm biến
  float temperature = dht.readTemperature();
  float humidity = dht.readHumidity();
  
  // Kiểm tra lỗi DHT
  if (isnan(temperature) || isnan(humidity)) {
    Serial.println("⚠️ Lỗi đọc DHT22");
    return;
  }
  
  // Đọc cảm biến analog (0-4095 trên ESP32)
  int soilRaw = analogRead(SOIL_PIN);
  int lightRaw = analogRead(LIGHT_PIN);
  
  // Chuyển đổi sang % (0-100)
  float soil_pct = map(soilRaw, 0, 4095, 0, 100);
  float light_pct = map(lightRaw, 0, 4095, 0, 100);
  
  // Lấy thời gian hiện tại (Unix timestamp)
  time_t now = time(nullptr);
  if (now < 1000000000) {
    // Nếu chưa có thời gian từ NTP, dùng millis() làm tạm thời
    now = millis() / 1000;
  }
  
  // Tạo JSON payload
  StaticJsonDocument<200> doc;
  doc["sensorId"] = sensorId;
  doc["time"] = (unsigned long)now;
  doc["temperature"] = temperature;
  doc["humidity"] = humidity;
  doc["soil_pct"] = soil_pct;
  doc["light"] = light_pct;
  
  String jsonPayload;
  serializeJson(doc, jsonPayload);
  
  Serial.print("📤 Gửi dữ liệu: ");
  Serial.println(jsonPayload);
  
  // Gửi HTTP POST lên VPS
  HTTPClient http;
  http.begin(VPS_URL);
  http.addHeader("Content-Type", "application/json");
  http.addHeader("x-api-key", API_KEY);
  
  int httpResponseCode = http.POST(jsonPayload);
  
  if (httpResponseCode > 0) {
    Serial.print("✅ Gửi thành công! Status: ");
    Serial.println(httpResponseCode);
    
    String response = http.getString();
    Serial.println("Response: " + response);
  } else {
    Serial.print("❌ Lỗi gửi dữ liệu! Code: ");
    Serial.println(httpResponseCode);
    Serial.print("Error: ");
    Serial.println(http.errorToString(httpResponseCode));
  }
  
  http.end();
}


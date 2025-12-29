

#include "DHT.h"
#include <WiFi.h> 
#include <HTTPClient.h>
#include <ArduinoJson.h>
#include <time.h>

// ================== Cấu hình WiFi ==================
const char* ssid = "Nha Ong Ba";
const char* password = "nhaongba@";

// ================== Cấu hình Backend ==================
// Lưu ý: ESP32 dùng HTTP (không HTTPS) vì HTTPS cần nhiều memory
// ⚠️ QUAN TRỌNG: Phải dùng IP và port 8080 trực tiếp để tránh Nginx redirect HTTP->HTTPS
const char* serverUrl = "http://109.205.180.72:8080/api/sensor-data/iot";

// ================== Cấu hình Sensor IDs ==================
const long SENSOR_ID_TEMPERATURE = 7;  // Match với frontend sensor ID
const long SENSOR_ID_HUMIDITY = 8;     // Match với frontend sensor ID
const long SENSOR_ID_SOIL = 9;         // Match với frontend sensor ID
const long SENSOR_ID_LIGHT = 10;       // Match với frontend sensor ID

// ================== Cấu hình Pin ==================
#define DHTPIN       4        // DHT11 DATA (GPIO4 = D4)
#define DHTTYPE      DHT11
#define SOIL_PIN     34        // Soil sensor analog (GPIO2 = D2)
#define LIGHT_PIN    5        // LDR Module digital (GPIO5 = D5)
#define RELAY_PUMP   18       // Relay máy bơm (GPIO18 = D18)
#define LED_GREEN    21       // LED xanh (GPIO21 = D21)
#define LED_YELLOW   22       // LED vàng (GPIO22 = D22)
#define LED_RED      23       // LED đỏ (GPIO23 = D23)

// ================== Cấu hình Relay ==================
// ⚠️ QUAN TRỌNG: Chọn loại chân relay đang dùng
// - true = Dùng chân NO (Normally Open) - NO mở khi relay OFF (LOW)
// - false = Dùng chân NC (Normally Closed) - NC đóng khi relay OFF (LOW)
#define USE_RELAY_NO  true    // true = chân NO, false = chân NC

// ================== Cấu hình Ngưỡng - DEMO ==================
// ⚙️ CÓ THỂ THAY ĐỔI LINH HOẠT KHI DEMO

const int SOIL_MIN = 30;      // Độ ẩm đất tối thiểu (%)
const int SOIL_MAX = 70;      // Độ ẩm đất tối đa (%)
const float TEMP_MIN = 20.0;  // Nhiệt độ tối thiểu (°C)
const float TEMP_MAX = 30.0;  // Nhiệt độ tối đa (°C)
const float HUMIDITY_MIN = 40.0;  // Độ ẩm không khí tối thiểu (%)
const float HUMIDITY_MAX = 70.0;  // Độ ẩm không khí tối đa (%)

const unsigned long PUMP_DURATION = 5000;   // Thời gian bơm (ms)
const unsigned long PUMP_COOLDOWN = 60000;   // Thời gian chờ (ms)

// ================== Hiệu chuẩn ==================
// ⚠️ CẦN HIỆU CHỈNH DỰA TRÊN GIÁ TRỊ THỰC TẾ
// - Đất khô: Giá trị cao (gần 4095)
// - Đất ướt: Giá trị thấp (gần 0)
// Để tìm giá trị: Đọc raw value khi đất khô và ướt
int SOIL_RAW_DRY = 4095;   // Giá trị khi đất khô (cao)
int SOIL_RAW_WET = 2000;   // Giá trị khi đất ướt (thấp)
// Nếu sensor đọc ngược (khô = thấp, ướt = cao), đổi 2 giá trị này

// ================== Biến toàn cục ==================
DHT dht(DHTPIN, DHTTYPE);

unsigned long lastRead = 0;
unsigned long lastSend = 0;
unsigned long lastPumpTime = 0;
unsigned long pumpStartTime = 0;

const unsigned long READ_PERIOD = 1000;     // Đọc mỗi 1 giây
const unsigned long SEND_PERIOD = 60000;     // Gửi mỗi 60 giây

bool pumpRunning = false;

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
    Serial.print("❌ WiFi not connected for sensor ");
    Serial.println(sensorId);
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

  Serial.print("📤 Sending sensor ");
  Serial.print(sensorId);
  Serial.print(": ");
  Serial.println(jsonPayload);

  int httpResponseCode = http.POST(jsonPayload);
  
  if (httpResponseCode > 0) {
    Serial.print("✅ Sensor ");
    Serial.print(sensorId);
    Serial.print(" - HTTP ");
    Serial.println(httpResponseCode);
    String response = http.getString();
    Serial.print("📥 Response: ");
    Serial.println(response);
  } else {
    Serial.print("❌ Sensor ");
    Serial.print(sensorId);
    Serial.print(" - Error code: ");
    Serial.println(httpResponseCode);
  }
  
  http.end();
  return (httpResponseCode > 0);
}

// ================== Hàm điều khiển ==================

void setPump(bool on) {
  // Logic relay tùy thuộc vào loại chân (NC hoặc NO)
  #if USE_RELAY_NO
    // Chân NO (Normally Open):
    // - HIGH = Relay ON → NO đóng → Máy bơm CHẠY
    // - LOW = Relay OFF → NO mở → Máy bơm TẮT
    digitalWrite(RELAY_PUMP, on ? HIGH : LOW);
  #else
    // Chân NC (Normally Closed):
    // - LOW = Relay OFF → NC đóng → Máy bơm CHẠY
    // - HIGH = Relay ON → NC mở → Máy bơm TẮT
    // Cần đảo logic: on ? LOW : HIGH
    digitalWrite(RELAY_PUMP, on ? LOW : HIGH);
  #endif
  
  pumpRunning = on;
  if (on) {
    pumpStartTime = millis();
    Serial.println("💧 Máy bơm BẬT");
  } else {
    Serial.println("💧 Máy bơm TẮT");
  }
}

void updateLED(float temperature, float humidity) {
  // Tắt tất cả LED
  digitalWrite(LED_GREEN, LOW);
  digitalWrite(LED_YELLOW, LOW);
  digitalWrite(LED_RED, LOW);

  if (pumpRunning) {
    // Đang tưới - LED đỏ nhấp nháy
    digitalWrite(LED_RED, (millis() / 200) % 2);
    return;
  }

  // Tính ngưỡng cảnh báo (10%)
  float tempRange = TEMP_MAX - TEMP_MIN;
  float tempWarningLow = TEMP_MIN - (tempRange * 0.1);
  float tempWarningHigh = TEMP_MAX + (tempRange * 0.1);

  float humidityRange = HUMIDITY_MAX - HUMIDITY_MIN;
  float humidityWarningLow = HUMIDITY_MIN - (humidityRange * 0.1);
  float humidityWarningHigh = HUMIDITY_MAX + (humidityRange * 0.1);

  // Kiểm tra nhiệt độ
  bool tempInRange = (temperature >= TEMP_MIN && temperature <= TEMP_MAX);
  bool tempInWarning = (temperature >= tempWarningLow && temperature < TEMP_MIN) || 
                       (temperature > TEMP_MAX && temperature <= tempWarningHigh);
  bool tempOutOfRange = (temperature < tempWarningLow || temperature > tempWarningHigh);

  // Kiểm tra độ ẩm
  bool humidityInRange = (humidity >= HUMIDITY_MIN && humidity <= HUMIDITY_MAX);
  bool humidityInWarning = (humidity >= humidityWarningLow && humidity < HUMIDITY_MIN) || 
                           (humidity > HUMIDITY_MAX && humidity <= humidityWarningHigh);
  bool humidityOutOfRange = (humidity < humidityWarningLow || humidity > humidityWarningHigh);

  // Logic LED: Ưu tiên trạng thái xấu nhất
  if (tempInRange && humidityInRange) {
    digitalWrite(LED_GREEN, HIGH);  // Cả 2 đều OK → Xanh
  } else if (tempOutOfRange || humidityOutOfRange) {
    digitalWrite(LED_RED, HIGH);    // Một trong 2 quá ngưỡng → Đỏ
  } else if (tempInWarning || humidityInWarning) {
    digitalWrite(LED_YELLOW, HIGH); // Một trong 2 cảnh báo → Vàng
  } else {
    digitalWrite(LED_RED, HIGH);    // An toàn → Đỏ
  }
}

void checkPump(int soilPercent) {
  unsigned long now = millis();

  // Nếu máy bơm đang chạy, kiểm tra thời gian
  if (pumpRunning) {
    if (now - pumpStartTime >= PUMP_DURATION) {
      setPump(false);
      lastPumpTime = now;
      Serial.println("✅ Đã tưới xong");
    }
    return;
  }

  // Kiểm tra cooldown
  if (now - lastPumpTime < PUMP_COOLDOWN) {
    return;
  }

  // Logic: Chỉ bật máy bơm khi đất khô (không bật khi đất quá ẩm)
  if (soilPercent < SOIL_MIN) {
    Serial.print("🌱 Đất khô (");
    Serial.print(soilPercent);
    Serial.print("% < ");
    Serial.print(SOIL_MIN);
    Serial.println("%) - Bật máy bơm");
    setPump(true);
  } else if (soilPercent > SOIL_MAX) {
    // Đất quá ẩm - KHÔNG bật máy bơm (chỉ log để debug)
    Serial.print("💧 Đất quá ẩm (");
    Serial.print(soilPercent);
    Serial.print("% > ");
    Serial.print(SOIL_MAX);
    Serial.println("%) - Không tưới");
    // Không bật máy bơm khi đất quá ẩm
  }
}

// ================== Setup ==================
void setup() {
  Serial.begin(115200);
  delay(1000);

  Serial.println("=== SmartFarm Demo ===");

  // Cấu hình pin
  pinMode(RELAY_PUMP, OUTPUT);
  pinMode(LED_GREEN, OUTPUT);
  pinMode(LED_YELLOW, OUTPUT);
  pinMode(LED_RED, OUTPUT);
  pinMode(SOIL_PIN, INPUT);
  pinMode(LIGHT_PIN, INPUT_PULLUP);

  // Tắt tất cả ban đầu
  #if USE_RELAY_NO
    // Chân NO: LOW để tắt máy bơm (NO mở)
    digitalWrite(RELAY_PUMP, LOW);
  #else
    // Chân NC: HIGH để tắt máy bơm (NC mở)
    digitalWrite(RELAY_PUMP, HIGH);
  #endif
  
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
  delay(2000);

  Serial.println("=== Hệ thống sẵn sàng ===");
  Serial.print("🌱 Độ ẩm đất: ");
  Serial.print(SOIL_MIN);
  Serial.print("-");
  Serial.println(SOIL_MAX);
  Serial.print("🌡️ Nhiệt độ: ");
  Serial.print(TEMP_MIN);
  Serial.print("-");
  Serial.println(TEMP_MAX);
  Serial.print("💧 Độ ẩm không khí: ");
  Serial.print(HUMIDITY_MIN);
  Serial.print("-");
  Serial.println(HUMIDITY_MAX);
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
    
    // Debug DHT
    if (dhtFail) {
      Serial.print("⚠️ DHT Fail - T: ");
      Serial.print(t);
      Serial.print(" H: ");
      Serial.println(h);
    } else {
      Serial.print("✅ DHT OK - T: ");
      Serial.print(t);
      Serial.print("°C, H: ");
      Serial.print(h);
      Serial.println("%");
    }

    // Đọc độ ẩm đất
    int soilRaw = analogReadAvg(SOIL_PIN, 5);
    
    // DEBUG: Đọc tất cả pin analog để tìm pin đúng
    Serial.print("DEBUG - Soil Raw: ");
    Serial.print(soilRaw);
    Serial.print(" | GPIO2: ");
    Serial.print(analogRead(2));
    Serial.print(" | GPIO32: ");
    Serial.print(analogRead(32));
    Serial.print(" | GPIO33: ");
    Serial.print(analogRead(33));
    Serial.print(" | GPIO34: ");
    Serial.print(analogRead(34));
    Serial.print(" | GPIO35: ");
    Serial.print(analogRead(35));
    
    // Kiểm tra nếu sensor không hoạt động
    int soilPct;
    if (soilRaw == 0 || soilRaw < 10) {
      Serial.print(" ⚠️ Sensor có thể chưa nối đúng!");
      soilPct = 50;  // Set giá trị trung bình thay vì 100
    } else {
      // Clamp giá trị raw vào phạm vi hợp lệ
      if (soilRaw > SOIL_RAW_DRY) {
        soilRaw = SOIL_RAW_DRY;  // Giới hạn tối đa
      } else if (soilRaw < SOIL_RAW_WET) {
        soilRaw = SOIL_RAW_WET;  // Giới hạn tối thiểu
      }
      
      // Map từ raw value sang phần trăm
      soilPct = mapClamp(soilRaw, SOIL_RAW_DRY, SOIL_RAW_WET, 0, 100);
      
      // Debug: In giá trị sau khi map
      Serial.print(" | Mapped: ");
      Serial.print(soilPct);
      Serial.print("%");
    }

    // Đọc ánh sáng (LDR Module - Digital)
    // Thử cả 2 logic: HIGH = Sáng hoặc HIGH = Tối
    int lightValue = digitalRead(LIGHT_PIN);
    int lightPct = 0;
    
    // DEBUG: In giá trị digital
    Serial.print(", Light Digital: ");
    Serial.print(lightValue);
    
    // Logic: Nếu HIGH = Sáng, LOW = Tối
    // Nếu vẫn sai, đổi thành: lightPct = (lightValue == LOW) ? 100 : 0;
    lightPct = (lightValue == HIGH) ? 100 : 0;

    // In ra Serial (giống style ví dụ)
    Serial.print("{\"time\":");
    Serial.print(now / 1000);
    Serial.print(",\"temperature\":");
    if (dhtFail) {
      Serial.print("null");
    } else {
      Serial.print(t, 2);
    }
    Serial.print(",\"humidity\":");
    if (dhtFail) {
      Serial.print("null");
    } else {
      Serial.print(h, 2);
    }
    Serial.print(",\"soil\":");
    Serial.print(soilPct);
    Serial.print(",\"light\":");
    Serial.print(lightPct);
    Serial.println("}");

    // Kiểm tra và điều khiển máy bơm
    checkPump(soilPct);

    // Cập nhật LED
    if (!dhtFail) {
      updateLED(t, h);
    } else {
      digitalWrite(LED_GREEN, LOW);
      digitalWrite(LED_YELLOW, LOW);
      digitalWrite(LED_RED, HIGH);
    }

    // Gửi dữ liệu lên server mỗi SEND_PERIOD
    if (now - lastSend >= SEND_PERIOD) {
      lastSend = now;
      Serial.println("🚀 Gửi dữ liệu lên server...");

      // Gửi nhiệt độ
      if (!dhtFail) {
        Serial.println("📊 Gửi nhiệt độ...");
        sendSensorDataToServer(SENSOR_ID_TEMPERATURE, t);
        delay(500);
        
        Serial.println("📊 Gửi độ ẩm không khí...");
        sendSensorDataToServer(SENSOR_ID_HUMIDITY, h);
        delay(500);
      } else {
        Serial.println("⚠️ DHT fail - Bỏ qua nhiệt độ và độ ẩm");
      }
      
      // Gửi độ ẩm đất
      Serial.println("📊 Gửi độ ẩm đất...");
      sendSensorDataToServer(SENSOR_ID_SOIL, (float)soilPct);
      delay(500);
      
      // Gửi ánh sáng
      Serial.println("📊 Gửi ánh sáng...");
      sendSensorDataToServer(SENSOR_ID_LIGHT, (float)lightPct);
      delay(500);

      Serial.println("✅ Đã gửi xong tất cả sensors!");
    }
  }

  delay(100);
}

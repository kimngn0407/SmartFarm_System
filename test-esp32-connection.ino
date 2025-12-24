/**
 * Test ESP32 Connection
 * Code đơn giản để test kết nối ESP32 với Arduino IDE
 */

void setup() {
  // Khởi tạo Serial
  Serial.begin(115200);
  delay(1000);
  
  Serial.println("=================================");
  Serial.println("ESP32 Connection Test");
  Serial.println("=================================");
  Serial.println("✅ ESP32 đã kết nối thành công!");
  Serial.println("");
  
  // Test LED built-in
  pinMode(LED_BUILTIN, OUTPUT);
  Serial.println("💡 Test LED - Nhấp nháy 5 lần...");
  
  for (int i = 0; i < 5; i++) {
    digitalWrite(LED_BUILTIN, HIGH);
    delay(200);
    digitalWrite(LED_BUILTIN, LOW);
    delay(200);
  }
  
  Serial.println("✅ LED test OK!");
  Serial.println("");
  Serial.println("📊 Thông tin ESP32:");
  Serial.print("   Chip Model: ");
  Serial.println(ESP.getChipModel());
  Serial.print("   Chip Revision: ");
  Serial.println(ESP.getChipRevision());
  Serial.print("   CPU Frequency: ");
  Serial.print(ESP.getCpuFreqMHz());
  Serial.println(" MHz");
  Serial.print("   Flash Size: ");
  Serial.print(ESP.getFlashChipSize() / 1024 / 1024);
  Serial.println(" MB");
  Serial.print("   Free Heap: ");
  Serial.print(ESP.getFreeHeap() / 1024);
  Serial.println(" KB");
  Serial.println("");
  Serial.println("=================================");
  Serial.println("Nếu bạn thấy message này,");
  Serial.println("ESP32 đã kết nối và hoạt động OK!");
  Serial.println("=================================");
}

void loop() {
  // Blink LED mỗi 2 giây
  digitalWrite(LED_BUILTIN, HIGH);
  Serial.println("LED ON");
  delay(2000);
  
  digitalWrite(LED_BUILTIN, LOW);
  Serial.println("LED OFF");
  delay(2000);
}

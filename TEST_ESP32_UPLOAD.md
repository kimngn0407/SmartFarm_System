# ✅ Test Upload Code lên ESP32

## 🎯 Bước tiếp theo

Bạn đã có:
- ✅ ESP32 3.3.5 đã cài đặt
- ✅ Board: ESP32 Dev Module
- ✅ Port: COM9
- ✅ Code test sẵn sàng

## 🚀 Test Upload

### Bước 1: Upload code hiện tại

1. **Click nút Upload** (mũi tên →) hoặc `Ctrl + U`
2. **Nếu lỗi "Failed to connect":**
   - Giữ nút **BOOT** trên ESP32
   - Click Upload
   - Khi thấy "Connecting..." → Thả nút BOOT

### Bước 2: Kiểm tra Serial Monitor

1. **Mở Serial Monitor:** `Ctrl + Shift + M`
2. **Baud rate: 115200**
3. **Nhấn nút RESET trên ESP32**
4. **Phải thấy:**
   ```
   ESP32 READY
   Hello SmartFarm
   Hello SmartFarm
   ...
   ```

## ⚠️ Nếu gặp lỗi "Tool not found"

Arduino IDE cần tools để compile. Có 2 cách:

### Cách 1: Để Arduino IDE tự động download

1. **Khi upload code lần đầu**, Arduino IDE sẽ tự động download tools
2. **Tools nhỏ hơn hardware**, ít bị timeout hơn
3. **Đợi download xong** (có thể mất vài phút)

### Cách 2: Cài tools từ Boards Manager

1. **Tools → Board → Boards Manager**
2. **Tìm "esp32"**
3. **Click "Install"** cho version 3.3.5
4. Arduino IDE sẽ chỉ download tools (không download hardware nữa)

## ✅ Nếu upload thành công

Bạn đã sẵn sàng để:
1. **Upload code SmartFarm:** `Arduino_SmartFarm_Demo.ino`
2. **Cấu hình WiFi** trong code
3. **Cấu hình Sensor IDs** từ database
4. **Test hệ thống tự động hóa**

## 📝 Code test hiện tại

Code bạn đang có:
```cpp
void setup() {
  Serial.begin(115200);
  Serial.println("ESP32 READY");
}

void loop() {
  Serial.println("Hello SmartFarm");
}
```

**Nếu Serial Monitor hiển thị:**
- ✅ "ESP32 READY" → ESP32 hoạt động OK
- ✅ "Hello SmartFarm" lặp lại → Code chạy OK

## 🎯 Bước tiếp theo

Sau khi test thành công:
1. **Mở code SmartFarm:** `Arduino_SmartFarm_Demo.ino`
2. **Cấu hình WiFi** (SSID, password)
3. **Cấu hình Sensor IDs** (từ database trên VPS)
4. **Upload và test hệ thống**

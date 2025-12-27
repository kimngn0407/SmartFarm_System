# 🔧 Fix LED Không Bật - ESP32

## ❌ Vấn đề

- Lúc đầu ESP32 có nháy đèn xanh đỏ
- Bây giờ không thấy đèn xanh bật nữa

## 🔍 Nguyên nhân

1. **Code hiện tại không có logic điều khiển LED**
   - Sketch `sketch_dec24a.ino` chỉ in "Hello SmartFarm"
   - Không có code bật LED xanh/vàng/đỏ

2. **Đèn nháy lúc đầu có thể là:**
   - Bootloader của ESP32 (đèn tích hợp trên board)
   - Code cũ đã được upload trước đó

## ✅ Giải pháp

### Bước 1: Mở Code Đúng

1. **File → Open** trong Arduino IDE
2. **Chọn:** `E:\SmartFarm\Arduino_SmartFarm_Demo.ino`
3. **Đảm bảo** code này có hàm `updateStatusLED()` và điều khiển LED

### Bước 2: Đóng Serial Monitor

1. **Đóng Serial Monitor** hoàn toàn (nút X)
2. **KHÔNG** chỉ minimize

### Bước 3: Cấu hình Upload

```
Tools → Board → ESP32 Dev Module
Tools → Port → COM9
Tools → Upload Speed → 115200
Tools → Erase All Flash Before Sketch Upload → Enabled
```

### Bước 4: Upload Code

1. **Nhấn nút RESET** trên ESP32
2. **Nhấn Upload** trong Arduino IDE
3. **Đợi upload hoàn tất**

### Bước 5: Kiểm tra LED

Sau khi upload thành công:
- **LED Xanh** sẽ bật nếu đất đủ ẩm (>70%)
- **LED Vàng** sẽ bật nếu đất hơi khô (30-70%)
- **LED Đỏ** sẽ bật nếu đất khô (<30%) hoặc đang tưới

### Bước 6: Mở Serial Monitor (Sau khi upload)

1. **Tools → Serial Monitor**
2. **Baud rate:** `115200` (QUAN TRỌNG!)
3. **Xem log** để kiểm tra:
   - WiFi đã kết nối chưa
   - Sensor đọc được giá trị chưa
   - LED có được cập nhật không

## 📋 Checklist

- [ ] Đã mở `Arduino_SmartFarm_Demo.ino` (không phải sketch khác)
- [ ] Đã đóng Serial Monitor trước khi upload
- [ ] Đã cấu hình Upload Speed = 115200
- [ ] Đã bật Erase All Flash Before Sketch Upload
- [ ] Đã upload thành công
- [ ] Đã mở Serial Monitor với baud rate 115200
- [ ] Đã kiểm tra LED có bật không

## 🎯 Logic LED trong Code

```cpp
void updateStatusLED(int soilPercent) {
  if (pumpRunning) {
    // Đang tưới - LED đỏ nhấp nháy
    digitalWrite(LED_RED, (millis() / 200) % 2);
  } else if (soilPercent >= 70) {
    // Đất đủ ẩm - LED xanh
    digitalWrite(LED_GREEN, HIGH);
  } else if (soilPercent >= 30) {
    // Đất hơi khô - LED vàng
    digitalWrite(LED_YELLOW, HIGH);
  } else {
    // Đất khô - LED đỏ
    digitalWrite(LED_RED, HIGH);
  }
}
```

## 💡 Lưu ý

- **LED chỉ bật khi code `Arduino_SmartFarm_Demo.ino` được upload**
- **LED phụ thuộc vào giá trị độ ẩm đất** (từ sensor)
- **Nếu không có sensor kết nối**, LED có thể không hoạt động đúng
- **Serial Monitor phải đặt baud rate 115200** để xem log đúng

## 🔧 Troubleshooting

### LED vẫn không bật sau khi upload

1. **Kiểm tra kết nối LED:**
   - GPIO26 → LED Xanh → GND (qua điện trở 220Ω)
   - GPIO27 → LED Vàng → GND (qua điện trở 220Ω)
   - GPIO14 → LED Đỏ → GND (qua điện trở 220Ω)

2. **Kiểm tra Serial Monitor:**
   - Xem log có hiển thị "📊 Soil: X%" không
   - Nếu không có, sensor chưa kết nối hoặc lỗi

3. **Test LED thủ công:**
   - Upload code test đơn giản để bật LED:
   ```cpp
   void setup() {
     pinMode(26, OUTPUT);
     digitalWrite(26, HIGH);
   }
   void loop() {}
   ```

### Serial Monitor hiển thị "????"

- **Baud rate sai!** Phải đặt `115200` (không phải 9600)

# 🔧 Fix LED Không Bật - ESP32

## ❌ Vấn đề

- Lúc đầu ESP32 có nháy đèn xanh đỏ
- Bây giờ không thấy đèn xanh bật nữa

## 🔍 Nguyên nhân

1. **Code hiện tại không có logic điều khiển LED**
   - Sketch `sketch_dec24a.ino` chỉ in "Hello SmartFarm"
   - Không có code bật LED xanh/vàng/đỏ

2. **Đèn nháy lúc đầu có thể là:**
   - Bootloader của ESP32 (đèn tích hợp trên board)
   - Code cũ đã được upload trước đó

## ✅ Giải pháp

### Bước 1: Mở Code Đúng

1. **File → Open** trong Arduino IDE
2. **Chọn:** `E:\SmartFarm\Arduino_SmartFarm_Demo.ino`
3. **Đảm bảo** code này có hàm `updateStatusLED()` và điều khiển LED

### Bước 2: Đóng Serial Monitor

1. **Đóng Serial Monitor** hoàn toàn (nút X)
2. **KHÔNG** chỉ minimize

### Bước 3: Cấu hình Upload

```
Tools → Board → ESP32 Dev Module
Tools → Port → COM9
Tools → Upload Speed → 115200
Tools → Erase All Flash Before Sketch Upload → Enabled
```

### Bước 4: Upload Code

1. **Nhấn nút RESET** trên ESP32
2. **Nhấn Upload** trong Arduino IDE
3. **Đợi upload hoàn tất**

### Bước 5: Kiểm tra LED

Sau khi upload thành công:
- **LED Xanh** sẽ bật nếu đất đủ ẩm (>70%)
- **LED Vàng** sẽ bật nếu đất hơi khô (30-70%)
- **LED Đỏ** sẽ bật nếu đất khô (<30%) hoặc đang tưới

### Bước 6: Mở Serial Monitor (Sau khi upload)

1. **Tools → Serial Monitor**
2. **Baud rate:** `115200` (QUAN TRỌNG!)
3. **Xem log** để kiểm tra:
   - WiFi đã kết nối chưa
   - Sensor đọc được giá trị chưa
   - LED có được cập nhật không

## 📋 Checklist

- [ ] Đã mở `Arduino_SmartFarm_Demo.ino` (không phải sketch khác)
- [ ] Đã đóng Serial Monitor trước khi upload
- [ ] Đã cấu hình Upload Speed = 115200
- [ ] Đã bật Erase All Flash Before Sketch Upload
- [ ] Đã upload thành công
- [ ] Đã mở Serial Monitor với baud rate 115200
- [ ] Đã kiểm tra LED có bật không

## 🎯 Logic LED trong Code

```cpp
void updateStatusLED(int soilPercent) {
  if (pumpRunning) {
    // Đang tưới - LED đỏ nhấp nháy
    digitalWrite(LED_RED, (millis() / 200) % 2);
  } else if (soilPercent >= 70) {
    // Đất đủ ẩm - LED xanh
    digitalWrite(LED_GREEN, HIGH);
  } else if (soilPercent >= 30) {
    // Đất hơi khô - LED vàng
    digitalWrite(LED_YELLOW, HIGH);
  } else {
    // Đất khô - LED đỏ
    digitalWrite(LED_RED, HIGH);
  }
}
```

## 💡 Lưu ý

- **LED chỉ bật khi code `Arduino_SmartFarm_Demo.ino` được upload**
- **LED phụ thuộc vào giá trị độ ẩm đất** (từ sensor)
- **Nếu không có sensor kết nối**, LED có thể không hoạt động đúng
- **Serial Monitor phải đặt baud rate 115200** để xem log đúng

## 🔧 Troubleshooting

### LED vẫn không bật sau khi upload

1. **Kiểm tra kết nối LED:**
   - GPIO26 → LED Xanh → GND (qua điện trở 220Ω)
   - GPIO27 → LED Vàng → GND (qua điện trở 220Ω)
   - GPIO14 → LED Đỏ → GND (qua điện trở 220Ω)

2. **Kiểm tra Serial Monitor:**
   - Xem log có hiển thị "📊 Soil: X%" không
   - Nếu không có, sensor chưa kết nối hoặc lỗi

3. **Test LED thủ công:**
   - Upload code test đơn giản để bật LED:
   ```cpp
   void setup() {
     pinMode(26, OUTPUT);
     digitalWrite(26, HIGH);
   }
   void loop() {}
   ```

### Serial Monitor hiển thị "????"

- **Baud rate sai!** Phải đặt `115200` (không phải 9600)


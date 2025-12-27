# ✅ Cách Kiểm Tra ESP32 Đã Chạy Code

## 🎯 Các Dấu Hiệu ESP32 Đã Chạy Code

### 1. Serial Monitor Hiển Thị Log ✅

**Cách kiểm tra:**
1. **Mở Serial Monitor:** Tools → Serial Monitor
2. **Baud rate:** `115200` (QUAN TRỌNG!)
3. **Phải thấy:**
   - Log từ `setup()` (chạy 1 lần)
   - Log từ `loop()` (lặp lại liên tục)

**Ví dụ log thành công:**
```
========================================
   ESP32 ĐÃ CHẠY CODE THÀNH CÔNG!
========================================

Chip Model: ESP32-D0WD
CPU Frequency: 240 MHz
Flash Size: 4 MB
Free Heap: 295 KB

✅ Code đang chạy trong loop()...
💡 LED tích hợp sẽ nhấp nháy
📊 Serial Monitor sẽ in log mỗi giây

⏰ Uptime: 1 giây | 💾 Free Heap: 295 KB | 🔄 Loop Count: 1
⏰ Uptime: 2 giây | 💾 Free Heap: 295 KB | 🔄 Loop Count: 2
...
```

### 2. LED Tích Hợp Nhấp Nháy ✅

**Cách kiểm tra:**
- Nhìn vào board ESP32
- LED tích hợp (thường màu xanh/đỏ) sẽ nhấp nháy
- Nếu code có điều khiển LED, LED sẽ bật/tắt theo code

**Lưu ý:**
- Một số board ESP32 không có LED tích hợp
- LED có thể ở GPIO2, GPIO5, hoặc GPIO25 tùy board

### 3. Code Test Đơn Giản

**Upload code test:**
1. **Mở file:** `E:\SmartFarm\test_esp32_running.ino`
2. **Upload lên ESP32**
3. **Mở Serial Monitor** (baud rate 115200)
4. **Kiểm tra:**
   - ✅ Thấy log "ESP32 ĐÃ CHẠY CODE THÀNH CÔNG!"
   - ✅ LED nhấp nháy mỗi giây
   - ✅ Log in ra mỗi giây với uptime tăng dần

## 🔍 Các Cách Kiểm Tra Chi Tiết

### Cách 1: Serial Monitor (Khuyến nghị)

**Bước 1: Upload code test**
```cpp
void setup() {
  Serial.begin(115200);
  Serial.println("ESP32 READY!");
}

void loop() {
  Serial.println("Hello from ESP32!");
  delay(1000);
}
```

**Bước 2: Mở Serial Monitor**
- Tools → Serial Monitor
- Baud rate: `115200`
- Phải thấy: "ESP32 READY!" và "Hello from ESP32!" lặp lại

### Cách 2: LED Tích Hợp

**Code test LED:**
```cpp
#define LED_BUILTIN 2

void setup() {
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  digitalWrite(LED_BUILTIN, HIGH);
  delay(500);
  digitalWrite(LED_BUILTIN, LOW);
  delay(500);
}
```

**Kiểm tra:**
- LED nhấp nháy mỗi 0.5 giây = ✅ Code đang chạy

### Cách 3: WiFi (Nếu code có WiFi)

**Kiểm tra:**
1. **Serial Monitor** hiển thị:
   - "📡 Đang kết nối WiFi..."
   - "✅ WiFi connected!"
   - "📡 IP: 192.168.x.x"

2. **Kiểm tra IP:**
   - Ping IP từ máy tính
   - Hoặc truy cập web server (nếu có)

### Cách 4: Sensor/Actuator (Nếu có)

**Kiểm tra:**
- Sensor đọc được giá trị
- Relay/LED ngoài hoạt động
- Serial Monitor hiển thị giá trị sensor

## ❌ Dấu Hiệu ESP32 KHÔNG Chạy Code

### 1. Serial Monitor Không Hiển Thị Gì

**Nguyên nhân:**
- Baud rate sai (phải là 115200)
- Code chưa upload thành công
- ESP32 bị treo/reset loop

**Giải pháp:**
- Kiểm tra baud rate Serial Monitor
- Upload lại code
- Reset ESP32 (nhấn nút RESET)

### 2. LED Không Nhấp Nháy

**Nguyên nhân:**
- Code không có điều khiển LED
- GPIO LED sai
- LED bị hỏng

**Giải pháp:**
- Upload code test LED
- Kiểm tra GPIO LED (thử GPIO2, GPIO5, GPIO25)

### 3. Serial Monitor Hiển Thị "????" hoặc Ký Tự Lạ

**Nguyên nhân:**
- Baud rate sai!

**Giải pháp:**
- Đổi baud rate Serial Monitor sang `115200`

### 4. Code Upload Thành Công Nhưng Không Chạy

**Nguyên nhân:**
- Code có lỗi runtime
- ESP32 bị reset liên tục
- Nguồn điện không ổn định

**Giải pháp:**
- Xem Serial Monitor có log lỗi không
- Kiểm tra nguồn điện
- Upload code test đơn giản

## 🚀 Quick Test

### Test Nhanh (30 giây)

1. **Upload code:**
   ```cpp
   void setup() {
     Serial.begin(115200);
     pinMode(2, OUTPUT);
   }
   void loop() {
     Serial.println("OK");
     digitalWrite(2, !digitalRead(2));
     delay(500);
   }
   ```

2. **Mở Serial Monitor** (115200)
3. **Kiểm tra:**
   - ✅ Thấy "OK" mỗi 0.5 giây
   - ✅ LED nhấp nháy

### Test Chi Tiết

1. **Upload:** `test_esp32_running.ino`
2. **Mở Serial Monitor** (115200)
3. **Kiểm tra:**
   - ✅ Thông tin chip
   - ✅ Uptime tăng dần
   - ✅ Loop count tăng dần
   - ✅ LED nhấp nháy

## 📋 Checklist

- [ ] Serial Monitor hiển thị log từ setup()
- [ ] Serial Monitor hiển thị log từ loop() (lặp lại)
- [ ] LED tích hợp nhấp nháy (nếu có)
- [ ] Uptime tăng dần trong Serial Monitor
- [ ] Free Heap > 0 (không bị out of memory)
- [ ] Không có lỗi trong Serial Monitor

## 💡 Lưu ý

- **Baud rate Serial Monitor PHẢI là 115200** (không phải 9600)
- **Đóng Serial Monitor trước khi upload** (tránh lỗi PermissionError)
- **Reset ESP32** nếu code không chạy (nhấn nút RESET)
- **Kiểm tra nguồn điện** nếu ESP32 reset liên tục

## 🎯 Kết Luận

**ESP32 đã chạy code nếu:**
1. ✅ Serial Monitor hiển thị log đúng
2. ✅ LED nhấp nháy (nếu code có điều khiển LED)
3. ✅ Uptime tăng dần
4. ✅ Không có lỗi

**Nếu không thấy các dấu hiệu trên:**
- Kiểm tra baud rate Serial Monitor
- Upload lại code
- Reset ESP32
- Kiểm tra nguồn điện

# ✅ Cách Kiểm Tra ESP32 Đã Chạy Code

## 🎯 Các Dấu Hiệu ESP32 Đã Chạy Code

### 1. Serial Monitor Hiển Thị Log ✅

**Cách kiểm tra:**
1. **Mở Serial Monitor:** Tools → Serial Monitor
2. **Baud rate:** `115200` (QUAN TRỌNG!)
3. **Phải thấy:**
   - Log từ `setup()` (chạy 1 lần)
   - Log từ `loop()` (lặp lại liên tục)

**Ví dụ log thành công:**
```
========================================
   ESP32 ĐÃ CHẠY CODE THÀNH CÔNG!
========================================

Chip Model: ESP32-D0WD
CPU Frequency: 240 MHz
Flash Size: 4 MB
Free Heap: 295 KB

✅ Code đang chạy trong loop()...
💡 LED tích hợp sẽ nhấp nháy
📊 Serial Monitor sẽ in log mỗi giây

⏰ Uptime: 1 giây | 💾 Free Heap: 295 KB | 🔄 Loop Count: 1
⏰ Uptime: 2 giây | 💾 Free Heap: 295 KB | 🔄 Loop Count: 2
...
```

### 2. LED Tích Hợp Nhấp Nháy ✅

**Cách kiểm tra:**
- Nhìn vào board ESP32
- LED tích hợp (thường màu xanh/đỏ) sẽ nhấp nháy
- Nếu code có điều khiển LED, LED sẽ bật/tắt theo code

**Lưu ý:**
- Một số board ESP32 không có LED tích hợp
- LED có thể ở GPIO2, GPIO5, hoặc GPIO25 tùy board

### 3. Code Test Đơn Giản

**Upload code test:**
1. **Mở file:** `E:\SmartFarm\test_esp32_running.ino`
2. **Upload lên ESP32**
3. **Mở Serial Monitor** (baud rate 115200)
4. **Kiểm tra:**
   - ✅ Thấy log "ESP32 ĐÃ CHẠY CODE THÀNH CÔNG!"
   - ✅ LED nhấp nháy mỗi giây
   - ✅ Log in ra mỗi giây với uptime tăng dần

## 🔍 Các Cách Kiểm Tra Chi Tiết

### Cách 1: Serial Monitor (Khuyến nghị)

**Bước 1: Upload code test**
```cpp
void setup() {
  Serial.begin(115200);
  Serial.println("ESP32 READY!");
}

void loop() {
  Serial.println("Hello from ESP32!");
  delay(1000);
}
```

**Bước 2: Mở Serial Monitor**
- Tools → Serial Monitor
- Baud rate: `115200`
- Phải thấy: "ESP32 READY!" và "Hello from ESP32!" lặp lại

### Cách 2: LED Tích Hợp

**Code test LED:**
```cpp
#define LED_BUILTIN 2

void setup() {
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  digitalWrite(LED_BUILTIN, HIGH);
  delay(500);
  digitalWrite(LED_BUILTIN, LOW);
  delay(500);
}
```

**Kiểm tra:**
- LED nhấp nháy mỗi 0.5 giây = ✅ Code đang chạy

### Cách 3: WiFi (Nếu code có WiFi)

**Kiểm tra:**
1. **Serial Monitor** hiển thị:
   - "📡 Đang kết nối WiFi..."
   - "✅ WiFi connected!"
   - "📡 IP: 192.168.x.x"

2. **Kiểm tra IP:**
   - Ping IP từ máy tính
   - Hoặc truy cập web server (nếu có)

### Cách 4: Sensor/Actuator (Nếu có)

**Kiểm tra:**
- Sensor đọc được giá trị
- Relay/LED ngoài hoạt động
- Serial Monitor hiển thị giá trị sensor

## ❌ Dấu Hiệu ESP32 KHÔNG Chạy Code

### 1. Serial Monitor Không Hiển Thị Gì

**Nguyên nhân:**
- Baud rate sai (phải là 115200)
- Code chưa upload thành công
- ESP32 bị treo/reset loop

**Giải pháp:**
- Kiểm tra baud rate Serial Monitor
- Upload lại code
- Reset ESP32 (nhấn nút RESET)

### 2. LED Không Nhấp Nháy

**Nguyên nhân:**
- Code không có điều khiển LED
- GPIO LED sai
- LED bị hỏng

**Giải pháp:**
- Upload code test LED
- Kiểm tra GPIO LED (thử GPIO2, GPIO5, GPIO25)

### 3. Serial Monitor Hiển Thị "????" hoặc Ký Tự Lạ

**Nguyên nhân:**
- Baud rate sai!

**Giải pháp:**
- Đổi baud rate Serial Monitor sang `115200`

### 4. Code Upload Thành Công Nhưng Không Chạy

**Nguyên nhân:**
- Code có lỗi runtime
- ESP32 bị reset liên tục
- Nguồn điện không ổn định

**Giải pháp:**
- Xem Serial Monitor có log lỗi không
- Kiểm tra nguồn điện
- Upload code test đơn giản

## 🚀 Quick Test

### Test Nhanh (30 giây)

1. **Upload code:**
   ```cpp
   void setup() {
     Serial.begin(115200);
     pinMode(2, OUTPUT);
   }
   void loop() {
     Serial.println("OK");
     digitalWrite(2, !digitalRead(2));
     delay(500);
   }
   ```

2. **Mở Serial Monitor** (115200)
3. **Kiểm tra:**
   - ✅ Thấy "OK" mỗi 0.5 giây
   - ✅ LED nhấp nháy

### Test Chi Tiết

1. **Upload:** `test_esp32_running.ino`
2. **Mở Serial Monitor** (115200)
3. **Kiểm tra:**
   - ✅ Thông tin chip
   - ✅ Uptime tăng dần
   - ✅ Loop count tăng dần
   - ✅ LED nhấp nháy

## 📋 Checklist

- [ ] Serial Monitor hiển thị log từ setup()
- [ ] Serial Monitor hiển thị log từ loop() (lặp lại)
- [ ] LED tích hợp nhấp nháy (nếu có)
- [ ] Uptime tăng dần trong Serial Monitor
- [ ] Free Heap > 0 (không bị out of memory)
- [ ] Không có lỗi trong Serial Monitor

## 💡 Lưu ý

- **Baud rate Serial Monitor PHẢI là 115200** (không phải 9600)
- **Đóng Serial Monitor trước khi upload** (tránh lỗi PermissionError)
- **Reset ESP32** nếu code không chạy (nhấn nút RESET)
- **Kiểm tra nguồn điện** nếu ESP32 reset liên tục

## 🎯 Kết Luận

**ESP32 đã chạy code nếu:**
1. ✅ Serial Monitor hiển thị log đúng
2. ✅ LED nhấp nháy (nếu code có điều khiển LED)
3. ✅ Uptime tăng dần
4. ✅ Không có lỗi

**Nếu không thấy các dấu hiệu trên:**
- Kiểm tra baud rate Serial Monitor
- Upload lại code
- Reset ESP32
- Kiểm tra nguồn điện


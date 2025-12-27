# 🔧 Hướng Dẫn Lắp Ráp ESP32 SmartFarm - Từng Bước

## 📋 Bước 1: Chuẩn Bị Phần Cứng

### Kiểm tra bạn có đủ:

- [ ] **ESP32 30 chân (Type-C)**
- [ ] **DHT11** - Cảm biến nhiệt độ, độ ẩm
- [ ] **Soil Moisture Sensor** - Cảm biến độ ẩm đất
- [ ] **LDR** - Cảm biến ánh sáng
- [ ] **Relay Module** (1 hoặc 2 kênh)
- [ ] **LED:** Xanh, Vàng, Đỏ (mỗi LED cần 1 điện trở 220Ω)
- [ ] **Điện trở 10kΩ** - Cho DHT11
- [ ] **Điện trở 220Ω x3** - Cho 3 LED
- [ ] **Breadboard** - Để lắp ráp
- [ ] **Dây nối** (jumper wires)
- [ ] **Máy bơm mini 5V** (tùy chọn - để demo tưới nước)
- [ ] **Đèn** (tùy chọn - để demo chiếu sáng)

---

## 🔌 Bước 2: Lắp Ráp Sensors (Cảm Biến)

### 2.1. Lắp DHT11 (Nhiệt độ, Độ ẩm không khí)

**Vị trí:** Bên trái breadboard

```
DHT11 có 3 chân (từ trái sang phải):
1. VCC (chân 1) - Nguồn dương
2. DATA (chân 2) - Tín hiệu
3. GND (chân 3) - Nguồn âm
```

**Kết nối:**
1. **DHT11 VCC** → **ESP32 3.3V**
2. **DHT11 GND** → **ESP32 GND**
3. **DHT11 DATA** → **ESP32 GPIO4**
4. **Điện trở 10kΩ:**
   - Một đầu → DHT11 DATA
   - Đầu kia → ESP32 3.3V (pull-up)

**Kiểm tra:**
- DHT11 có 3 chân rõ ràng
- Điện trở 10kΩ nối giữa DATA và 3.3V

---

### 2.2. Lắp Soil Moisture Sensor (Độ ẩm đất)

**Vị trí:** Bên phải breadboard

```
Soil Sensor có 3 dây:
- VCC (đỏ) - Nguồn dương
- GND (đen) - Nguồn âm  
- A0 (vàng/xanh) - Tín hiệu analog
```

**Kết nối:**
1. **Soil Sensor VCC (đỏ)** → **ESP32 3.3V**
2. **Soil Sensor GND (đen)** → **ESP32 GND**
3. **Soil Sensor A0 (vàng/xanh)** → **ESP32 GPIO32**

**Kiểm tra:**
- Dây đỏ = VCC
- Dây đen = GND
- Dây còn lại = A0

---

### 2.3. Lắp LDR (Cảm biến ánh sáng)

**Vị trí:** Gần Soil Sensor

**LDR không có cực dương/âm - có thể nối ngược lại**

**Kết nối (Phân áp):**
1. **Một đầu LDR** → **ESP32 3.3V**
2. **Đầu kia LDR** → **ESP32 GPIO33**
3. **Đầu kia LDR** → **Điện trở 10kΩ (một đầu)**
4. **Điện trở 10kΩ (đầu kia)** → **ESP32 GND**

**Giải thích:**
- LDR và điện trở 10kΩ tạo thành mạch phân áp
- GPIO33 đọc điện áp tại điểm giữa
- Khi sáng: LDR có điện trở thấp → GPIO33 đọc giá trị cao
- Khi tối: LDR có điện trở cao → GPIO33 đọc giá trị thấp

**Kiểm tra:**
- LDR nối giữa 3.3V và GPIO33
- Điện trở 10kΩ nối giữa GPIO33 và GND

---

## 💡 Bước 3: Lắp Ráp LED (Báo Trạng Thái)

### 3.1. LED Xanh (GPIO26)

**Kết nối:**
1. **ESP32 GPIO26** → **Điện trở 220Ω (một đầu)**
2. **Điện trở 220Ω (đầu kia)** → **LED Xanh (chân dài - cực dương)**
3. **LED Xanh (chân ngắn - cực âm)** → **ESP32 GND**

**Lưu ý:**
- LED có 2 chân: chân dài = cực dương (+), chân ngắn = cực âm (-)
- Phải có điện trở 220Ω để giới hạn dòng điện

---

### 3.2. LED Vàng (GPIO27)

**Kết nối:**
1. **ESP32 GPIO27** → **Điện trở 220Ω (một đầu)**
2. **Điện trở 220Ω (đầu kia)** → **LED Vàng (chân dài - cực dương)**
3. **LED Vàng (chân ngắn - cực âm)** → **ESP32 GND**

---

### 3.3. LED Đỏ (GPIO14)

**Kết nối:**
1. **ESP32 GPIO14** → **Điện trở 220Ω (một đầu)**
2. **Điện trở 220Ω (đầu kia)** → **LED Đỏ (chân dài - cực dương)**
3. **LED Đỏ (chân ngắn - cực âm)** → **ESP32 GND**

---

## 🔌 Bước 4: Lắp Ráp Relay (Điều Khiển)

### 4.1. Relay Module (Máy bơm - GPIO25)

**Relay Module thường có:**
- VCC, GND - Nguồn
- IN (hoặc Signal) - Tín hiệu điều khiển
- NO, COM, NC - Công tắc

**Kết nối:**
1. **Relay VCC** → **ESP32 5V** (hoặc nguồn 5V riêng)
2. **Relay GND** → **ESP32 GND**
3. **Relay IN (Signal)** → **ESP32 GPIO25**

**Kết nối Máy bơm (nếu có):**
1. **Nguồn 5V riêng** → **Relay COM**
2. **Relay NO** → **Máy bơm + (dương)**
3. **Máy bơm - (âm)** → **GND**

**Lưu ý:**
- Máy bơm cần nguồn 5V riêng (không dùng 5V từ ESP32)
- Khi GPIO25 = HIGH → Relay ON → Máy bơm chạy
- Khi GPIO25 = LOW → Relay OFF → Máy bơm tắt

---

### 4.2. Relay Module (Đèn - GPIO19) - Tùy chọn

**Kết nối:**
1. **Relay VCC** → **ESP32 5V**
2. **Relay GND** → **ESP32 GND**
3. **Relay IN (Signal)** → **ESP32 GPIO19**

**Kết nối Đèn (nếu có):**
- **Đèn 12V DC:**
  - Nguồn 12V → Relay COM
  - Relay NO → Đèn +
  - Đèn - → GND

- **Đèn 220V AC (CẨN THẬN!):**
  - Dây lửa 220V → Relay COM
  - Relay NO → Đèn +
  - Đèn - → Dây trung tính

**⚠️ CẢNH BÁO:**
- Đèn 220V AC rất nguy hiểm!
- Chỉ lắp nếu bạn có kinh nghiệm
- Đảm bảo cách ly điện đúng cách
- Nếu không chắc, dùng đèn 12V DC

---

## ✅ Bước 5: Kiểm Tra Kết Nối

### Checklist Kiểm Tra:

**Sensors:**
- [ ] DHT11 VCC → 3.3V
- [ ] DHT11 GND → GND
- [ ] DHT11 DATA → GPIO4
- [ ] Điện trở 10kΩ giữa DATA và 3.3V
- [ ] Soil Sensor VCC → 3.3V
- [ ] Soil Sensor GND → GND
- [ ] Soil Sensor A0 → GPIO32
- [ ] LDR nối giữa 3.3V và GPIO33
- [ ] Điện trở 10kΩ giữa GPIO33 và GND

**LED:**
- [ ] LED Xanh: GPIO26 → 220Ω → LED → GND
- [ ] LED Vàng: GPIO27 → 220Ω → LED → GND
- [ ] LED Đỏ: GPIO14 → 220Ω → LED → GND

**Relay:**
- [ ] Relay VCC → 5V
- [ ] Relay GND → GND
- [ ] Relay IN → GPIO25 (máy bơm)
- [ ] Relay IN → GPIO19 (đèn - nếu có)

---

## 🎯 Bước 6: Sơ Đồ Tổng Quan

```
ESP32 Board
│
├── 3.3V ──┬── DHT11 VCC
│         ├── Soil Sensor VCC
│         └── LDR (một đầu)
│
├── 5V ────┬── Relay VCC (máy bơm)
│          └── Relay VCC (đèn)
│
├── GND ───┬── DHT11 GND
│          ├── Soil Sensor GND
│          ├── LDR (qua điện trở 10kΩ)
│          ├── LED Xanh (-)
│          ├── LED Vàng (-)
│          ├── LED Đỏ (-)
│          └── Relay GND
│
├── GPIO4 ──── DHT11 DATA (qua 10kΩ lên 3.3V)
├── GPIO32 ─── Soil Sensor A0
├── GPIO33 ─── LDR (điểm giữa phân áp)
├── GPIO25 ─── Relay IN (máy bơm)
├── GPIO19 ─── Relay IN (đèn)
├── GPIO26 ─── LED Xanh (+) (qua 220Ω)
├── GPIO27 ─── LED Vàng (+) (qua 220Ω)
└── GPIO14 ─── LED Đỏ (+) (qua 220Ω)
```

---

## 🚀 Bước 7: Upload Code và Test

### 7.1. Upload Code

1. **Mở Arduino IDE**
2. **Mở file:** `E:\SmartFarm\Arduino_SmartFarm_Demo.ino`
3. **Kiểm tra WiFi:** Đã sửa thành "Wifi miễn phí"
4. **Upload code** lên ESP32

### 7.2. Test Từng Phần

**Test LED:**
- Upload code `test_led_simple.ino`
- LED sẽ nhấp nháy theo thứ tự
- Nếu LED không sáng → Kiểm tra kết nối và cực LED

**Test WiFi:**
- Upload code `test_wifi_simple.ino`
- Serial Monitor phải thấy "✅ WiFi connected!"
- Nếu không → Kiểm tra WiFi và SSID

**Test Sensors:**
- Upload code `Arduino_SmartFarm_Demo.ino`
- Serial Monitor sẽ hiển thị giá trị sensors
- Nếu không có giá trị → Kiểm tra kết nối sensor

---

## 📊 Bước 8: Hiệu Chuẩn Sensors

### 8.1. Hiệu Chuẩn Soil Sensor

1. **Đặt sensor vào đất khô hoàn toàn**
2. **Xem Serial Monitor:** Ghi lại giá trị `soilRaw`
3. **Cập nhật trong code:**
   ```cpp
   int SOIL_RAW_DRY = 4095;  // Thay bằng giá trị thực tế
   ```

4. **Đặt sensor vào nước (hoặc đất ướt)**
5. **Xem Serial Monitor:** Ghi lại giá trị `soilRaw`
6. **Cập nhật trong code:**
   ```cpp
   int SOIL_RAW_WET = 2000;  // Thay bằng giá trị thực tế
   ```

### 8.2. Hiệu Chuẩn LDR

1. **Che sensor (tối hoàn toàn)**
2. **Xem Serial Monitor:** Ghi lại giá trị `lightRaw`
3. **Cập nhật:**
   ```cpp
   int LDR_RAW_DARK = 100;  // Thay bằng giá trị thực tế
   ```

4. **Đưa sensor ra ánh sáng (sáng hoàn toàn)**
5. **Xem Serial Monitor:** Ghi lại giá trị `lightRaw`
6. **Cập nhật:**
   ```cpp
   int LDR_RAW_BRIGHT = 3500;  // Thay bằng giá trị thực tế
   ```

---

## ⚠️ Lưu Ý An Toàn

1. **Tắt nguồn** khi lắp ráp/chỉnh sửa
2. **Kiểm tra kỹ** trước khi bật nguồn
3. **Đèn 220V AC:** Rất nguy hiểm - chỉ lắp nếu có kinh nghiệm
4. **Máy bơm:** Dùng nguồn riêng, không dùng 5V từ ESP32
5. **Nước:** Tránh nước vào board ESP32

---

## 🎯 Thứ Tự Lắp Ráp Khuyến Nghị

### Bước 1: Lắp Sensors Trước
1. DHT11
2. Soil Sensor
3. LDR

### Bước 2: Test Sensors
- Upload code test
- Kiểm tra Serial Monitor có giá trị không

### Bước 3: Lắp LED
1. LED Xanh
2. LED Vàng
3. LED Đỏ

### Bước 4: Test LED
- Upload code test LED
- Kiểm tra LED có sáng không

### Bước 5: Lắp Relay (Nếu có)
1. Relay máy bơm
2. Relay đèn (nếu có)

### Bước 6: Test Toàn Bộ
- Upload code chính
- Kiểm tra tất cả hoạt động

---

## 📸 Hình Ảnh Tham Khảo

**Bố cục Breadboard:**

```
[ESP32]     [Breadboard]
            │
            ├── DHT11 (trái)
            ├── Soil Sensor (giữa)
            ├── LDR (phải)
            ├── LED Xanh/Vàng/Đỏ (dưới)
            └── Relay (ngoài breadboard)
```

---

## ✅ Checklist Hoàn Thành

- [ ] Đã lắp DHT11
- [ ] Đã lắp Soil Sensor
- [ ] Đã lắp LDR
- [ ] Đã lắp 3 LED (Xanh/Vàng/Đỏ)
- [ ] Đã lắp Relay (nếu có)
- [ ] Đã test từng phần
- [ ] Đã hiệu chuẩn sensors
- [ ] Đã upload code chính
- [ ] Serial Monitor hiển thị dữ liệu
- [ ] LED hoạt động đúng
- [ ] WiFi kết nối thành công

---

## 🆘 Nếu Gặp Vấn Đề

### LED không sáng:
- Kiểm tra cực LED (chân dài = +, chân ngắn = -)
- Kiểm tra điện trở 220Ω
- Test LED trực tiếp: Nối LED qua 220Ω vào 3.3V và GND

### Sensor không đọc được:
- Kiểm tra nguồn 3.3V
- Kiểm tra GND
- Kiểm tra dây tín hiệu (GPIO4, GPIO32, GPIO33)

### Relay không hoạt động:
- Kiểm tra nguồn 5V cho relay
- Kiểm tra dây tín hiệu (GPIO25, GPIO19)
- Kiểm tra relay có đèn báo không

---

## 🎉 Sau Khi Lắp Xong

1. **Upload code chính:** `Arduino_SmartFarm_Demo.ino`
2. **Mở Serial Monitor** (115200)
3. **Kiểm tra:**
   - WiFi connected
   - Sensors đọc được giá trị
   - LED hoạt động
   - Dữ liệu gửi lên server

**Chúc bạn lắp ráp thành công!** 🚀

# 🔧 Hướng Dẫn Lắp Ráp ESP32 SmartFarm - Từng Bước

## 📋 Bước 1: Chuẩn Bị Phần Cứng

### Kiểm tra bạn có đủ:

- [ ] **ESP32 30 chân (Type-C)**
- [ ] **DHT11** - Cảm biến nhiệt độ, độ ẩm
- [ ] **Soil Moisture Sensor** - Cảm biến độ ẩm đất
- [ ] **LDR** - Cảm biến ánh sáng
- [ ] **Relay Module** (1 hoặc 2 kênh)
- [ ] **LED:** Xanh, Vàng, Đỏ (mỗi LED cần 1 điện trở 220Ω)
- [ ] **Điện trở 10kΩ** - Cho DHT11
- [ ] **Điện trở 220Ω x3** - Cho 3 LED
- [ ] **Breadboard** - Để lắp ráp
- [ ] **Dây nối** (jumper wires)
- [ ] **Máy bơm mini 5V** (tùy chọn - để demo tưới nước)
- [ ] **Đèn** (tùy chọn - để demo chiếu sáng)

---

## 🔌 Bước 2: Lắp Ráp Sensors (Cảm Biến)

### 2.1. Lắp DHT11 (Nhiệt độ, Độ ẩm không khí)

**Vị trí:** Bên trái breadboard

```
DHT11 có 3 chân (từ trái sang phải):
1. VCC (chân 1) - Nguồn dương
2. DATA (chân 2) - Tín hiệu
3. GND (chân 3) - Nguồn âm
```

**Kết nối:**
1. **DHT11 VCC** → **ESP32 3.3V**
2. **DHT11 GND** → **ESP32 GND**
3. **DHT11 DATA** → **ESP32 GPIO4**
4. **Điện trở 10kΩ:**
   - Một đầu → DHT11 DATA
   - Đầu kia → ESP32 3.3V (pull-up)

**Kiểm tra:**
- DHT11 có 3 chân rõ ràng
- Điện trở 10kΩ nối giữa DATA và 3.3V

---

### 2.2. Lắp Soil Moisture Sensor (Độ ẩm đất)

**Vị trí:** Bên phải breadboard

```
Soil Sensor có 3 dây:
- VCC (đỏ) - Nguồn dương
- GND (đen) - Nguồn âm  
- A0 (vàng/xanh) - Tín hiệu analog
```

**Kết nối:**
1. **Soil Sensor VCC (đỏ)** → **ESP32 3.3V**
2. **Soil Sensor GND (đen)** → **ESP32 GND**
3. **Soil Sensor A0 (vàng/xanh)** → **ESP32 GPIO32**

**Kiểm tra:**
- Dây đỏ = VCC
- Dây đen = GND
- Dây còn lại = A0

---

### 2.3. Lắp LDR (Cảm biến ánh sáng)

**Vị trí:** Gần Soil Sensor

**LDR không có cực dương/âm - có thể nối ngược lại**

**Kết nối (Phân áp):**
1. **Một đầu LDR** → **ESP32 3.3V**
2. **Đầu kia LDR** → **ESP32 GPIO33**
3. **Đầu kia LDR** → **Điện trở 10kΩ (một đầu)**
4. **Điện trở 10kΩ (đầu kia)** → **ESP32 GND**

**Giải thích:**
- LDR và điện trở 10kΩ tạo thành mạch phân áp
- GPIO33 đọc điện áp tại điểm giữa
- Khi sáng: LDR có điện trở thấp → GPIO33 đọc giá trị cao
- Khi tối: LDR có điện trở cao → GPIO33 đọc giá trị thấp

**Kiểm tra:**
- LDR nối giữa 3.3V và GPIO33
- Điện trở 10kΩ nối giữa GPIO33 và GND

---

## 💡 Bước 3: Lắp Ráp LED (Báo Trạng Thái)

### 3.1. LED Xanh (GPIO26)

**Kết nối:**
1. **ESP32 GPIO26** → **Điện trở 220Ω (một đầu)**
2. **Điện trở 220Ω (đầu kia)** → **LED Xanh (chân dài - cực dương)**
3. **LED Xanh (chân ngắn - cực âm)** → **ESP32 GND**

**Lưu ý:**
- LED có 2 chân: chân dài = cực dương (+), chân ngắn = cực âm (-)
- Phải có điện trở 220Ω để giới hạn dòng điện

---

### 3.2. LED Vàng (GPIO27)

**Kết nối:**
1. **ESP32 GPIO27** → **Điện trở 220Ω (một đầu)**
2. **Điện trở 220Ω (đầu kia)** → **LED Vàng (chân dài - cực dương)**
3. **LED Vàng (chân ngắn - cực âm)** → **ESP32 GND**

---

### 3.3. LED Đỏ (GPIO14)

**Kết nối:**
1. **ESP32 GPIO14** → **Điện trở 220Ω (một đầu)**
2. **Điện trở 220Ω (đầu kia)** → **LED Đỏ (chân dài - cực dương)**
3. **LED Đỏ (chân ngắn - cực âm)** → **ESP32 GND**

---

## 🔌 Bước 4: Lắp Ráp Relay (Điều Khiển)

### 4.1. Relay Module (Máy bơm - GPIO25)

**Relay Module thường có:**
- VCC, GND - Nguồn
- IN (hoặc Signal) - Tín hiệu điều khiển
- NO, COM, NC - Công tắc

**Kết nối:**
1. **Relay VCC** → **ESP32 5V** (hoặc nguồn 5V riêng)
2. **Relay GND** → **ESP32 GND**
3. **Relay IN (Signal)** → **ESP32 GPIO25**

**Kết nối Máy bơm (nếu có):**
1. **Nguồn 5V riêng** → **Relay COM**
2. **Relay NO** → **Máy bơm + (dương)**
3. **Máy bơm - (âm)** → **GND**

**Lưu ý:**
- Máy bơm cần nguồn 5V riêng (không dùng 5V từ ESP32)
- Khi GPIO25 = HIGH → Relay ON → Máy bơm chạy
- Khi GPIO25 = LOW → Relay OFF → Máy bơm tắt

---

### 4.2. Relay Module (Đèn - GPIO19) - Tùy chọn

**Kết nối:**
1. **Relay VCC** → **ESP32 5V**
2. **Relay GND** → **ESP32 GND**
3. **Relay IN (Signal)** → **ESP32 GPIO19**

**Kết nối Đèn (nếu có):**
- **Đèn 12V DC:**
  - Nguồn 12V → Relay COM
  - Relay NO → Đèn +
  - Đèn - → GND

- **Đèn 220V AC (CẨN THẬN!):**
  - Dây lửa 220V → Relay COM
  - Relay NO → Đèn +
  - Đèn - → Dây trung tính

**⚠️ CẢNH BÁO:**
- Đèn 220V AC rất nguy hiểm!
- Chỉ lắp nếu bạn có kinh nghiệm
- Đảm bảo cách ly điện đúng cách
- Nếu không chắc, dùng đèn 12V DC

---

## ✅ Bước 5: Kiểm Tra Kết Nối

### Checklist Kiểm Tra:

**Sensors:**
- [ ] DHT11 VCC → 3.3V
- [ ] DHT11 GND → GND
- [ ] DHT11 DATA → GPIO4
- [ ] Điện trở 10kΩ giữa DATA và 3.3V
- [ ] Soil Sensor VCC → 3.3V
- [ ] Soil Sensor GND → GND
- [ ] Soil Sensor A0 → GPIO32
- [ ] LDR nối giữa 3.3V và GPIO33
- [ ] Điện trở 10kΩ giữa GPIO33 và GND

**LED:**
- [ ] LED Xanh: GPIO26 → 220Ω → LED → GND
- [ ] LED Vàng: GPIO27 → 220Ω → LED → GND
- [ ] LED Đỏ: GPIO14 → 220Ω → LED → GND

**Relay:**
- [ ] Relay VCC → 5V
- [ ] Relay GND → GND
- [ ] Relay IN → GPIO25 (máy bơm)
- [ ] Relay IN → GPIO19 (đèn - nếu có)

---

## 🎯 Bước 6: Sơ Đồ Tổng Quan

```
ESP32 Board
│
├── 3.3V ──┬── DHT11 VCC
│         ├── Soil Sensor VCC
│         └── LDR (một đầu)
│
├── 5V ────┬── Relay VCC (máy bơm)
│          └── Relay VCC (đèn)
│
├── GND ───┬── DHT11 GND
│          ├── Soil Sensor GND
│          ├── LDR (qua điện trở 10kΩ)
│          ├── LED Xanh (-)
│          ├── LED Vàng (-)
│          ├── LED Đỏ (-)
│          └── Relay GND
│
├── GPIO4 ──── DHT11 DATA (qua 10kΩ lên 3.3V)
├── GPIO32 ─── Soil Sensor A0
├── GPIO33 ─── LDR (điểm giữa phân áp)
├── GPIO25 ─── Relay IN (máy bơm)
├── GPIO19 ─── Relay IN (đèn)
├── GPIO26 ─── LED Xanh (+) (qua 220Ω)
├── GPIO27 ─── LED Vàng (+) (qua 220Ω)
└── GPIO14 ─── LED Đỏ (+) (qua 220Ω)
```

---

## 🚀 Bước 7: Upload Code và Test

### 7.1. Upload Code

1. **Mở Arduino IDE**
2. **Mở file:** `E:\SmartFarm\Arduino_SmartFarm_Demo.ino`
3. **Kiểm tra WiFi:** Đã sửa thành "Wifi miễn phí"
4. **Upload code** lên ESP32

### 7.2. Test Từng Phần

**Test LED:**
- Upload code `test_led_simple.ino`
- LED sẽ nhấp nháy theo thứ tự
- Nếu LED không sáng → Kiểm tra kết nối và cực LED

**Test WiFi:**
- Upload code `test_wifi_simple.ino`
- Serial Monitor phải thấy "✅ WiFi connected!"
- Nếu không → Kiểm tra WiFi và SSID

**Test Sensors:**
- Upload code `Arduino_SmartFarm_Demo.ino`
- Serial Monitor sẽ hiển thị giá trị sensors
- Nếu không có giá trị → Kiểm tra kết nối sensor

---

## 📊 Bước 8: Hiệu Chuẩn Sensors

### 8.1. Hiệu Chuẩn Soil Sensor

1. **Đặt sensor vào đất khô hoàn toàn**
2. **Xem Serial Monitor:** Ghi lại giá trị `soilRaw`
3. **Cập nhật trong code:**
   ```cpp
   int SOIL_RAW_DRY = 4095;  // Thay bằng giá trị thực tế
   ```

4. **Đặt sensor vào nước (hoặc đất ướt)**
5. **Xem Serial Monitor:** Ghi lại giá trị `soilRaw`
6. **Cập nhật trong code:**
   ```cpp
   int SOIL_RAW_WET = 2000;  // Thay bằng giá trị thực tế
   ```

### 8.2. Hiệu Chuẩn LDR

1. **Che sensor (tối hoàn toàn)**
2. **Xem Serial Monitor:** Ghi lại giá trị `lightRaw`
3. **Cập nhật:**
   ```cpp
   int LDR_RAW_DARK = 100;  // Thay bằng giá trị thực tế
   ```

4. **Đưa sensor ra ánh sáng (sáng hoàn toàn)**
5. **Xem Serial Monitor:** Ghi lại giá trị `lightRaw`
6. **Cập nhật:**
   ```cpp
   int LDR_RAW_BRIGHT = 3500;  // Thay bằng giá trị thực tế
   ```

---

## ⚠️ Lưu Ý An Toàn

1. **Tắt nguồn** khi lắp ráp/chỉnh sửa
2. **Kiểm tra kỹ** trước khi bật nguồn
3. **Đèn 220V AC:** Rất nguy hiểm - chỉ lắp nếu có kinh nghiệm
4. **Máy bơm:** Dùng nguồn riêng, không dùng 5V từ ESP32
5. **Nước:** Tránh nước vào board ESP32

---

## 🎯 Thứ Tự Lắp Ráp Khuyến Nghị

### Bước 1: Lắp Sensors Trước
1. DHT11
2. Soil Sensor
3. LDR

### Bước 2: Test Sensors
- Upload code test
- Kiểm tra Serial Monitor có giá trị không

### Bước 3: Lắp LED
1. LED Xanh
2. LED Vàng
3. LED Đỏ

### Bước 4: Test LED
- Upload code test LED
- Kiểm tra LED có sáng không

### Bước 5: Lắp Relay (Nếu có)
1. Relay máy bơm
2. Relay đèn (nếu có)

### Bước 6: Test Toàn Bộ
- Upload code chính
- Kiểm tra tất cả hoạt động

---

## 📸 Hình Ảnh Tham Khảo

**Bố cục Breadboard:**

```
[ESP32]     [Breadboard]
            │
            ├── DHT11 (trái)
            ├── Soil Sensor (giữa)
            ├── LDR (phải)
            ├── LED Xanh/Vàng/Đỏ (dưới)
            └── Relay (ngoài breadboard)
```

---

## ✅ Checklist Hoàn Thành

- [ ] Đã lắp DHT11
- [ ] Đã lắp Soil Sensor
- [ ] Đã lắp LDR
- [ ] Đã lắp 3 LED (Xanh/Vàng/Đỏ)
- [ ] Đã lắp Relay (nếu có)
- [ ] Đã test từng phần
- [ ] Đã hiệu chuẩn sensors
- [ ] Đã upload code chính
- [ ] Serial Monitor hiển thị dữ liệu
- [ ] LED hoạt động đúng
- [ ] WiFi kết nối thành công

---

## 🆘 Nếu Gặp Vấn Đề

### LED không sáng:
- Kiểm tra cực LED (chân dài = +, chân ngắn = -)
- Kiểm tra điện trở 220Ω
- Test LED trực tiếp: Nối LED qua 220Ω vào 3.3V và GND

### Sensor không đọc được:
- Kiểm tra nguồn 3.3V
- Kiểm tra GND
- Kiểm tra dây tín hiệu (GPIO4, GPIO32, GPIO33)

### Relay không hoạt động:
- Kiểm tra nguồn 5V cho relay
- Kiểm tra dây tín hiệu (GPIO25, GPIO19)
- Kiểm tra relay có đèn báo không

---

## 🎉 Sau Khi Lắp Xong

1. **Upload code chính:** `Arduino_SmartFarm_Demo.ino`
2. **Mở Serial Monitor** (115200)
3. **Kiểm tra:**
   - WiFi connected
   - Sensors đọc được giá trị
   - LED hoạt động
   - Dữ liệu gửi lên server

**Chúc bạn lắp ráp thành công!** 🚀


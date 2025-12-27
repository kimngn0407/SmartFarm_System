# 🔌 Hướng Dẫn Nối LED và Relay

## 📋 Tổng Quan

Để bật LED hoặc Relay từ ESP32, bạn cần nối **chân GPIO (data)** vào LED hoặc Relay Module.

---

## 💡 Cách Nối LED

### Nguyên Lý:
- **GPIO** cung cấp tín hiệu HIGH (3.3V) hoặc LOW (0V)
- Khi GPIO = **HIGH** → LED sáng
- Khi GPIO = **LOW** → LED tắt

### Cách Nối:

#### LED Thường (Cần điện trở):
```
ESP32 D21 (GPIO21) ────> [220Ω] ────> LED Xanh (+) (chân dài)
LED Xanh (-) (chân ngắn) ────> GND
```

**Chi tiết:**
1. **ESP32 D21 (GPIO21)** → **Điện trở 220Ω (một đầu)**
2. **Điện trở 220Ω (đầu kia)** → **LED Xanh (chân dài - cực dương)**
3. **LED Xanh (chân ngắn - cực âm)** → **ESP32 GND**

#### LED Module (Có sẵn điện trở):
```
ESP32 D21 (GPIO21) ────> LED Module IN (hoặc Signal)
LED Module VCC ────> 3.3V (hoặc 5V)
LED Module GND ────> GND
```

**Chi tiết:**
1. **ESP32 D21 (GPIO21)** → **LED Module IN/Signal**
2. **LED Module VCC** → **ESP32 3.3V** (hoặc 5V)
3. **LED Module GND** → **ESP32 GND**

---

## 🔌 Cách Nối Relay Module

### Nguyên Lý:
- **GPIO** cung cấp tín hiệu HIGH (3.3V) hoặc LOW (0V)
- Khi GPIO = **HIGH** → Relay ON → Thiết bị (máy bơm/đèn) bật
- Khi GPIO = **LOW** → Relay OFF → Thiết bị tắt

### Cách Nối Relay Module:

#### 1. Nối Relay Module với ESP32:
```
ESP32 D18 (GPIO18) ────> Relay Module IN (hoặc Signal)
Relay Module VCC ────> ESP32 5V (hoặc nguồn 5V riêng)
Relay Module GND ────> ESP32 GND
```

**Chi tiết:**
1. **ESP32 D18 (GPIO18)** → **Relay Module IN/Signal** (chân data)
2. **Relay Module VCC** → **ESP32 5V** (hoặc nguồn 5V riêng)
3. **Relay Module GND** → **ESP32 GND**

#### 2. Nối Máy Bơm với Relay:
```
Nguồn 5V riêng ────> Relay COM
Relay NO (Normally Open) ────> Máy bơm + (dương)
Máy bơm - (âm) ────> GND
```

**Chi tiết:**
1. **Nguồn 5V riêng** → **Relay COM**
2. **Relay NO** → **Máy bơm + (dương)**
3. **Máy bơm - (âm)** → **GND**

**Lưu ý:**
- Máy bơm cần nguồn 5V riêng (không dùng 5V từ ESP32 vì dòng lớn)
- Khi GPIO18 = HIGH → Relay ON → COM nối với NO → Máy bơm chạy
- Khi GPIO18 = LOW → Relay OFF → COM không nối với NO → Máy bơm tắt

---

## 📊 Sơ Đồ Tổng Quan

### LED:
```
ESP32 GPIO ────> [Điện trở] ────> LED (+) ────> LED (-) ────> GND
     ↑
  Tín hiệu HIGH/LOW
```

### Relay:
```
ESP32 GPIO ────> Relay IN ────> Relay Module
     ↑                    │
  Tín hiệu HIGH/LOW       ├── VCC → 5V
                          └── GND → GND
                          
Relay Module:
  COM ────> Nguồn thiết bị
  NO ────> Thiết bị + (khi Relay ON)
  NC ────> Thiết bị + (khi Relay OFF) - Không dùng
```

---

## ✅ Checklist Kết Nối

### LED:
- [ ] ESP32 D21 (GPIO21) → LED Xanh (qua điện trở nếu cần)
- [ ] LED Xanh (-) → GND
- [ ] ESP32 D22 (GPIO22) → LED Vàng (qua điện trở nếu cần)
- [ ] LED Vàng (-) → GND
- [ ] ESP32 D23 (GPIO23) → LED Đỏ (qua điện trở nếu cần)
- [ ] LED Đỏ (-) → GND

### Relay Máy Bơm:
- [ ] ESP32 D18 (GPIO18) → Relay Module IN/Signal
- [ ] Relay Module VCC → ESP32 5V (hoặc nguồn 5V riêng)
- [ ] Relay Module GND → ESP32 GND
- [ ] Nguồn 5V riêng → Relay COM
- [ ] Relay NO → Máy bơm +
- [ ] Máy bơm - → GND

---

## 🎯 Code Điều Khiển

### Bật LED:
```cpp
digitalWrite(LED_GREEN, HIGH);  // Bật LED Xanh
digitalWrite(LED_GREEN, LOW);   // Tắt LED Xanh
```

### Bật Relay (Máy bơm):
```cpp
digitalWrite(RELAY_PUMP, HIGH);  // Bật Relay → Máy bơm chạy
digitalWrite(RELAY_PUMP, LOW);    // Tắt Relay → Máy bơm tắt
```

---

## ⚠️ Lưu Ý Quan Trọng

### LED:
- **Phải có điện trở** (220Ω) nếu dùng LED thường
- **LED có cực dương (+)** và **cực âm (-)**
  - Chân dài = cực dương (+)
  - Chân ngắn = cực âm (-)
- **Nếu dùng LED Module** có sẵn điện trở → Không cần điện trở ngoài

### Relay:
- **Relay Module cần nguồn 5V** (có thể dùng từ ESP32 hoặc nguồn riêng)
- **Thiết bị (máy bơm/đèn) cần nguồn riêng** (không dùng từ ESP32)
- **Chân IN/Signal** của Relay nhận tín hiệu từ GPIO
- **COM và NO** dùng để điều khiển thiết bị

---

## 🔍 Kiểm Tra Kết Nối

### Test LED:
1. Upload code test đơn giản:
```cpp
void setup() {
  pinMode(21, OUTPUT);
  digitalWrite(21, HIGH);  // Bật LED Xanh
}
void loop() {}
```
2. Nếu LED sáng → Kết nối đúng ✅
3. Nếu LED không sáng → Kiểm tra lại:
   - GPIO có đúng không?
   - LED có nối đúng cực không?
   - Có điện trở không?

### Test Relay:
1. Upload code test đơn giản:
```cpp
void setup() {
  pinMode(18, OUTPUT);
  digitalWrite(18, HIGH);  // Bật Relay
  delay(2000);
  digitalWrite(18, LOW);   // Tắt Relay
}
void loop() {}
```
2. Nghe tiếng "click" từ Relay → Kết nối đúng ✅
3. Nếu không có tiếng "click" → Kiểm tra lại:
   - GPIO có đúng không?
   - Relay có nguồn 5V chưa?
   - Relay GND có nối chưa?

---

## 📝 Tóm Tắt

**Để bật LED hoặc Relay:**
1. ✅ Nối **GPIO (chân data)** vào LED hoặc Relay IN/Signal
2. ✅ Cung cấp **nguồn** cho LED hoặc Relay Module (VCC/GND)
3. ✅ Code: `digitalWrite(GPIO, HIGH)` để bật, `LOW` để tắt

**Chân GPIO trong code hiện tại:**
- LED Xanh: D21 (GPIO21)
- LED Vàng: D22 (GPIO22)
- LED Đỏ: D23 (GPIO23)
- Relay Máy Bơm: D18 (GPIO18)

---

**Chúc bạn nối thành công!** 🔌✨

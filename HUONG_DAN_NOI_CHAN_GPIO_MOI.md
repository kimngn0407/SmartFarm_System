# 🔌 Hướng Dẫn Nối Chân Với GPIO Mới

## 📋 Phân Bổ GPIO Mới

Bạn đã đổi sang các GPIO sau:

### Sensors (Cảm Biến):
- **DHT11 OUT** → **D4 (GPIO4)**
- **Soil Sensor A0** → **D2 (GPIO2)** - ADC2_CH1
- **LDR Module D0** → **D5 (GPIO5)**

### Actuators (Điều Khiển):
- **Relay Máy Bơm** → **D18 (GPIO18)**
- **Relay Đèn** → **D19 (GPIO19)**

### LED (Báo Trạng Thái):
- **LED Xanh** → **D21 (GPIO21)**
- **LED Vàng** → **D22 (GPIO22)**
- **LED Đỏ** → **D23 (GPIO23)**

---

## 🔌 Cách Nối Chi Tiết

### 1. DHT11
```
DHT11 VCC ────> Power Rail (+) (3.3V)
DHT11 GND ────> Power Rail (-)
DHT11 OUT ────> ESP32 D4 (GPIO4)
Điện trở 10kΩ: DHT11 OUT ──> 3.3V (pull-up)
```

### 2. Soil Moisture Sensor
```
Soil VCC (đỏ) ────> Power Rail (+) (3.3V)
Soil GND (đen) ────> Power Rail (-)
Soil A0 (vàng/xanh) ────> ESP32 D2 (GPIO2)
Soil D0 ────> Không cần nối
```

### 3. LDR Module
```
LDR VCC ────> Power Rail (+) (3.3V)
LDR GND ────> Power Rail (-)
LDR D0 (OUT) ────> ESP32 D5 (GPIO5)
```

### 4. Relay Máy Bơm
```
Relay VCC ────> ESP32 5V (hoặc nguồn 5V riêng)
Relay GND ────> ESP32 GND
Relay IN (Signal) ────> ESP32 D18 (GPIO18)
```

### 5. Relay Đèn
```
Relay VCC ────> ESP32 5V
Relay GND ────> ESP32 GND
Relay IN (Signal) ────> ESP32 D19 (GPIO19)
```

### 6. LED Xanh
```
ESP32 D21 (GPIO21) ────> LED Xanh (+) (chân dài)
LED Xanh (-) (chân ngắn) ────> GND
```

### 7. LED Vàng
```
ESP32 D22 (GPIO22) ────> LED Vàng (+) (chân dài)
LED Vàng (-) (chân ngắn) ────> GND
```

### 8. LED Đỏ
```
ESP32 D23 (GPIO23) ────> LED Đỏ (+) (chân dài)
LED Đỏ (-) (chân ngắn) ────> GND
```

---

## 📊 Sơ Đồ Tổng Quan

```
ESP32 30 Chân
│
├── 3.3V ────> Power Rail (+) ────> Sensors VCC
├── GND ─────> Power Rail (-) ────> Sensors GND
│
├── D4 (GPIO4) ────> DHT11 OUT ──┬── 10kΩ ──> 3.3V
│
├── D2 (GPIO2) ────> Soil Sensor A0 (analog)
│
├── D5 (GPIO5) ────> LDR Module D0 (digital)
│
├── D18 (GPIO18) ────> Relay Pump IN
├── D19 (GPIO19) ────> Relay Light IN
│
├── D21 (GPIO21) ────> LED Xanh (+)
├── D22 (GPIO22) ────> LED Vàng (+)
└── D23 (GPIO23) ────> LED Đỏ (+)
```

---

## ✅ Checklist Kết Nối

### Sensors:
- [ ] DHT11 OUT → ESP32 D4 (GPIO4)
- [ ] Điện trở 10kΩ: DHT11 OUT → 3.3V
- [ ] Soil Sensor A0 → ESP32 D2 (GPIO2)
- [ ] LDR Module D0 → ESP32 D5 (GPIO5)

### Actuators:
- [ ] Relay Pump IN → ESP32 D18 (GPIO18)
- [ ] Relay Light IN → ESP32 D19 (GPIO19)

### LED:
- [ ] LED Xanh → ESP32 D21 (GPIO21)
- [ ] LED Vàng → ESP32 D22 (GPIO22)
- [ ] LED Đỏ → ESP32 D23 (GPIO23)

---

## ⚠️ Lưu Ý Quan Trọng

### GPIO2 cho Soil Sensor:
- GPIO2 có **ADC2_CH1** (analog input)
- Có thể bị ảnh hưởng khi WiFi hoạt động (ADC2 bị conflict với WiFi)
- **Giải pháp:** Nếu có vấn đề, thử dùng D15 (GPIO15) hoặc dùng GPIO32/33 (ADC1)

### GPIO4 cho DHT11:
- GPIO4 có **ADC2_CH0** nhưng DHT11 dùng digital nên OK
- Không bị ảnh hưởng bởi WiFi

### GPIO5 cho LDR:
- GPIO5 là digital, OK cho LDR Module
- Không có vấn đề

---

## 🆘 Nếu Gặp Vấn Đề

### Soil Sensor không đọc được:
- GPIO2 (ADC2) có thể bị conflict với WiFi
- **Giải pháp:** Thử dùng D15 (GPIO15) hoặc GPIO32/33 (ADC1)

### DHT11 không đọc được:
- Kiểm tra điện trở 10kΩ pull-up
- Kiểm tra nối đúng D4 (GPIO4)

### LDR Module không đọc được:
- Kiểm tra nối đúng D5 (GPIO5)
- Điều chỉnh biến trở trên LDR Module

---

## 🎉 Sau Khi Nối Xong

1. ✅ Đã nối tất cả sensors vào GPIO mới
2. ✅ Đã nối tất cả actuators vào GPIO mới
3. ✅ Đã nối tất cả LED vào GPIO mới
4. ✅ Code đã được cập nhật với GPIO mới
5. ✅ Upload code và test

**Chúc bạn thành công!** 🔌✨

# 🔌 Hướng Dẫn Nối Chân Với GPIO Mới

## 📋 Phân Bổ GPIO Mới

Bạn đã đổi sang các GPIO sau:

### Sensors (Cảm Biến):
- **DHT11 OUT** → **D4 (GPIO4)**
- **Soil Sensor A0** → **D2 (GPIO2)** - ADC2_CH1
- **LDR Module D0** → **D5 (GPIO5)**

### Actuators (Điều Khiển):
- **Relay Máy Bơm** → **D18 (GPIO18)**
- **Relay Đèn** → **D19 (GPIO19)**

### LED (Báo Trạng Thái):
- **LED Xanh** → **D21 (GPIO21)**
- **LED Vàng** → **D22 (GPIO22)**
- **LED Đỏ** → **D23 (GPIO23)**

---

## 🔌 Cách Nối Chi Tiết

### 1. DHT11
```
DHT11 VCC ────> Power Rail (+) (3.3V)
DHT11 GND ────> Power Rail (-)
DHT11 OUT ────> ESP32 D4 (GPIO4)
Điện trở 10kΩ: DHT11 OUT ──> 3.3V (pull-up)
```

### 2. Soil Moisture Sensor
```
Soil VCC (đỏ) ────> Power Rail (+) (3.3V)
Soil GND (đen) ────> Power Rail (-)
Soil A0 (vàng/xanh) ────> ESP32 D2 (GPIO2)
Soil D0 ────> Không cần nối
```

### 3. LDR Module
```
LDR VCC ────> Power Rail (+) (3.3V)
LDR GND ────> Power Rail (-)
LDR D0 (OUT) ────> ESP32 D5 (GPIO5)
```

### 4. Relay Máy Bơm
```
Relay VCC ────> ESP32 5V (hoặc nguồn 5V riêng)
Relay GND ────> ESP32 GND
Relay IN (Signal) ────> ESP32 D18 (GPIO18)
```

### 5. Relay Đèn
```
Relay VCC ────> ESP32 5V
Relay GND ────> ESP32 GND
Relay IN (Signal) ────> ESP32 D19 (GPIO19)
```

### 6. LED Xanh
```
ESP32 D21 (GPIO21) ────> LED Xanh (+) (chân dài)
LED Xanh (-) (chân ngắn) ────> GND
```

### 7. LED Vàng
```
ESP32 D22 (GPIO22) ────> LED Vàng (+) (chân dài)
LED Vàng (-) (chân ngắn) ────> GND
```

### 8. LED Đỏ
```
ESP32 D23 (GPIO23) ────> LED Đỏ (+) (chân dài)
LED Đỏ (-) (chân ngắn) ────> GND
```

---

## 📊 Sơ Đồ Tổng Quan

```
ESP32 30 Chân
│
├── 3.3V ────> Power Rail (+) ────> Sensors VCC
├── GND ─────> Power Rail (-) ────> Sensors GND
│
├── D4 (GPIO4) ────> DHT11 OUT ──┬── 10kΩ ──> 3.3V
│
├── D2 (GPIO2) ────> Soil Sensor A0 (analog)
│
├── D5 (GPIO5) ────> LDR Module D0 (digital)
│
├── D18 (GPIO18) ────> Relay Pump IN
├── D19 (GPIO19) ────> Relay Light IN
│
├── D21 (GPIO21) ────> LED Xanh (+)
├── D22 (GPIO22) ────> LED Vàng (+)
└── D23 (GPIO23) ────> LED Đỏ (+)
```

---

## ✅ Checklist Kết Nối

### Sensors:
- [ ] DHT11 OUT → ESP32 D4 (GPIO4)
- [ ] Điện trở 10kΩ: DHT11 OUT → 3.3V
- [ ] Soil Sensor A0 → ESP32 D2 (GPIO2)
- [ ] LDR Module D0 → ESP32 D5 (GPIO5)

### Actuators:
- [ ] Relay Pump IN → ESP32 D18 (GPIO18)
- [ ] Relay Light IN → ESP32 D19 (GPIO19)

### LED:
- [ ] LED Xanh → ESP32 D21 (GPIO21)
- [ ] LED Vàng → ESP32 D22 (GPIO22)
- [ ] LED Đỏ → ESP32 D23 (GPIO23)

---

## ⚠️ Lưu Ý Quan Trọng

### GPIO2 cho Soil Sensor:
- GPIO2 có **ADC2_CH1** (analog input)
- Có thể bị ảnh hưởng khi WiFi hoạt động (ADC2 bị conflict với WiFi)
- **Giải pháp:** Nếu có vấn đề, thử dùng D15 (GPIO15) hoặc dùng GPIO32/33 (ADC1)

### GPIO4 cho DHT11:
- GPIO4 có **ADC2_CH0** nhưng DHT11 dùng digital nên OK
- Không bị ảnh hưởng bởi WiFi

### GPIO5 cho LDR:
- GPIO5 là digital, OK cho LDR Module
- Không có vấn đề

---

## 🆘 Nếu Gặp Vấn Đề

### Soil Sensor không đọc được:
- GPIO2 (ADC2) có thể bị conflict với WiFi
- **Giải pháp:** Thử dùng D15 (GPIO15) hoặc GPIO32/33 (ADC1)

### DHT11 không đọc được:
- Kiểm tra điện trở 10kΩ pull-up
- Kiểm tra nối đúng D4 (GPIO4)

### LDR Module không đọc được:
- Kiểm tra nối đúng D5 (GPIO5)
- Điều chỉnh biến trở trên LDR Module

---

## 🎉 Sau Khi Nối Xong

1. ✅ Đã nối tất cả sensors vào GPIO mới
2. ✅ Đã nối tất cả actuators vào GPIO mới
3. ✅ Đã nối tất cả LED vào GPIO mới
4. ✅ Code đã được cập nhật với GPIO mới
5. ✅ Upload code và test

**Chúc bạn thành công!** 🔌✨


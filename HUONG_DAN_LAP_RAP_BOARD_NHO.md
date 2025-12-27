# 🔧 Hướng Dẫn Lắp Ráp với Board Nhỏ (3V3 và GND)

## 📋 Hiểu Về Setup Của Bạn

Bạn có:
- **ESP32 30 chân (Type-C)**
- **2 board nhỏ riêng lẻ** (có thể là breakout board hoặc module)
- **Chỉ có 3V3 và GND** trên hàng bên

## 🎯 Cách Kết Nối

### Bước 1: Xác Định Board Nhỏ

**Board nhỏ có thể là:**
- Breadboard mini
- Breakout board
- Module mở rộng
- Hoặc board tự chế

**Kiểm tra:**
- Board có hàng **3V3** (hoặc 3.3V) không?
- Board có hàng **GND** không?
- Board có các lỗ cắm (pin holes) không?

---

### Bước 2: Kết Nối Nguồn Từ ESP32

**Kết nối nguồn:**
1. **ESP32 3.3V** → **Board nhỏ 3V3** (hàng bên)
2. **ESP32 GND** → **Board nhỏ GND** (hàng bên)

**Lưu ý:**
- Dùng dây jumper để nối
- Đảm bảo nối đúng cực (3.3V → 3V3, GND → GND)
- Có thể dùng nhiều dây để phân phối nguồn tốt hơn

---

### Bước 3: Kết Nối Sensors Vào Board Nhỏ

#### 3.1. DHT11

**Nếu DHT11 cắm vào board nhỏ:**
1. **DHT11 VCC** → **Board nhỏ 3V3** (hàng bên)
2. **DHT11 GND** → **Board nhỏ GND** (hàng bên)
3. **DHT11 DATA** → **Board nhỏ (lỗ bất kỳ)** → **ESP32 GPIO4**

**Điện trở 10kΩ:**
- Một đầu → DHT11 DATA
- Đầu kia → Board nhỏ 3V3

---

#### 3.2. Soil Sensor

**Nếu Soil Sensor cắm vào board nhỏ:**
1. **Soil Sensor VCC (đỏ)** → **Board nhỏ 3V3**
2. **Soil Sensor GND (đen)** → **Board nhỏ GND**
3. **Soil Sensor A0 (vàng/xanh)** → **ESP32 GPIO32**

---

#### 3.3. LDR

**Kết nối LDR:**
1. **Một đầu LDR** → **Board nhỏ 3V3**
2. **Đầu kia LDR** → **Board nhỏ (lỗ bất kỳ)** → **ESP32 GPIO33**
3. **Điện trở 10kΩ:**
   - Một đầu → Điểm giữa LDR và GPIO33
   - Đầu kia → Board nhỏ GND

---

### Bước 4: Kết Nối LED

**LED có thể cắm trực tiếp vào ESP32 hoặc qua board nhỏ:**

**Cách 1: Cắm trực tiếp vào ESP32 (Khuyến nghị)**
- GPIO26 → 220Ω → LED Xanh → GND
- GPIO27 → 220Ω → LED Vàng → GND
- GPIO14 → 220Ω → LED Đỏ → GND

**Cách 2: Qua Board Nhỏ**
- GPIO26 → Board nhỏ (lỗ) → 220Ω → LED Xanh → Board nhỏ GND
- GPIO27 → Board nhỏ (lỗ) → 220Ω → LED Vàng → Board nhỏ GND
- GPIO14 → Board nhỏ (lỗ) → 220Ω → LED Đỏ → Board nhỏ GND

---

## 🔌 Sơ Đồ Kết Nối Với Board Nhỏ

```
ESP32 Board
│
├── 3.3V ────────────┐
│                    │
│                    ├──> Board Nhỏ 1 - 3V3
│                    │    │
│                    │    ├── DHT11 VCC
│                    │    ├── Soil Sensor VCC
│                    │    └── LDR (một đầu)
│                    │
├── 3.3V ────────────┘
│
├── GND ─────────────┐
│                    │
│                    ├──> Board Nhỏ 1 - GND
│                    │    │
│                    │    ├── DHT11 GND
│                    │    ├── Soil Sensor GND
│                    │    ├── LDR (qua 10kΩ)
│                    │    └── LED (-)
│                    │
├── GND ─────────────┘
│
├── GPIO4 ───────────> Board Nhỏ → DHT11 DATA
├── GPIO32 ──────────> Soil Sensor A0
├── GPIO33 ──────────> Board Nhỏ → LDR (điểm giữa)
├── GPIO26 ──────────> LED Xanh (+)
├── GPIO27 ──────────> LED Vàng (+)
└── GPIO14 ──────────> LED Đỏ (+)
```

---

## 📝 Hướng Dẫn Chi Tiết

### Nếu Board Nhỏ Là Breadboard Mini:

**Breadboard mini thường có:**
- Hàng dọc: 3V3, GND, và các lỗ cắm
- Hoặc hàng ngang: 3V3, GND

**Cách kết nối:**
1. **Nối ESP32 3.3V → Hàng 3V3** trên board nhỏ
2. **Nối ESP32 GND → Hàng GND** trên board nhỏ
3. **Cắm sensors vào các lỗ** trên board nhỏ
4. **Nối VCC/GND của sensors** vào hàng 3V3/GND tương ứng
5. **Nối tín hiệu (DATA, A0)** trực tiếp từ board nhỏ → ESP32 GPIO

---

### Nếu Board Nhỏ Là Module Riêng:

**Module có thể có:**
- Pin header để cắm sensors
- Hàng 3V3 và GND
- Các lỗ cắm khác

**Cách kết nối:**
1. **Nối nguồn:** ESP32 3.3V → Module 3V3, ESP32 GND → Module GND
2. **Cắm sensors vào module** (nếu có pin header)
3. **Nối tín hiệu:** Module → ESP32 GPIO

---

## ✅ Checklist Kết Nối

**Nguồn:**
- [ ] ESP32 3.3V → Board nhỏ 3V3
- [ ] ESP32 GND → Board nhỏ GND

**DHT11:**
- [ ] DHT11 VCC → Board nhỏ 3V3
- [ ] DHT11 GND → Board nhỏ GND
- [ ] DHT11 DATA → ESP32 GPIO4
- [ ] Điện trở 10kΩ: DATA → 3V3

**Soil Sensor:**
- [ ] Soil VCC → Board nhỏ 3V3
- [ ] Soil GND → Board nhỏ GND
- [ ] Soil A0 → ESP32 GPIO32

**LDR:**
- [ ] LDR (một đầu) → Board nhỏ 3V3
- [ ] LDR (đầu kia) → ESP32 GPIO33
- [ ] Điện trở 10kΩ: GPIO33 → Board nhỏ GND

**LED:**
- [ ] LED Xanh: GPIO26 → 220Ω → LED → GND
- [ ] LED Vàng: GPIO27 → 220Ω → LED → GND
- [ ] LED Đỏ: GPIO14 → 220Ω → LED → GND

---

## 💡 Tips

1. **Dùng nhiều dây nối nguồn:**
   - Nối 2-3 dây từ ESP32 3.3V → Board nhỏ 3V3
   - Nối 2-3 dây từ ESP32 GND → Board nhỏ GND
   - Giúp phân phối nguồn tốt hơn

2. **Kiểm tra nguồn:**
   - Dùng multimeter đo điện áp giữa 3V3 và GND
   - Phải có ~3.3V

3. **Nếu board nhỏ có nhiều hàng 3V3/GND:**
   - Nối tất cả hàng 3V3 với nhau
   - Nối tất cả hàng GND với nhau
   - Giúp phân phối nguồn đều

---

## 🎯 Thứ Tự Lắp Ráp

### Bước 1: Nối Nguồn
1. ESP32 3.3V → Board nhỏ 3V3
2. ESP32 GND → Board nhỏ GND

### Bước 2: Lắp Sensors
1. DHT11 vào board nhỏ
2. Soil Sensor vào board nhỏ
3. LDR vào board nhỏ

### Bước 3: Nối Tín Hiệu
1. DHT11 DATA → ESP32 GPIO4
2. Soil A0 → ESP32 GPIO32
3. LDR → ESP32 GPIO33

### Bước 4: Lắp LED
- LED có thể cắm trực tiếp vào ESP32 (không cần board nhỏ)

### Bước 5: Test
- Upload code và kiểm tra

---

## 🆘 Nếu Gặp Vấn Đề

### Sensors không hoạt động:
- **Kiểm tra nguồn:** Đo điện áp giữa 3V3 và GND trên board nhỏ
- **Kiểm tra kết nối:** Đảm bảo VCC → 3V3, GND → GND
- **Kiểm tra dây tín hiệu:** Đảm bảo nối đúng GPIO

### Nguồn không đủ:
- **Dùng nhiều dây nối nguồn** (2-3 dây cho 3V3, 2-3 dây cho GND)
- **Kiểm tra dây nối** có bị lỏng không
- **Kiểm tra ESP32** có cấp đủ 3.3V không

---

## 📸 Mô Tả Bố Cục

```
[ESP32] ──── 3.3V ────> [Board Nhỏ 1] ──── 3V3 ────> Sensors
        │                │
        │                ├── DHT11 VCC
        │                ├── Soil VCC
        │                └── LDR
        │
        └── GND ───────> [Board Nhỏ 1] ──── GND ───> Sensors
                          │
                          ├── DHT11 GND
                          ├── Soil GND
                          └── LDR (qua 10kΩ)
```

---

## 🎉 Bắt Đầu Lắp Ráp

**Bước đầu tiên:**
1. **Nối ESP32 3.3V → Board nhỏ 3V3**
2. **Nối ESP32 GND → Board nhỏ GND**
3. **Kiểm tra:** Dùng multimeter đo điện áp (phải có ~3.3V)

**Sau đó:**
- Lắp sensors vào board nhỏ
- Nối tín hiệu từ board nhỏ → ESP32 GPIO
- Test từng phần

**Chúc bạn lắp ráp thành công!** 🚀

# 🔧 Hướng Dẫn Lắp Ráp với Board Nhỏ (3V3 và GND)

## 📋 Hiểu Về Setup Của Bạn

Bạn có:
- **ESP32 30 chân (Type-C)**
- **2 board nhỏ riêng lẻ** (có thể là breakout board hoặc module)
- **Chỉ có 3V3 và GND** trên hàng bên

## 🎯 Cách Kết Nối

### Bước 1: Xác Định Board Nhỏ

**Board nhỏ có thể là:**
- Breadboard mini
- Breakout board
- Module mở rộng
- Hoặc board tự chế

**Kiểm tra:**
- Board có hàng **3V3** (hoặc 3.3V) không?
- Board có hàng **GND** không?
- Board có các lỗ cắm (pin holes) không?

---

### Bước 2: Kết Nối Nguồn Từ ESP32

**Kết nối nguồn:**
1. **ESP32 3.3V** → **Board nhỏ 3V3** (hàng bên)
2. **ESP32 GND** → **Board nhỏ GND** (hàng bên)

**Lưu ý:**
- Dùng dây jumper để nối
- Đảm bảo nối đúng cực (3.3V → 3V3, GND → GND)
- Có thể dùng nhiều dây để phân phối nguồn tốt hơn

---

### Bước 3: Kết Nối Sensors Vào Board Nhỏ

#### 3.1. DHT11

**Nếu DHT11 cắm vào board nhỏ:**
1. **DHT11 VCC** → **Board nhỏ 3V3** (hàng bên)
2. **DHT11 GND** → **Board nhỏ GND** (hàng bên)
3. **DHT11 DATA** → **Board nhỏ (lỗ bất kỳ)** → **ESP32 GPIO4**

**Điện trở 10kΩ:**
- Một đầu → DHT11 DATA
- Đầu kia → Board nhỏ 3V3

---

#### 3.2. Soil Sensor

**Nếu Soil Sensor cắm vào board nhỏ:**
1. **Soil Sensor VCC (đỏ)** → **Board nhỏ 3V3**
2. **Soil Sensor GND (đen)** → **Board nhỏ GND**
3. **Soil Sensor A0 (vàng/xanh)** → **ESP32 GPIO32**

---

#### 3.3. LDR

**Kết nối LDR:**
1. **Một đầu LDR** → **Board nhỏ 3V3**
2. **Đầu kia LDR** → **Board nhỏ (lỗ bất kỳ)** → **ESP32 GPIO33**
3. **Điện trở 10kΩ:**
   - Một đầu → Điểm giữa LDR và GPIO33
   - Đầu kia → Board nhỏ GND

---

### Bước 4: Kết Nối LED

**LED có thể cắm trực tiếp vào ESP32 hoặc qua board nhỏ:**

**Cách 1: Cắm trực tiếp vào ESP32 (Khuyến nghị)**
- GPIO26 → 220Ω → LED Xanh → GND
- GPIO27 → 220Ω → LED Vàng → GND
- GPIO14 → 220Ω → LED Đỏ → GND

**Cách 2: Qua Board Nhỏ**
- GPIO26 → Board nhỏ (lỗ) → 220Ω → LED Xanh → Board nhỏ GND
- GPIO27 → Board nhỏ (lỗ) → 220Ω → LED Vàng → Board nhỏ GND
- GPIO14 → Board nhỏ (lỗ) → 220Ω → LED Đỏ → Board nhỏ GND

---

## 🔌 Sơ Đồ Kết Nối Với Board Nhỏ

```
ESP32 Board
│
├── 3.3V ────────────┐
│                    │
│                    ├──> Board Nhỏ 1 - 3V3
│                    │    │
│                    │    ├── DHT11 VCC
│                    │    ├── Soil Sensor VCC
│                    │    └── LDR (một đầu)
│                    │
├── 3.3V ────────────┘
│
├── GND ─────────────┐
│                    │
│                    ├──> Board Nhỏ 1 - GND
│                    │    │
│                    │    ├── DHT11 GND
│                    │    ├── Soil Sensor GND
│                    │    ├── LDR (qua 10kΩ)
│                    │    └── LED (-)
│                    │
├── GND ─────────────┘
│
├── GPIO4 ───────────> Board Nhỏ → DHT11 DATA
├── GPIO32 ──────────> Soil Sensor A0
├── GPIO33 ──────────> Board Nhỏ → LDR (điểm giữa)
├── GPIO26 ──────────> LED Xanh (+)
├── GPIO27 ──────────> LED Vàng (+)
└── GPIO14 ──────────> LED Đỏ (+)
```

---

## 📝 Hướng Dẫn Chi Tiết

### Nếu Board Nhỏ Là Breadboard Mini:

**Breadboard mini thường có:**
- Hàng dọc: 3V3, GND, và các lỗ cắm
- Hoặc hàng ngang: 3V3, GND

**Cách kết nối:**
1. **Nối ESP32 3.3V → Hàng 3V3** trên board nhỏ
2. **Nối ESP32 GND → Hàng GND** trên board nhỏ
3. **Cắm sensors vào các lỗ** trên board nhỏ
4. **Nối VCC/GND của sensors** vào hàng 3V3/GND tương ứng
5. **Nối tín hiệu (DATA, A0)** trực tiếp từ board nhỏ → ESP32 GPIO

---

### Nếu Board Nhỏ Là Module Riêng:

**Module có thể có:**
- Pin header để cắm sensors
- Hàng 3V3 và GND
- Các lỗ cắm khác

**Cách kết nối:**
1. **Nối nguồn:** ESP32 3.3V → Module 3V3, ESP32 GND → Module GND
2. **Cắm sensors vào module** (nếu có pin header)
3. **Nối tín hiệu:** Module → ESP32 GPIO

---

## ✅ Checklist Kết Nối

**Nguồn:**
- [ ] ESP32 3.3V → Board nhỏ 3V3
- [ ] ESP32 GND → Board nhỏ GND

**DHT11:**
- [ ] DHT11 VCC → Board nhỏ 3V3
- [ ] DHT11 GND → Board nhỏ GND
- [ ] DHT11 DATA → ESP32 GPIO4
- [ ] Điện trở 10kΩ: DATA → 3V3

**Soil Sensor:**
- [ ] Soil VCC → Board nhỏ 3V3
- [ ] Soil GND → Board nhỏ GND
- [ ] Soil A0 → ESP32 GPIO32

**LDR:**
- [ ] LDR (một đầu) → Board nhỏ 3V3
- [ ] LDR (đầu kia) → ESP32 GPIO33
- [ ] Điện trở 10kΩ: GPIO33 → Board nhỏ GND

**LED:**
- [ ] LED Xanh: GPIO26 → 220Ω → LED → GND
- [ ] LED Vàng: GPIO27 → 220Ω → LED → GND
- [ ] LED Đỏ: GPIO14 → 220Ω → LED → GND

---

## 💡 Tips

1. **Dùng nhiều dây nối nguồn:**
   - Nối 2-3 dây từ ESP32 3.3V → Board nhỏ 3V3
   - Nối 2-3 dây từ ESP32 GND → Board nhỏ GND
   - Giúp phân phối nguồn tốt hơn

2. **Kiểm tra nguồn:**
   - Dùng multimeter đo điện áp giữa 3V3 và GND
   - Phải có ~3.3V

3. **Nếu board nhỏ có nhiều hàng 3V3/GND:**
   - Nối tất cả hàng 3V3 với nhau
   - Nối tất cả hàng GND với nhau
   - Giúp phân phối nguồn đều

---

## 🎯 Thứ Tự Lắp Ráp

### Bước 1: Nối Nguồn
1. ESP32 3.3V → Board nhỏ 3V3
2. ESP32 GND → Board nhỏ GND

### Bước 2: Lắp Sensors
1. DHT11 vào board nhỏ
2. Soil Sensor vào board nhỏ
3. LDR vào board nhỏ

### Bước 3: Nối Tín Hiệu
1. DHT11 DATA → ESP32 GPIO4
2. Soil A0 → ESP32 GPIO32
3. LDR → ESP32 GPIO33

### Bước 4: Lắp LED
- LED có thể cắm trực tiếp vào ESP32 (không cần board nhỏ)

### Bước 5: Test
- Upload code và kiểm tra

---

## 🆘 Nếu Gặp Vấn Đề

### Sensors không hoạt động:
- **Kiểm tra nguồn:** Đo điện áp giữa 3V3 và GND trên board nhỏ
- **Kiểm tra kết nối:** Đảm bảo VCC → 3V3, GND → GND
- **Kiểm tra dây tín hiệu:** Đảm bảo nối đúng GPIO

### Nguồn không đủ:
- **Dùng nhiều dây nối nguồn** (2-3 dây cho 3V3, 2-3 dây cho GND)
- **Kiểm tra dây nối** có bị lỏng không
- **Kiểm tra ESP32** có cấp đủ 3.3V không

---

## 📸 Mô Tả Bố Cục

```
[ESP32] ──── 3.3V ────> [Board Nhỏ 1] ──── 3V3 ────> Sensors
        │                │
        │                ├── DHT11 VCC
        │                ├── Soil VCC
        │                └── LDR
        │
        └── GND ───────> [Board Nhỏ 1] ──── GND ───> Sensors
                          │
                          ├── DHT11 GND
                          ├── Soil GND
                          └── LDR (qua 10kΩ)
```

---

## 🎉 Bắt Đầu Lắp Ráp

**Bước đầu tiên:**
1. **Nối ESP32 3.3V → Board nhỏ 3V3**
2. **Nối ESP32 GND → Board nhỏ GND**
3. **Kiểm tra:** Dùng multimeter đo điện áp (phải có ~3.3V)

**Sau đó:**
- Lắp sensors vào board nhỏ
- Nối tín hiệu từ board nhỏ → ESP32 GPIO
- Test từng phần

**Chúc bạn lắp ráp thành công!** 🚀


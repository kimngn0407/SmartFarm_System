# 🔌 Hướng Dẫn Nối Chân Sensors Vào ESP32 30 Chân

## 📋 Tổng Quan

Hướng dẫn này giải thích cách nối các chân của sensors vào ESP32 30 chân.

---

## 🔴 Cảm Biến Độ Ẩm Đất (Soil Moisture Sensor)

### Các Chân Của Soil Sensor:
- **VCC** (đỏ) - Nguồn dương
- **GND** (đen) - Nguồn âm
- **A0** (vàng/xanh) - Tín hiệu analog (0-4095)
- **D0** (có thể có) - Tín hiệu digital (HIGH/LOW)

### Cách Nối:

#### Nối A0 (Khuyến nghị - Đọc giá trị chính xác):
```
Soil Sensor A0 ────> ESP32 GPIO32
```

**Lý do chọn GPIO32:**
- GPIO32 là **ADC1_CH4** (analog input)
- ESP32 có ADC 12-bit (0-4095)
- Đọc được giá trị chính xác từ 0-100%

#### Nối D0 (Tùy chọn - Chỉ báo HIGH/LOW):
```
Soil Sensor D0 ────> ESP32 GPIO (bất kỳ, ví dụ GPIO33)
```

**Lưu ý:**
- D0 chỉ báo HIGH/LOW (không có giá trị chính xác)
- Thường dùng A0 để đọc giá trị chính xác
- Code hiện tại dùng **GPIO32 cho A0**

---

## 🔴 Cảm Biến Ánh Sáng (LDR Module)

### Các Chân Của LDR Module:
- **VCC** - Nguồn dương
- **GND** - Nguồn âm
- **D0** (hoặc OUT) - Tín hiệu digital (HIGH/LOW)
- **A0** (có thể có) - Tín hiệu analog

### Cách Nối:

#### Nếu LDR Module có D0 (Digital Output):
```
LDR Module D0 (OUT) ────> ESP32 GPIO15
```

**Lý do chọn GPIO15:**
- Code hiện tại dùng **GPIO15** cho LDR Module
- LDR Module digital: HIGH = sáng, LOW = tối
- Code đọc digital và tính % độ sáng

#### Nếu LDR Module có A0 (Analog Output):
```
LDR Module A0 ────> ESP32 GPIO33 (ADC1_CH5)
```

**Lưu ý:**
- Nếu dùng A0, cần sửa code từ `digitalRead()` → `analogRead()`
- Code hiện tại dùng **GPIO15 (digital)** cho LDR Module

---

## 🔴 DHT11 (Cảm Biến Nhiệt Độ, Độ Ẩm)

### Các Chân Của DHT11:
- **VCC** - Nguồn dương
- **OUT** (hoặc DATA) - Tín hiệu dữ liệu
- **GND** - Nguồn âm

### Cách Nối:

#### Nối Chân OUT (DATA):
```
DHT11 OUT (DATA) ────> ESP32 GPIO12
```

**Lý do chọn GPIO12:**
- Code hiện tại dùng **GPIO12** cho DHT11
- Cần thêm điện trở 10kΩ pull-up:
  - Một đầu → DHT11 OUT
  - Đầu kia → 3.3V

---

## 📊 Tổng Kết Kết Nối

### Sơ Đồ Đầy Đủ:

```
ESP32 30 Chân
│
├── 3.3V ────> Power Rail (+) ────> Sensors VCC
│
├── GND ─────> Power Rail (-) ────> Sensors GND
│
├── GPIO12 ──> DHT11 OUT (DATA) ──┬── 10kΩ ──> 3.3V (pull-up)
│
├── GPIO32 ──> Soil Sensor A0 (analog)
│
└── GPIO15 ──> LDR Module D0 (digital)
```

---

## ✅ Checklist Kết Nối Chi Tiết

### DHT11:
- [ ] DHT11 VCC → Power Rail (+) (3.3V)
- [ ] DHT11 GND → Power Rail (-)
- [ ] DHT11 OUT (DATA) → ESP32 GPIO12
- [ ] Điện trở 10kΩ: DHT11 OUT → 3.3V

### Soil Moisture Sensor:
- [ ] Soil VCC (đỏ) → Power Rail (+) (3.3V)
- [ ] Soil GND (đen) → Power Rail (-)
- [ ] Soil A0 (vàng/xanh) → ESP32 GPIO32
- [ ] Soil D0 (nếu có) → Không cần nối (hoặc GPIO khác nếu muốn)

### LDR Module:
- [ ] LDR VCC → Power Rail (+) (3.3V)
- [ ] LDR GND → Power Rail (-)
- [ ] LDR D0 (OUT) → ESP32 GPIO15
- [ ] LDR A0 (nếu có) → Không cần nối (hoặc GPIO33 nếu muốn dùng analog)

---

## 🔍 Giải Thích Các Chân

### A0 (Analog):
- Đọc giá trị **tương tự** (0-4095 trên ESP32)
- Cho giá trị **chính xác**, có thể map thành %
- Cần GPIO có chức năng ADC (GPIO32, GPIO33, GPIO34, GPIO35, GPIO36, GPIO39)

### D0 (Digital):
- Đọc giá trị **số** (HIGH/LOW)
- Chỉ báo có/không, không có giá trị chính xác
- Có thể dùng bất kỳ GPIO nào

### OUT/DATA:
- Chân tín hiệu dữ liệu
- DHT11 dùng giao tiếp **digital** nhưng cần pull-up resistor

---

## 🎯 GPIO Được Dùng Trong Code

Theo code `Arduino_SmartFarm_Demo.ino`:

```cpp
#define DHTPIN       12       // DHT11 DATA (GPIO12)
#define SOIL_PIN     32       // Soil sensor A0 (GPIO32 - ADC1_CH4)
#define LIGHT_PIN    15       // LDR Module D0 (GPIO15 - digital)
```

**→ Nối đúng theo code này!**

---

## 📝 Hướng Dẫn Nối Từng Bước

### Bước 1: Nối DHT11
1. DHT11 VCC → Power Rail (+) (3.3V)
2. DHT11 GND → Power Rail (-)
3. DHT11 OUT → ESP32 GPIO12
4. Điện trở 10kΩ: DHT11 OUT → 3.3V

### Bước 2: Nối Soil Sensor
1. Soil VCC (đỏ) → Power Rail (+) (3.3V)
2. Soil GND (đen) → Power Rail (-)
3. Soil A0 (vàng/xanh) → ESP32 GPIO32
4. Soil D0 → Không cần nối (hoặc bỏ qua)

### Bước 3: Nối LDR Module
1. LDR VCC → Power Rail (+) (3.3V)
2. LDR GND → Power Rail (-)
3. LDR D0 (OUT) → ESP32 GPIO15
4. LDR A0 → Không cần nối (nếu dùng digital)

---

## ⚠️ Lưu Ý Quan Trọng

### 1. Đảm Bảo Nối Đúng:
- **A0** → GPIO có ADC (GPIO32, GPIO33...)
- **D0** → GPIO bất kỳ (GPIO15...)
- **OUT/DATA** → GPIO bất kỳ (GPIO12...)

### 2. Điện Trở Pull-up:
- DHT11 OUT cần điện trở 10kΩ lên 3.3V
- Không có điện trở → DHT11 không hoạt động

### 3. Nguồn:
- Tất cả sensors dùng **3.3V** (không dùng 5V)
- Đảm bảo nối đúng VCC và GND

---

## 🆘 Nếu Gặp Vấn Đề

### DHT11 không đọc được:
- Kiểm tra điện trở 10kΩ pull-up
- Kiểm tra nối đúng GPIO12
- Kiểm tra nguồn 3.3V

### Soil Sensor không đọc được:
- Kiểm tra nối đúng GPIO32 (A0)
- Kiểm tra nguồn 3.3V
- Thử đọc giá trị raw trong Serial Monitor

### LDR Module không đọc được:
- Kiểm tra nối đúng GPIO15 (D0)
- Kiểm tra nguồn 3.3V
- Điều chỉnh biến trở trên LDR Module

---

## 🎉 Sau Khi Nối Xong

1. ✅ Đã nối DHT11 OUT → GPIO12
2. ✅ Đã nối Soil A0 → GPIO32
3. ✅ Đã nối LDR D0 → GPIO15
4. ✅ Đã thêm điện trở 10kΩ cho DHT11
5. ✅ Upload code và test

**Chúc bạn thành công!** 🔌✨

# 🔌 Hướng Dẫn Nối Chân Sensors Vào ESP32 30 Chân

## 📋 Tổng Quan

Hướng dẫn này giải thích cách nối các chân của sensors vào ESP32 30 chân.

---

## 🔴 Cảm Biến Độ Ẩm Đất (Soil Moisture Sensor)

### Các Chân Của Soil Sensor:
- **VCC** (đỏ) - Nguồn dương
- **GND** (đen) - Nguồn âm
- **A0** (vàng/xanh) - Tín hiệu analog (0-4095)
- **D0** (có thể có) - Tín hiệu digital (HIGH/LOW)

### Cách Nối:

#### Nối A0 (Khuyến nghị - Đọc giá trị chính xác):
```
Soil Sensor A0 ────> ESP32 GPIO32
```

**Lý do chọn GPIO32:**
- GPIO32 là **ADC1_CH4** (analog input)
- ESP32 có ADC 12-bit (0-4095)
- Đọc được giá trị chính xác từ 0-100%

#### Nối D0 (Tùy chọn - Chỉ báo HIGH/LOW):
```
Soil Sensor D0 ────> ESP32 GPIO (bất kỳ, ví dụ GPIO33)
```

**Lưu ý:**
- D0 chỉ báo HIGH/LOW (không có giá trị chính xác)
- Thường dùng A0 để đọc giá trị chính xác
- Code hiện tại dùng **GPIO32 cho A0**

---

## 🔴 Cảm Biến Ánh Sáng (LDR Module)

### Các Chân Của LDR Module:
- **VCC** - Nguồn dương
- **GND** - Nguồn âm
- **D0** (hoặc OUT) - Tín hiệu digital (HIGH/LOW)
- **A0** (có thể có) - Tín hiệu analog

### Cách Nối:

#### Nếu LDR Module có D0 (Digital Output):
```
LDR Module D0 (OUT) ────> ESP32 GPIO15
```

**Lý do chọn GPIO15:**
- Code hiện tại dùng **GPIO15** cho LDR Module
- LDR Module digital: HIGH = sáng, LOW = tối
- Code đọc digital và tính % độ sáng

#### Nếu LDR Module có A0 (Analog Output):
```
LDR Module A0 ────> ESP32 GPIO33 (ADC1_CH5)
```

**Lưu ý:**
- Nếu dùng A0, cần sửa code từ `digitalRead()` → `analogRead()`
- Code hiện tại dùng **GPIO15 (digital)** cho LDR Module

---

## 🔴 DHT11 (Cảm Biến Nhiệt Độ, Độ Ẩm)

### Các Chân Của DHT11:
- **VCC** - Nguồn dương
- **OUT** (hoặc DATA) - Tín hiệu dữ liệu
- **GND** - Nguồn âm

### Cách Nối:

#### Nối Chân OUT (DATA):
```
DHT11 OUT (DATA) ────> ESP32 GPIO12
```

**Lý do chọn GPIO12:**
- Code hiện tại dùng **GPIO12** cho DHT11
- Cần thêm điện trở 10kΩ pull-up:
  - Một đầu → DHT11 OUT
  - Đầu kia → 3.3V

---

## 📊 Tổng Kết Kết Nối

### Sơ Đồ Đầy Đủ:

```
ESP32 30 Chân
│
├── 3.3V ────> Power Rail (+) ────> Sensors VCC
│
├── GND ─────> Power Rail (-) ────> Sensors GND
│
├── GPIO12 ──> DHT11 OUT (DATA) ──┬── 10kΩ ──> 3.3V (pull-up)
│
├── GPIO32 ──> Soil Sensor A0 (analog)
│
└── GPIO15 ──> LDR Module D0 (digital)
```

---

## ✅ Checklist Kết Nối Chi Tiết

### DHT11:
- [ ] DHT11 VCC → Power Rail (+) (3.3V)
- [ ] DHT11 GND → Power Rail (-)
- [ ] DHT11 OUT (DATA) → ESP32 GPIO12
- [ ] Điện trở 10kΩ: DHT11 OUT → 3.3V

### Soil Moisture Sensor:
- [ ] Soil VCC (đỏ) → Power Rail (+) (3.3V)
- [ ] Soil GND (đen) → Power Rail (-)
- [ ] Soil A0 (vàng/xanh) → ESP32 GPIO32
- [ ] Soil D0 (nếu có) → Không cần nối (hoặc GPIO khác nếu muốn)

### LDR Module:
- [ ] LDR VCC → Power Rail (+) (3.3V)
- [ ] LDR GND → Power Rail (-)
- [ ] LDR D0 (OUT) → ESP32 GPIO15
- [ ] LDR A0 (nếu có) → Không cần nối (hoặc GPIO33 nếu muốn dùng analog)

---

## 🔍 Giải Thích Các Chân

### A0 (Analog):
- Đọc giá trị **tương tự** (0-4095 trên ESP32)
- Cho giá trị **chính xác**, có thể map thành %
- Cần GPIO có chức năng ADC (GPIO32, GPIO33, GPIO34, GPIO35, GPIO36, GPIO39)

### D0 (Digital):
- Đọc giá trị **số** (HIGH/LOW)
- Chỉ báo có/không, không có giá trị chính xác
- Có thể dùng bất kỳ GPIO nào

### OUT/DATA:
- Chân tín hiệu dữ liệu
- DHT11 dùng giao tiếp **digital** nhưng cần pull-up resistor

---

## 🎯 GPIO Được Dùng Trong Code

Theo code `Arduino_SmartFarm_Demo.ino`:

```cpp
#define DHTPIN       12       // DHT11 DATA (GPIO12)
#define SOIL_PIN     32       // Soil sensor A0 (GPIO32 - ADC1_CH4)
#define LIGHT_PIN    15       // LDR Module D0 (GPIO15 - digital)
```

**→ Nối đúng theo code này!**

---

## 📝 Hướng Dẫn Nối Từng Bước

### Bước 1: Nối DHT11
1. DHT11 VCC → Power Rail (+) (3.3V)
2. DHT11 GND → Power Rail (-)
3. DHT11 OUT → ESP32 GPIO12
4. Điện trở 10kΩ: DHT11 OUT → 3.3V

### Bước 2: Nối Soil Sensor
1. Soil VCC (đỏ) → Power Rail (+) (3.3V)
2. Soil GND (đen) → Power Rail (-)
3. Soil A0 (vàng/xanh) → ESP32 GPIO32
4. Soil D0 → Không cần nối (hoặc bỏ qua)

### Bước 3: Nối LDR Module
1. LDR VCC → Power Rail (+) (3.3V)
2. LDR GND → Power Rail (-)
3. LDR D0 (OUT) → ESP32 GPIO15
4. LDR A0 → Không cần nối (nếu dùng digital)

---

## ⚠️ Lưu Ý Quan Trọng

### 1. Đảm Bảo Nối Đúng:
- **A0** → GPIO có ADC (GPIO32, GPIO33...)
- **D0** → GPIO bất kỳ (GPIO15...)
- **OUT/DATA** → GPIO bất kỳ (GPIO12...)

### 2. Điện Trở Pull-up:
- DHT11 OUT cần điện trở 10kΩ lên 3.3V
- Không có điện trở → DHT11 không hoạt động

### 3. Nguồn:
- Tất cả sensors dùng **3.3V** (không dùng 5V)
- Đảm bảo nối đúng VCC và GND

---

## 🆘 Nếu Gặp Vấn Đề

### DHT11 không đọc được:
- Kiểm tra điện trở 10kΩ pull-up
- Kiểm tra nối đúng GPIO12
- Kiểm tra nguồn 3.3V

### Soil Sensor không đọc được:
- Kiểm tra nối đúng GPIO32 (A0)
- Kiểm tra nguồn 3.3V
- Thử đọc giá trị raw trong Serial Monitor

### LDR Module không đọc được:
- Kiểm tra nối đúng GPIO15 (D0)
- Kiểm tra nguồn 3.3V
- Điều chỉnh biến trở trên LDR Module

---

## 🎉 Sau Khi Nối Xong

1. ✅ Đã nối DHT11 OUT → GPIO12
2. ✅ Đã nối Soil A0 → GPIO32
3. ✅ Đã nối LDR D0 → GPIO15
4. ✅ Đã thêm điện trở 10kΩ cho DHT11
5. ✅ Upload code và test

**Chúc bạn thành công!** 🔌✨


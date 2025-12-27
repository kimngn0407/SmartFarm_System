# 🛒 Danh Sách Mua Sắm - SmartFarm ESP32

## 📋 Tổng Quan

Danh sách này bao gồm **TẤT CẢ** linh kiện cần thiết để lắp ráp hệ thống SmartFarm hoàn chỉnh, bao gồm cả relay và máy bơm.

---

## 🔴 PHẦN CỨNG CHÍNH (Bắt Buộc)

### 1. Board Vi Điều Khiển
- [ ] **ESP32 Development Board** (30 chân, Type-C) - **1 cái**
  - Giá tham khảo: 80,000 - 150,000 VNĐ
  - Lưu ý: Chọn loại có Type-C, 30 chân

---

### 2. Cảm Biến (Sensors)

#### 2.1. DHT11 - Cảm biến nhiệt độ, độ ẩm không khí
- [ ] **DHT11 Module** - **1 cái**
  - Giá tham khảo: 15,000 - 30,000 VNĐ
  - Lưu ý: Nên mua module (đã có sẵn điện trở), không mua DHT11 thô

#### 2.2. Soil Moisture Sensor - Cảm biến độ ẩm đất
- [ ] **Soil Moisture Sensor** - **1 cái**
  - Giá tham khảo: 20,000 - 40,000 VNĐ
  - Lưu ý: Có 3 dây (VCC đỏ, GND đen, A0 vàng/xanh)

#### 2.3. LDR - Cảm biến ánh sáng
- [ ] **LDR Module** (có LED báo) - **1 cái**
  - Giá tham khảo: 15,000 - 30,000 VNĐ
  - Lưu ý: Nên mua module (có biến trở điều chỉnh), không mua LDR thô

---

### 3. Điều Khiển (Actuators)

#### 3.1. Relay Module
- [ ] **Relay Module 2 kênh** (hoặc 2 module 1 kênh) - **2 cái**
  - Giá tham khảo: 25,000 - 50,000 VNĐ/cái
  - Tổng: 50,000 - 100,000 VNĐ
  - Lưu ý: 
    - 1 relay cho máy bơm
    - 1 relay cho đèn
    - Nên mua loại 5V, có optocoupler cách ly

#### 3.2. Máy Bơm
- [ ] **Máy bơm mini 5V DC** - **1 cái**
  - Giá tham khảo: 30,000 - 80,000 VNĐ
  - Lưu ý: 
    - Công suất: 3-5W
    - Điện áp: 5V DC
    - Có thể mua kèm ống dẫn nước

#### 3.3. Đèn (Tùy chọn)
- [ ] **Đèn LED 12V DC** (hoặc đèn 220V AC nếu có kinh nghiệm) - **1 cái**
  - Giá tham khảo: 20,000 - 50,000 VNĐ
  - Lưu ý: 
    - Nên dùng đèn 12V DC (an toàn hơn)
    - Nếu dùng 220V AC: CẦN CẨN THẬN, chỉ lắp nếu có kinh nghiệm

---

### 4. LED Báo Trạng Thái

- [ ] **LED Xanh** (5mm) - **1 cái**
- [ ] **LED Vàng** (5mm) - **1 cái**
- [ ] **LED Đỏ** (5mm) - **1 cái**
- Giá tham khảo: 1,000 - 3,000 VNĐ/cái
- Tổng: 3,000 - 9,000 VNĐ

---

### 5. Điện Trở (Resistors)

- [ ] **Điện trở 10kΩ** (1/4W) - **2 cái**
  - 1 cái cho DHT11 (pull-up)
  - 1 cái cho LDR (nếu dùng LDR thô, không cần nếu dùng LDR Module)
- [ ] **Điện trở 220Ω** (1/4W) - **3 cái**
  - 1 cái cho LED Xanh
  - 1 cái cho LED Vàng
  - 1 cái cho LED Đỏ
- Giá tham khảo: 500 - 2,000 VNĐ/cái
- Tổng: 2,500 - 10,000 VNĐ

---

### 6. Breadboard & Dây Nối

- [ ] **Breadboard lớn** (830 lỗ) - **1 cái**
  - Giá tham khảo: 30,000 - 60,000 VNĐ
- [ ] **Breadboard nhỏ** (400 lỗ) - **1 cái** (tùy chọn)
  - Giá tham khảo: 15,000 - 30,000 VNĐ
- [ ] **Dây jumper** (male-to-male) - **1 bộ** (40-65 dây)
  - Giá tham khảo: 20,000 - 40,000 VNĐ
- [ ] **Dây jumper** (female-to-male) - **1 bộ** (40 dây) - Tùy chọn
  - Giá tham khảo: 20,000 - 40,000 VNĐ

---

### 7. Nguồn & Cáp

- [ ] **Cáp USB-C** (để nạp code và cấp nguồn cho ESP32) - **1 cái**
  - Giá tham khảo: 20,000 - 50,000 VNĐ
- [ ] **Adapter 5V 2A** (cho máy bơm) - **1 cái**
  - Giá tham khảo: 30,000 - 80,000 VNĐ
  - Lưu ý: Nếu máy bơm công suất lớn, cần adapter 5V 3A-5A

---

## 🟡 PHỤ KIỆN BỔ SUNG (Tùy chọn nhưng nên có)

### 8. Phụ Kiện Máy Bơm

- [ ] **Ống dẫn nước** (ống silicon, đường kính 4-6mm) - **1 mét**
  - Giá tham khảo: 10,000 - 30,000 VNĐ
- [ ] **Bình chứa nước nhỏ** (để demo) - **1 cái**
  - Giá tham khảo: 10,000 - 30,000 VNĐ

---

### 9. Phụ Kiện Đèn

- [ ] **Adapter 12V 1A** (cho đèn 12V DC) - **1 cái**
  - Giá tham khảo: 30,000 - 60,000 VNĐ
- [ ] **Dây điện** (để nối đèn với relay) - **1 mét**
  - Giá tham khảo: 5,000 - 15,000 VNĐ

---

### 10. Dụng Cụ & Phụ Kiện Khác

- [ ] **Kìm bấm dây** (tùy chọn) - **1 cái**
  - Giá tham khảo: 30,000 - 80,000 VNĐ
- [ ] **Băng keo điện** - **1 cuộn**
  - Giá tham khảo: 5,000 - 15,000 VNĐ
- [ ] **Multimeter** (để đo điện áp, kiểm tra) - **1 cái**
  - Giá tham khảo: 100,000 - 300,000 VNĐ
  - Lưu ý: Rất hữu ích để debug

---

## 📊 TỔNG KẾT CHI PHÍ

### Chi Phí Tối Thiểu (Bắt Buộc):
- ESP32: 80,000 VNĐ
- DHT11: 15,000 VNĐ
- Soil Sensor: 20,000 VNĐ
- LDR Module: 15,000 VNĐ
- Relay (2 cái): 50,000 VNĐ
- Máy bơm: 30,000 VNĐ
- LED (3 cái): 3,000 VNĐ
- Điện trở (5 cái): 2,500 VNĐ
- Breadboard: 30,000 VNĐ
- Dây jumper: 20,000 VNĐ
- Cáp USB-C: 20,000 VNĐ
- Adapter 5V: 30,000 VNĐ
- **TỔNG: ~315,500 VNĐ**

### Chi Phí Đầy Đủ (Bao gồm phụ kiện):
- Tất cả trên + Phụ kiện: ~500,000 - 800,000 VNĐ

---

## 🛍️ Nơi Mua Hàng

### Online (Việt Nam):
1. **Shopee** - Tìm: "ESP32", "DHT11", "Relay module", "Máy bơm mini 5V"
2. **Lazada** - Tương tự Shopee
3. **Tiki** - Có một số shop linh kiện điện tử
4. **Facebook Marketplace** - Nhiều shop bán linh kiện Arduino/ESP32

### Offline (Nếu ở TP.HCM/Hà Nội):
1. **Chợ Nhật Tảo** (TP.HCM) - Chợ linh kiện điện tử lớn nhất
2. **Phố Điện Biên Phủ** (Hà Nội) - Nhiều shop linh kiện
3. **Các shop Arduino/ESP32** gần trường đại học

---

## ✅ Checklist Mua Hàng

### Nhóm 1: Board & Sensors
- [ ] ESP32 (Type-C, 38 chân)
- [ ] DHT11 Module
- [ ] Soil Moisture Sensor
- [ ] LDR Module

### Nhóm 2: Điều Khiển
- [ ] Relay Module (2 cái)
- [ ] Máy bơm mini 5V
- [ ] Đèn 12V DC (tùy chọn)

### Nhóm 3: LED & Điện Trở
- [ ] LED Xanh, Vàng, Đỏ (mỗi loại 1 cái)
- [ ] Điện trở 10kΩ (2 cái)
- [ ] Điện trở 220Ω (3 cái)

### Nhóm 4: Breadboard & Dây
- [ ] Breadboard lớn
- [ ] Dây jumper (male-to-male)
- [ ] Dây jumper (female-to-male) - Tùy chọn

### Nhóm 5: Nguồn & Cáp
- [ ] Cáp USB-C
- [ ] Adapter 5V 2A (cho máy bơm)
- [ ] Adapter 12V 1A (cho đèn) - Tùy chọn

### Nhóm 6: Phụ Kiện
- [ ] Ống dẫn nước
- [ ] Bình chứa nước
- [ ] Băng keo điện
- [ ] Multimeter - Tùy chọn

---

## 💡 Lưu Ý Khi Mua

### ESP32:
- ✅ Chọn loại có **Type-C** (dễ cắm hơn Micro-USB)
- ✅ Chọn loại **30 chân** (đủ GPIO cho SmartFarm)
- ✅ Kiểm tra có sẵn driver USB-to-Serial không

### Relay:
- ✅ Chọn loại **5V** (tương thích ESP32)
- ✅ Có **optocoupler** (cách ly an toàn)
- ✅ Có **LED báo** (dễ kiểm tra)

### Máy Bơm:
- ✅ **5V DC** (tương thích với relay)
- ✅ Công suất **3-5W** (đủ cho demo)
- ✅ Có thể mua kèm ống dẫn

### Sensors:
- ✅ Nên mua **Module** (đã có sẵn điện trở, dễ lắp)
- ✅ Kiểm tra có **LED báo** (dễ debug)

---

## 🎯 Gợi Ý Mua Theo Gói

### Gói 1: Cơ Bản (Chỉ sensors, chưa có relay/bơm)
- ESP32 + DHT11 + Soil + LDR + LED + Điện trở + Breadboard + Dây
- **~250,000 VNĐ**

### Gói 2: Đầy Đủ (Có relay và máy bơm)
- Tất cả Gói 1 + Relay (2) + Máy bơm + Adapter 5V
- **~350,000 VNĐ**

### Gói 3: Hoàn Chỉnh (Có đèn và phụ kiện)
- Tất cả Gói 2 + Đèn + Adapter 12V + Phụ kiện
- **~500,000 - 800,000 VNĐ**

---

## 📝 Sau Khi Mua

1. **Kiểm tra hàng:**
   - Đếm số lượng
   - Kiểm tra ESP32 có sáng LED khi cắm USB
   - Kiểm tra sensors có LED báo (nếu có)

2. **Lưu trữ:**
   - Để trong hộp kín, tránh ẩm
   - Phân loại theo nhóm để dễ tìm

3. **Bắt đầu lắp ráp:**
   - Theo hướng dẫn trong `HUONG_DAN_LAP_RAP_THEO_HINH.md`

---

**Chúc bạn mua sắm thành công!** 🛒✨

# 🛒 Danh Sách Mua Sắm - SmartFarm ESP32

## 📋 Tổng Quan

Danh sách này bao gồm **TẤT CẢ** linh kiện cần thiết để lắp ráp hệ thống SmartFarm hoàn chỉnh, bao gồm cả relay và máy bơm.

---

## 🔴 PHẦN CỨNG CHÍNH (Bắt Buộc)

### 1. Board Vi Điều Khiển
- [ ] **ESP32 Development Board** (30 chân, Type-C) - **1 cái**
  - Giá tham khảo: 80,000 - 150,000 VNĐ
  - Lưu ý: Chọn loại có Type-C, 30 chân

---

### 2. Cảm Biến (Sensors)

#### 2.1. DHT11 - Cảm biến nhiệt độ, độ ẩm không khí
- [ ] **DHT11 Module** - **1 cái**
  - Giá tham khảo: 15,000 - 30,000 VNĐ
  - Lưu ý: Nên mua module (đã có sẵn điện trở), không mua DHT11 thô

#### 2.2. Soil Moisture Sensor - Cảm biến độ ẩm đất
- [ ] **Soil Moisture Sensor** - **1 cái**
  - Giá tham khảo: 20,000 - 40,000 VNĐ
  - Lưu ý: Có 3 dây (VCC đỏ, GND đen, A0 vàng/xanh)

#### 2.3. LDR - Cảm biến ánh sáng
- [ ] **LDR Module** (có LED báo) - **1 cái**
  - Giá tham khảo: 15,000 - 30,000 VNĐ
  - Lưu ý: Nên mua module (có biến trở điều chỉnh), không mua LDR thô

---

### 3. Điều Khiển (Actuators)

#### 3.1. Relay Module
- [ ] **Relay Module 2 kênh** (hoặc 2 module 1 kênh) - **2 cái**
  - Giá tham khảo: 25,000 - 50,000 VNĐ/cái
  - Tổng: 50,000 - 100,000 VNĐ
  - Lưu ý: 
    - 1 relay cho máy bơm
    - 1 relay cho đèn
    - Nên mua loại 5V, có optocoupler cách ly

#### 3.2. Máy Bơm
- [ ] **Máy bơm mini 5V DC** - **1 cái**
  - Giá tham khảo: 30,000 - 80,000 VNĐ
  - Lưu ý: 
    - Công suất: 3-5W
    - Điện áp: 5V DC
    - Có thể mua kèm ống dẫn nước

#### 3.3. Đèn (Tùy chọn)
- [ ] **Đèn LED 12V DC** (hoặc đèn 220V AC nếu có kinh nghiệm) - **1 cái**
  - Giá tham khảo: 20,000 - 50,000 VNĐ
  - Lưu ý: 
    - Nên dùng đèn 12V DC (an toàn hơn)
    - Nếu dùng 220V AC: CẦN CẨN THẬN, chỉ lắp nếu có kinh nghiệm

---

### 4. LED Báo Trạng Thái

- [ ] **LED Xanh** (5mm) - **1 cái**
- [ ] **LED Vàng** (5mm) - **1 cái**
- [ ] **LED Đỏ** (5mm) - **1 cái**
- Giá tham khảo: 1,000 - 3,000 VNĐ/cái
- Tổng: 3,000 - 9,000 VNĐ

---

### 5. Điện Trở (Resistors)

- [ ] **Điện trở 10kΩ** (1/4W) - **2 cái**
  - 1 cái cho DHT11 (pull-up)
  - 1 cái cho LDR (nếu dùng LDR thô, không cần nếu dùng LDR Module)
- [ ] **Điện trở 220Ω** (1/4W) - **3 cái**
  - 1 cái cho LED Xanh
  - 1 cái cho LED Vàng
  - 1 cái cho LED Đỏ
- Giá tham khảo: 500 - 2,000 VNĐ/cái
- Tổng: 2,500 - 10,000 VNĐ

---

### 6. Breadboard & Dây Nối

- [ ] **Breadboard lớn** (830 lỗ) - **1 cái**
  - Giá tham khảo: 30,000 - 60,000 VNĐ
- [ ] **Breadboard nhỏ** (400 lỗ) - **1 cái** (tùy chọn)
  - Giá tham khảo: 15,000 - 30,000 VNĐ
- [ ] **Dây jumper** (male-to-male) - **1 bộ** (40-65 dây)
  - Giá tham khảo: 20,000 - 40,000 VNĐ
- [ ] **Dây jumper** (female-to-male) - **1 bộ** (40 dây) - Tùy chọn
  - Giá tham khảo: 20,000 - 40,000 VNĐ

---

### 7. Nguồn & Cáp

- [ ] **Cáp USB-C** (để nạp code và cấp nguồn cho ESP32) - **1 cái**
  - Giá tham khảo: 20,000 - 50,000 VNĐ
- [ ] **Adapter 5V 2A** (cho máy bơm) - **1 cái**
  - Giá tham khảo: 30,000 - 80,000 VNĐ
  - Lưu ý: Nếu máy bơm công suất lớn, cần adapter 5V 3A-5A

---

## 🟡 PHỤ KIỆN BỔ SUNG (Tùy chọn nhưng nên có)

### 8. Phụ Kiện Máy Bơm

- [ ] **Ống dẫn nước** (ống silicon, đường kính 4-6mm) - **1 mét**
  - Giá tham khảo: 10,000 - 30,000 VNĐ
- [ ] **Bình chứa nước nhỏ** (để demo) - **1 cái**
  - Giá tham khảo: 10,000 - 30,000 VNĐ

---

### 9. Phụ Kiện Đèn

- [ ] **Adapter 12V 1A** (cho đèn 12V DC) - **1 cái**
  - Giá tham khảo: 30,000 - 60,000 VNĐ
- [ ] **Dây điện** (để nối đèn với relay) - **1 mét**
  - Giá tham khảo: 5,000 - 15,000 VNĐ

---

### 10. Dụng Cụ & Phụ Kiện Khác

- [ ] **Kìm bấm dây** (tùy chọn) - **1 cái**
  - Giá tham khảo: 30,000 - 80,000 VNĐ
- [ ] **Băng keo điện** - **1 cuộn**
  - Giá tham khảo: 5,000 - 15,000 VNĐ
- [ ] **Multimeter** (để đo điện áp, kiểm tra) - **1 cái**
  - Giá tham khảo: 100,000 - 300,000 VNĐ
  - Lưu ý: Rất hữu ích để debug

---

## 📊 TỔNG KẾT CHI PHÍ

### Chi Phí Tối Thiểu (Bắt Buộc):
- ESP32: 80,000 VNĐ
- DHT11: 15,000 VNĐ
- Soil Sensor: 20,000 VNĐ
- LDR Module: 15,000 VNĐ
- Relay (2 cái): 50,000 VNĐ
- Máy bơm: 30,000 VNĐ
- LED (3 cái): 3,000 VNĐ
- Điện trở (5 cái): 2,500 VNĐ
- Breadboard: 30,000 VNĐ
- Dây jumper: 20,000 VNĐ
- Cáp USB-C: 20,000 VNĐ
- Adapter 5V: 30,000 VNĐ
- **TỔNG: ~315,500 VNĐ**

### Chi Phí Đầy Đủ (Bao gồm phụ kiện):
- Tất cả trên + Phụ kiện: ~500,000 - 800,000 VNĐ

---

## 🛍️ Nơi Mua Hàng

### Online (Việt Nam):
1. **Shopee** - Tìm: "ESP32", "DHT11", "Relay module", "Máy bơm mini 5V"
2. **Lazada** - Tương tự Shopee
3. **Tiki** - Có một số shop linh kiện điện tử
4. **Facebook Marketplace** - Nhiều shop bán linh kiện Arduino/ESP32

### Offline (Nếu ở TP.HCM/Hà Nội):
1. **Chợ Nhật Tảo** (TP.HCM) - Chợ linh kiện điện tử lớn nhất
2. **Phố Điện Biên Phủ** (Hà Nội) - Nhiều shop linh kiện
3. **Các shop Arduino/ESP32** gần trường đại học

---

## ✅ Checklist Mua Hàng

### Nhóm 1: Board & Sensors
- [ ] ESP32 (Type-C, 38 chân)
- [ ] DHT11 Module
- [ ] Soil Moisture Sensor
- [ ] LDR Module

### Nhóm 2: Điều Khiển
- [ ] Relay Module (2 cái)
- [ ] Máy bơm mini 5V
- [ ] Đèn 12V DC (tùy chọn)

### Nhóm 3: LED & Điện Trở
- [ ] LED Xanh, Vàng, Đỏ (mỗi loại 1 cái)
- [ ] Điện trở 10kΩ (2 cái)
- [ ] Điện trở 220Ω (3 cái)

### Nhóm 4: Breadboard & Dây
- [ ] Breadboard lớn
- [ ] Dây jumper (male-to-male)
- [ ] Dây jumper (female-to-male) - Tùy chọn

### Nhóm 5: Nguồn & Cáp
- [ ] Cáp USB-C
- [ ] Adapter 5V 2A (cho máy bơm)
- [ ] Adapter 12V 1A (cho đèn) - Tùy chọn

### Nhóm 6: Phụ Kiện
- [ ] Ống dẫn nước
- [ ] Bình chứa nước
- [ ] Băng keo điện
- [ ] Multimeter - Tùy chọn

---

## 💡 Lưu Ý Khi Mua

### ESP32:
- ✅ Chọn loại có **Type-C** (dễ cắm hơn Micro-USB)
- ✅ Chọn loại **30 chân** (đủ GPIO cho SmartFarm)
- ✅ Kiểm tra có sẵn driver USB-to-Serial không

### Relay:
- ✅ Chọn loại **5V** (tương thích ESP32)
- ✅ Có **optocoupler** (cách ly an toàn)
- ✅ Có **LED báo** (dễ kiểm tra)

### Máy Bơm:
- ✅ **5V DC** (tương thích với relay)
- ✅ Công suất **3-5W** (đủ cho demo)
- ✅ Có thể mua kèm ống dẫn

### Sensors:
- ✅ Nên mua **Module** (đã có sẵn điện trở, dễ lắp)
- ✅ Kiểm tra có **LED báo** (dễ debug)

---

## 🎯 Gợi Ý Mua Theo Gói

### Gói 1: Cơ Bản (Chỉ sensors, chưa có relay/bơm)
- ESP32 + DHT11 + Soil + LDR + LED + Điện trở + Breadboard + Dây
- **~250,000 VNĐ**

### Gói 2: Đầy Đủ (Có relay và máy bơm)
- Tất cả Gói 1 + Relay (2) + Máy bơm + Adapter 5V
- **~350,000 VNĐ**

### Gói 3: Hoàn Chỉnh (Có đèn và phụ kiện)
- Tất cả Gói 2 + Đèn + Adapter 12V + Phụ kiện
- **~500,000 - 800,000 VNĐ**

---

## 📝 Sau Khi Mua

1. **Kiểm tra hàng:**
   - Đếm số lượng
   - Kiểm tra ESP32 có sáng LED khi cắm USB
   - Kiểm tra sensors có LED báo (nếu có)

2. **Lưu trữ:**
   - Để trong hộp kín, tránh ẩm
   - Phân loại theo nhóm để dễ tìm

3. **Bắt đầu lắp ráp:**
   - Theo hướng dẫn trong `HUONG_DAN_LAP_RAP_THEO_HINH.md`

---

**Chúc bạn mua sắm thành công!** 🛒✨


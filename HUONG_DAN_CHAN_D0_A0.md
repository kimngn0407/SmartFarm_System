# 🔌 Hướng Dẫn Nối Chân D0 và A0

## 📋 Tổng Quan

Bạn hỏi về:
1. **Chân D0 của cảm biến đất** nối vào đâu
2. **Chân A0 của cảm biến ánh sáng** nối vào đâu

---

## 🔴 Cảm Biến Độ Ẩm Đất (Soil Moisture Sensor)

### Các Chân Của Soil Sensor:
- **VCC** (đỏ) - Nguồn dương
- **GND** (đen) - Nguồn âm
- **A0** (vàng/xanh) - Tín hiệu analog (0-4095) ✅ **ĐANG DÙNG**
- **D0** (có thể có) - Tín hiệu digital (HIGH/LOW) ⚠️ **TÙY CHỌN**

### Cách Nối:

#### Chân A0 (Đang dùng - Bắt buộc):
```
Soil Sensor A0 ────> ESP32 D2 (GPIO2)
```
- ✅ **Đang dùng** trong code
- Đọc giá trị chính xác (0-4095)
- Map thành % độ ẩm đất

#### Chân D0 (Tùy chọn - Không bắt buộc):
```
Soil Sensor D0 ────> ESP32 D15 (GPIO15) - HOẶC GPIO khác
```
- ⚠️ **Không bắt buộc** - Chỉ báo HIGH/LOW
- Chỉ báo có/không, không có giá trị chính xác
- **Có thể bỏ qua** nếu đã dùng A0

**Lưu ý:**
- Nếu chỉ cần biết đất khô/ướt → Dùng D0
- Nếu cần giá trị chính xác → Dùng A0 (khuyến nghị)
- Code hiện tại dùng **A0 (GPIO2)**, không cần D0

---

## 🔴 Cảm Biến Ánh Sáng (LDR Module)

### Các Chân Của LDR Module:
- **VCC** - Nguồn dương
- **GND** - Nguồn âm
- **D0** (hoặc OUT) - Tín hiệu digital (HIGH/LOW) ✅ **ĐANG DÙNG**
- **A0** (có thể có) - Tín hiệu analog ⚠️ **TÙY CHỌN**

### Cách Nối:

#### Chân D0 (Đang dùng - Bắt buộc):
```
LDR Module D0 (OUT) ────> ESP32 D5 (GPIO5)
```
- ✅ **Đang dùng** trong code
- HIGH = sáng, LOW = tối
- Code đọc digital và tính % độ sáng

#### Chân A0 (Tùy chọn - Nếu LDR có A0):
```
LDR Module A0 ────> ESP32 D15 (GPIO15) - HOẶC GPIO khác có ADC
```
- ⚠️ **Tùy chọn** - Chỉ nếu LDR Module có chân A0
- Đọc giá trị analog (0-4095)
- **Nếu dùng A0:** Cần sửa code từ `digitalRead()` → `analogRead()`

**Lưu ý:**
- Code hiện tại dùng **D0 (GPIO5)**, không cần A0
- Nếu LDR Module không có A0 → Bỏ qua
- Nếu muốn đọc analog chính xác hơn → Dùng A0

---

## 📊 Tổng Kết Kết Nối

### Đang Dùng (Bắt Buộc):
```
Soil Sensor A0 ────> ESP32 D2 (GPIO2) ✅
LDR Module D0 ────> ESP32 D5 (GPIO5) ✅
```

### Tùy Chọn (Không Bắt Buộc):
```
Soil Sensor D0 ────> ESP32 D15 (GPIO15) - HOẶC GPIO khác ⚠️
LDR Module A0 ────> ESP32 D15 (GPIO15) - HOẶC GPIO khác có ADC ⚠️
```

---

## ✅ Checklist Kết Nối

### Bắt Buộc:
- [x] Soil Sensor A0 → ESP32 D2 (GPIO2)
- [x] LDR Module D0 → ESP32 D5 (GPIO5)

### Tùy Chọn:
- [ ] Soil Sensor D0 → ESP32 D15 (GPIO15) - **KHÔNG CẦN** nếu đã dùng A0
- [ ] LDR Module A0 → ESP32 D15 (GPIO15) - **KHÔNG CẦN** nếu đã dùng D0

---

## 💡 Khuyến Nghị

### Nếu Chỉ Có 1 Chân:
- **Soil Sensor:** Dùng **A0** (cho giá trị chính xác)
- **LDR Module:** Dùng **D0** (đủ cho digital output)

### Nếu Có Cả 2 Chân:
- **Soil Sensor:** Dùng **A0** (bỏ qua D0)
- **LDR Module:** Dùng **D0** (bỏ qua A0 nếu không cần analog)

---

## 🎯 Kết Luận

**Bạn KHÔNG CẦN nối:**
- ❌ Soil Sensor D0 → Không cần (đã có A0)
- ❌ LDR Module A0 → Không cần (đã có D0)

**Chỉ cần nối:**
- ✅ Soil Sensor A0 → ESP32 D2 (GPIO2)
- ✅ LDR Module D0 → ESP32 D5 (GPIO5)

---

**Code đã được cập nhật để bỏ relay đèn và dùng LED để báo trạng thái ánh sáng!** 💡✨

# 🔌 Hướng Dẫn Nối Chân D0 và A0

## 📋 Tổng Quan

Bạn hỏi về:
1. **Chân D0 của cảm biến đất** nối vào đâu
2. **Chân A0 của cảm biến ánh sáng** nối vào đâu

---

## 🔴 Cảm Biến Độ Ẩm Đất (Soil Moisture Sensor)

### Các Chân Của Soil Sensor:
- **VCC** (đỏ) - Nguồn dương
- **GND** (đen) - Nguồn âm
- **A0** (vàng/xanh) - Tín hiệu analog (0-4095) ✅ **ĐANG DÙNG**
- **D0** (có thể có) - Tín hiệu digital (HIGH/LOW) ⚠️ **TÙY CHỌN**

### Cách Nối:

#### Chân A0 (Đang dùng - Bắt buộc):
```
Soil Sensor A0 ────> ESP32 D2 (GPIO2)
```
- ✅ **Đang dùng** trong code
- Đọc giá trị chính xác (0-4095)
- Map thành % độ ẩm đất

#### Chân D0 (Tùy chọn - Không bắt buộc):
```
Soil Sensor D0 ────> ESP32 D15 (GPIO15) - HOẶC GPIO khác
```
- ⚠️ **Không bắt buộc** - Chỉ báo HIGH/LOW
- Chỉ báo có/không, không có giá trị chính xác
- **Có thể bỏ qua** nếu đã dùng A0

**Lưu ý:**
- Nếu chỉ cần biết đất khô/ướt → Dùng D0
- Nếu cần giá trị chính xác → Dùng A0 (khuyến nghị)
- Code hiện tại dùng **A0 (GPIO2)**, không cần D0

---

## 🔴 Cảm Biến Ánh Sáng (LDR Module)

### Các Chân Của LDR Module:
- **VCC** - Nguồn dương
- **GND** - Nguồn âm
- **D0** (hoặc OUT) - Tín hiệu digital (HIGH/LOW) ✅ **ĐANG DÙNG**
- **A0** (có thể có) - Tín hiệu analog ⚠️ **TÙY CHỌN**

### Cách Nối:

#### Chân D0 (Đang dùng - Bắt buộc):
```
LDR Module D0 (OUT) ────> ESP32 D5 (GPIO5)
```
- ✅ **Đang dùng** trong code
- HIGH = sáng, LOW = tối
- Code đọc digital và tính % độ sáng

#### Chân A0 (Tùy chọn - Nếu LDR có A0):
```
LDR Module A0 ────> ESP32 D15 (GPIO15) - HOẶC GPIO khác có ADC
```
- ⚠️ **Tùy chọn** - Chỉ nếu LDR Module có chân A0
- Đọc giá trị analog (0-4095)
- **Nếu dùng A0:** Cần sửa code từ `digitalRead()` → `analogRead()`

**Lưu ý:**
- Code hiện tại dùng **D0 (GPIO5)**, không cần A0
- Nếu LDR Module không có A0 → Bỏ qua
- Nếu muốn đọc analog chính xác hơn → Dùng A0

---

## 📊 Tổng Kết Kết Nối

### Đang Dùng (Bắt Buộc):
```
Soil Sensor A0 ────> ESP32 D2 (GPIO2) ✅
LDR Module D0 ────> ESP32 D5 (GPIO5) ✅
```

### Tùy Chọn (Không Bắt Buộc):
```
Soil Sensor D0 ────> ESP32 D15 (GPIO15) - HOẶC GPIO khác ⚠️
LDR Module A0 ────> ESP32 D15 (GPIO15) - HOẶC GPIO khác có ADC ⚠️
```

---

## ✅ Checklist Kết Nối

### Bắt Buộc:
- [x] Soil Sensor A0 → ESP32 D2 (GPIO2)
- [x] LDR Module D0 → ESP32 D5 (GPIO5)

### Tùy Chọn:
- [ ] Soil Sensor D0 → ESP32 D15 (GPIO15) - **KHÔNG CẦN** nếu đã dùng A0
- [ ] LDR Module A0 → ESP32 D15 (GPIO15) - **KHÔNG CẦN** nếu đã dùng D0

---

## 💡 Khuyến Nghị

### Nếu Chỉ Có 1 Chân:
- **Soil Sensor:** Dùng **A0** (cho giá trị chính xác)
- **LDR Module:** Dùng **D0** (đủ cho digital output)

### Nếu Có Cả 2 Chân:
- **Soil Sensor:** Dùng **A0** (bỏ qua D0)
- **LDR Module:** Dùng **D0** (bỏ qua A0 nếu không cần analog)

---

## 🎯 Kết Luận

**Bạn KHÔNG CẦN nối:**
- ❌ Soil Sensor D0 → Không cần (đã có A0)
- ❌ LDR Module A0 → Không cần (đã có D0)

**Chỉ cần nối:**
- ✅ Soil Sensor A0 → ESP32 D2 (GPIO2)
- ✅ LDR Module D0 → ESP32 D5 (GPIO5)

---

**Code đã được cập nhật để bỏ relay đèn và dùng LED để báo trạng thái ánh sáng!** 💡✨


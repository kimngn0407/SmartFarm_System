# 💧 Cách Nhận Biết Máy Bơm Đang Bật

## 🔍 Các Cách Nhận Biết Máy Bơm Đang Bật

Có nhiều cách để biết máy bơm đang bật:

---

## ✅ Cách 1: Nhìn Trên Relay Module (Dễ Nhất!)

### Relay Module Thường Có:
- **LED Indicator** (đèn báo) trên module
- **Khi relay BẬT:** LED sáng (thường màu đỏ hoặc xanh)
- **Khi relay TẮT:** LED tắt

### Cách Kiểm Tra:
1. **Nhìn vào Relay Module** (GPIO18)
2. **Nếu LED sáng:** Máy bơm đang BẬT ✅
3. **Nếu LED tắt:** Máy bơm đang TẮT ❌

---

## ✅ Cách 2: Nhìn Trên Serial Monitor

### Trong Serial Monitor, bạn sẽ thấy:

**Khi máy bơm BẬT:**
```
💧 Máy bơm BẬT
```

**Khi máy bơm TẮT:**
```
💧 Máy bơm TẮT
✅ Đã tưới xong
```

### Hoặc trong JSON output:
- Không còn hiển thị `"pump"` nữa (đã xóa)
- Nhưng vẫn có thông báo riêng

---

## ✅ Cách 3: Nhìn Qua Cảm Biến Độ Ẩm Đất

### Khi Máy Bơm BẬT:
- **Độ ẩm đất sẽ TĂNG** dần
- Trong Serial Monitor, giá trị `"soil"` sẽ tăng từ thấp lên cao

### Ví dụ:
```
{"soil":30}  → Máy bơm BẬT
{"soil":35}  → Đang tưới...
{"soil":45}  → Đang tưới...
{"soil":55}  → Đang tưới...
{"soil":60}  → Máy bơm TẮT (sau 5 giây)
```

---

## ✅ Cách 4: Thêm LED Báo Trạng Thái (Tùy Chọn)

### Có thể dùng LED đỏ để báo máy bơm đang chạy:

**Trong code, thêm:**
```cpp
void updateLED(float temperature, float humidity) {
  // ...
  
  if (pumpRunning) {
    // Đang tưới - LED đỏ nhấp nháy
    digitalWrite(LED_RED, (millis() / 200) % 2);
    return;
  }
  
  // Logic LED khác...
}
```

**Hiện tại code đã có logic này!** ✅
- Khi máy bơm chạy → LED đỏ nhấp nháy
- Dễ nhận biết bằng mắt

---

## ✅ Cách 5: Nghe Tiếng Máy Bơm

### Nếu máy bơm thật đang chạy:
- **Có tiếng kêu** từ máy bơm
- **Có nước chảy** (nếu có hệ thống tưới)

---

## 🎯 Tóm Tắt - Cách Nhận Biết Nhanh

### 1. **Nhìn Relay Module** (Dễ nhất!)
   - LED sáng = Máy bơm BẬT ✅
   - LED tắt = Máy bơm TẮT ❌

### 2. **Nhìn LED Đỏ trên ESP32**
   - LED đỏ nhấp nháy = Máy bơm đang chạy ✅
   - LED đỏ tắt = Máy bơm TẮT ❌

### 3. **Xem Serial Monitor**
   - Thông báo: `💧 Máy bơm BẬT` = Đang chạy ✅
   - Thông báo: `💧 Máy bơm TẮT` = Đã tắt ❌

### 4. **Xem Độ Ẩm Đất**
   - Giá trị `"soil"` tăng = Đang tưới ✅
   - Giá trị `"soil"` ổn định = Không tưới ❌

---

## 💡 Lưu Ý

**Thời gian máy bơm chạy:**
- Mặc định: **5 giây** (`PUMP_DURATION = 5000`)
- Sau đó tự động TẮT

**Thời gian chờ giữa các lần tưới:**
- Mặc định: **60 giây** (`PUMP_COOLDOWN = 60000`)
- Không tưới liên tục để tránh quá tải

**Điều kiện bật máy bơm:**
- Độ ẩm đất < `SOIL_MIN` (30%) → BẬT
- Độ ẩm đất > `SOIL_MAX` (70%) → BẬT
- Độ ẩm đất trong khoảng [30%, 70%] → TẮT

---

## 🔧 Nếu Muốn Thêm LED Báo Riêng Cho Máy Bơm

Có thể thêm LED riêng (nếu có GPIO trống):

```cpp
#define LED_PUMP 19  // LED báo máy bơm (GPIO19)

// Trong setup():
pinMode(LED_PUMP, OUTPUT);

// Trong setPump():
void setPump(bool on) {
  digitalWrite(RELAY_PUMP, on ? HIGH : LOW);
  digitalWrite(LED_PUMP, on ? HIGH : LOW);  // LED báo
  pumpRunning = on;
  // ...
}
```

---

**Cách dễ nhất: Nhìn LED trên Relay Module hoặc LED đỏ nhấp nháy trên ESP32!** 💧✨



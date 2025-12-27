# ⚙️ Hướng Dẫn Cấu Hình Ngưỡng - DEMO MODE

## 📋 Tổng Quan

Code đã được cập nhật với logic DEMO linh hoạt, cho phép thay đổi ngưỡng dễ dàng khi demo.

---

## 🔧 Cấu Hình Ngưỡng

### 1. Độ Ẩm Đất (Soil Moisture)

```cpp
const int SOIL_MIN = 30;      // Ngưỡng tối thiểu (%)
const int SOIL_MAX = 70;      // Ngưỡng tối đa (%)
```

**Logic:**
- ✅ **Relay KHÔNG bật:** Khi đất nằm trong khoảng `[SOIL_MIN, SOIL_MAX]`
- 🔴 **Relay BẬT:** Khi đất < `SOIL_MIN` hoặc > `SOIL_MAX`

**Ví dụ:**
- Nếu `SOIL_MIN = 30`, `SOIL_MAX = 70`:
  - Đất = 50% → ✅ Relay KHÔNG bật
  - Đất = 25% → 🔴 Relay BẬT (vì < 30%)
  - Đất = 75% → 🔴 Relay BẬT (vì > 70%)

---

### 2. Nhiệt Độ Không Khí (Temperature)

```cpp
const float TEMP_MIN = 20.0;  // Nhiệt độ tối thiểu (°C)
const float TEMP_MAX = 30.0;  // Nhiệt độ tối đa (°C)
const float TEMP_WARNING_PERCENT = 10.0; // 10% để tính LED Vàng
```

**Logic LED:**
- 🟢 **LED Xanh:** Nhiệt độ nằm trong `[TEMP_MIN, TEMP_MAX]`
- 🟡 **LED Vàng:** Nhiệt độ vượt/thấp hơn khoảng **10%** so với ngưỡng
- 🔴 **LED Đỏ:** Nhiệt độ vượt/thấp quá ngưỡng

**Công thức tính LED Vàng:**
```
TEMP_WARNING_LOW = TEMP_MIN - (TEMP_MAX - TEMP_MIN) * 10%
TEMP_WARNING_HIGH = TEMP_MAX + (TEMP_MAX - TEMP_MIN) * 10%
```

**Ví dụ với TEMP_MIN = 20, TEMP_MAX = 30:**
- Nhiệt độ = 25°C → 🟢 LED Xanh (trong ngưỡng 20-30)
- Nhiệt độ = 19°C → 🟡 LED Vàng (thấp hơn 10% = 19-21)
- Nhiệt độ = 31°C → 🟡 LED Vàng (cao hơn 10% = 29-31)
- Nhiệt độ = 15°C → 🔴 LED Đỏ (thấp quá < 19)
- Nhiệt độ = 35°C → 🔴 LED Đỏ (cao quá > 31)

---

### 3. Độ Ẩm Không Khí (Humidity)

```cpp
const float HUMIDITY_MIN = 40.0;  // Độ ẩm tối thiểu (%)
const float HUMIDITY_MAX = 70.0;   // Độ ẩm tối đa (%)
const float HUMIDITY_WARNING_PERCENT = 10.0; // 10% để tính LED Vàng
```

**Logic LED:**
- 🟢 **LED Xanh:** Độ ẩm nằm trong `[HUMIDITY_MIN, HUMIDITY_MAX]`
- 🟡 **LED Vàng:** Độ ẩm vượt/thấp hơn khoảng **10%** so với ngưỡng
- 🔴 **LED Đỏ:** Độ ẩm vượt/thấp quá ngưỡng

**Công thức tính LED Vàng:**
```
HUMIDITY_WARNING_LOW = HUMIDITY_MIN - (HUMIDITY_MAX - HUMIDITY_MIN) * 10%
HUMIDITY_WARNING_HIGH = HUMIDITY_MAX + (HUMIDITY_MAX - HUMIDITY_MIN) * 10%
```

**Ví dụ với HUMIDITY_MIN = 40, HUMIDITY_MAX = 70:**
- Độ ẩm = 55% → 🟢 LED Xanh (trong ngưỡng 40-70)
- Độ ẩm = 37% → 🟡 LED Vàng (thấp hơn 10% = 37-40)
- Độ ẩm = 73% → 🟡 LED Vàng (cao hơn 10% = 70-73)
- Độ ẩm = 30% → 🔴 LED Đỏ (thấp quá < 37)
- Độ ẩm = 80% → 🔴 LED Đỏ (cao quá > 73)

---

## 🎯 Logic LED Tổng Hợp

LED sẽ hiển thị trạng thái **xấu nhất** giữa Nhiệt độ và Độ ẩm không khí:

- 🟢 **LED Xanh:** Cả nhiệt độ VÀ độ ẩm đều trong ngưỡng
- 🟡 **LED Vàng:** Một trong 2 (nhiệt độ hoặc độ ẩm) trong vùng cảnh báo (10%)
- 🔴 **LED Đỏ:** Một trong 2 (nhiệt độ hoặc độ ẩm) vượt quá ngưỡng
- 🔴 **LED Đỏ nhấp nháy:** Đang tưới nước

---

## 📝 Cách Thay Đổi Ngưỡng Khi Demo

### Bước 1: Mở file `Arduino_SmartFarm_Demo.ino`

### Bước 2: Tìm phần cấu hình (khoảng dòng 58-75)

```cpp
// ================== Cấu hình Tự động hóa - DEMO ==================
// ⚙️ CÓ THỂ THAY ĐỔI LINH HOẠT KHI DEMO

// Độ ẩm đất
const int SOIL_MIN = 30;      // Thay đổi giá trị này
const int SOIL_MAX = 70;      // Thay đổi giá trị này

// Nhiệt độ
const float TEMP_MIN = 20.0;  // Thay đổi giá trị này
const float TEMP_MAX = 30.0;  // Thay đổi giá trị này

// Độ ẩm không khí
const float HUMIDITY_MIN = 40.0;  // Thay đổi giá trị này
const float HUMIDITY_MAX = 70.0;   // Thay đổi giá trị này
```

### Bước 3: Thay đổi giá trị theo nhu cầu demo

**Ví dụ:**
```cpp
// Demo cho cây ưa ẩm
const int SOIL_MIN = 50;
const int SOIL_MAX = 80;

// Demo cho nhiệt độ mát
const float TEMP_MIN = 18.0;
const float TEMP_MAX = 25.0;

// Demo cho độ ẩm cao
const float HUMIDITY_MIN = 60.0;
const float HUMIDITY_MAX = 85.0;
```

### Bước 4: Upload lại code lên ESP32

---

## 📊 Ví Dụ Demo Scenarios

### Scenario 1: Cây Ưa Ẩm, Nhiệt Độ Mát
```cpp
const int SOIL_MIN = 50;
const int SOIL_MAX = 80;
const float TEMP_MIN = 23.0;
const float TEMP_MAX = 25.0;
const float HUMIDITY_MIN = 40.0;
const float HUMIDITY_MAX = 50.0;
```

### Scenario 2: Cây Chịu Khô, Nhiệt Độ Ấm
```cpp
const int SOIL_MIN = 20;
const int SOIL_MAX = 60;
const float TEMP_MIN = 25.0;
const float TEMP_MAX = 35.0;
const float HUMIDITY_MIN = 30.0;
const float HUMIDITY_MAX = 60.0;
```

### Scenario 3: Cây Trung Bình
```cpp
const int SOIL_MIN = 30;
const int SOIL_MAX = 70;
const float TEMP_MIN = 20.0;
const float TEMP_MAX = 30.0;
const float HUMIDITY_MIN = 40.0;
const float HUMIDITY_MAX = 70.0;
```

---

## ✅ Checklist Khi Demo

- [ ] Đã cấu hình ngưỡng phù hợp với loại cây
- [ ] Đã upload code mới lên ESP32
- [ ] Đã kiểm tra Serial Monitor để xem giá trị đọc được
- [ ] Đã test logic relay (bật/tắt khi đất ngoài ngưỡng)
- [ ] Đã test logic LED (xanh/vàng/đỏ theo nhiệt độ và độ ẩm)
- [ ] Đã ghi chú lại ngưỡng đang dùng để demo

---

**Chúc bạn demo thành công!** 🎉✨


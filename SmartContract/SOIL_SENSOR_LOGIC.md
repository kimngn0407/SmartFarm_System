# 🌱 Logic Cảm biến Độ ẩm Đất (Soil Moisture Sensor)

## 📊 Vấn đề

**Input từ Arduino:**
```json
{
  "soil_raw": 1023,
  "soil_pct": 0
}
```

**Câu hỏi:** Tại sao `soil_raw = 1023` nhưng `soil_pct = 0`?

---

## 🔍 Giải thích Logic

### Cảm biến độ ẩm đất hoạt động như thế nào?

**Nguyên lý:**
- **Đất KHÔ** → Điện trở CAO → `soil_raw` CAO (gần 1023)
- **Đất ƯỚT** → Điện trở THẤP → `soil_raw` THẤP (gần 0)

**Vậy:**
- `soil_raw = 1023` → Đất RẤT KHÔ → `soil_pct = 0%` ✅ **ĐÚNG!**
- `soil_raw = 0` → Đất RẤT ƯỚT → `soil_pct = 100%` ✅ **ĐÚNG!**

---

## 📐 Công thức Mapping Thông thường

### Cách 1: Map trực tiếp (đảo ngược)

```cpp
// Arduino code
int soil_raw = analogRead(SOIL_PIN);  // 0-1023
int soil_pct = map(soil_raw, 1023, 0, 0, 100);  // Đảo ngược: 1023→0%, 0→100%
```

**Kết quả:**
- `soil_raw = 1023` → `soil_pct = 0%` ✅
- `soil_raw = 0` → `soil_pct = 100%` ✅

### Cách 2: Tính toán thủ công

```cpp
// Arduino code
int soil_raw = analogRead(SOIL_PIN);  // 0-1023
int soil_pct = 100 - (soil_raw * 100 / 1023);  // Đảo ngược
```

**Kết quả:**
- `soil_raw = 1023` → `soil_pct = 100 - (1023 * 100 / 1023) = 100 - 100 = 0%` ✅
- `soil_raw = 0` → `soil_pct = 100 - (0 * 100 / 1023) = 100 - 0 = 100%` ✅

---

## ✅ Kết luận

**Logic hiện tại là ĐÚNG:**
- `soil_raw = 1023` → Đất RẤT KHÔ → `soil_pct = 0%` ✅
- Đây là cách hoạt động bình thường của cảm biến độ ẩm đất!

---

## 🔧 Nếu muốn đảo ngược logic

**Nếu bạn muốn:**
- `soil_raw = 1023` → `soil_pct = 100%` (đất ướt)
- `soil_raw = 0` → `soil_pct = 0%` (đất khô)

**Thì sửa code Arduino:**

```cpp
// Thay vì:
int soil_pct = map(soil_raw, 1023, 0, 0, 100);  // Đảo ngược

// Dùng:
int soil_pct = map(soil_raw, 0, 1023, 0, 100);  // Không đảo ngược
```

**HOẶC:**

```cpp
// Thay vì:
int soil_pct = 100 - (soil_raw * 100 / 1023);  // Đảo ngược

// Dùng:
int soil_pct = soil_raw * 100 / 1023;  // Không đảo ngược
```

---

## 🎯 Khuyến nghị

**Logic hiện tại là ĐÚNG và PHỔ BIẾN:**
- Hầu hết cảm biến độ ẩm đất hoạt động theo cách này
- `soil_raw = 1023` = Đất khô = `soil_pct = 0%` ✅
- `soil_raw = 0` = Đất ướt = `soil_pct = 100%` ✅

**KHÔNG CẦN SỬA** nếu đây là cách bạn muốn hiển thị!

---

## 📊 Ví dụ thực tế

| soil_raw | soil_pct | Ý nghĩa |
|----------|----------|---------|
| 1023 | 0% | Đất RẤT KHÔ |
| 800 | ~22% | Đất KHÔ |
| 500 | ~51% | Đất VỪA |
| 200 | ~80% | Đất ƯỚT |
| 0 | 100% | Đất RẤT ƯỚT |

---

## 🔍 Kiểm tra Code Arduino

Nếu bạn muốn xác nhận logic trên Arduino, kiểm tra:

```cpp
// Tìm dòng code tính toán soil_pct
int soil_pct = ...;

// Phải có một trong các công thức:
// 1. map(soil_raw, 1023, 0, 0, 100)  ← Đảo ngược (phổ biến)
// 2. 100 - (soil_raw * 100 / 1023)   ← Đảo ngược (phổ biến)
// 3. map(soil_raw, 0, 1023, 0, 100)   ← Không đảo ngược
// 4. soil_raw * 100 / 1023            ← Không đảo ngược
```

---

## ✅ Tóm tắt

**Câu trả lời:** 
- `soil_raw = 1023` → `soil_pct = 0%` là **ĐÚNG**!
- Đây là logic bình thường của cảm biến độ ẩm đất
- `soil_raw` CAO = Đất KHÔ = `soil_pct` THẤP
- `soil_raw` THẤP = Đất ƯỚT = `soil_pct` CAO

**KHÔNG CẦN SỬA** nếu đây là cách bạn muốn hiển thị!


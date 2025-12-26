# 🔧 Fix Logic Relay Cho Chân NC (Normally Closed)

## 🔍 Vấn Đề

**Máy bơm luôn quay khi dùng chân NC (Normally Closed) của relay.**

**Nguyên nhân:**
- Chân NC đóng (connected) khi relay OFF (LOW)
- Chân NC mở (disconnected) khi relay ON (HIGH)
- Code hiện tại: `HIGH = bật máy bơm` → Relay ON → NC mở → Máy bơm TẮT (sai!)

---

## ✅ Giải Pháp: Đảo Logic

### Cách Hoạt Động Của Chân NC:

**Relay OFF (LOW):**
- Chân NC: **ĐÓNG** (connected)
- Máy bơm: **CHẠY** ✅

**Relay ON (HIGH):**
- Chân NC: **MỞ** (disconnected)
- Máy bơm: **TẮT** ✅

---

## 🔧 Code Đã Sửa

**Hàm `setPump()`:**
```cpp
void setPump(bool on) {
  // LƯU Ý: Nếu dùng chân NC (Normally Closed) của relay:
  // - LOW = Relay OFF → NC đóng → Máy bơm CHẠY
  // - HIGH = Relay ON → NC mở → Máy bơm TẮT
  // Cần đảo logic: on ? LOW : HIGH
  digitalWrite(RELAY_PUMP, on ? LOW : HIGH);  // Đảo logic cho chân NC
  pumpRunning = on;
  if (on) {
    pumpStartTime = millis();
    Serial.println("💧 Máy bơm BẬT");
  } else {
    Serial.println("💧 Máy bơm TẮT");
  }
}
```

**Trong `setup()`:**
```cpp
// Tắt tất cả ban đầu
// LƯU Ý: Nếu dùng chân NC, LOW = máy bơm chạy, HIGH = máy bơm tắt
digitalWrite(RELAY_PUMP, HIGH);  // HIGH để tắt máy bơm (NC mở)
```

---

## 🎯 Cách Nối Đúng

### ✅ Option 2: Dùng Chân NO (Đang Dùng - Khuyên Dùng)

**Cách nối:**
```
Khay pin 6V (+) ────> Relay COM
Máy bơm (+) ────> Relay NO  (thay vì NC)
Máy bơm (-) ────> GND
```

**Logic code (bình thường, không cần đảo):**
- `digitalWrite(RELAY_PUMP, HIGH)` → Máy bơm CHẠY ✅
- `digitalWrite(RELAY_PUMP, LOW)` → Máy bơm TẮT ✅

---

### Option 1: Dùng Chân NC (Không Dùng)

**Cách nối:**
```
Khay pin 6V (+) ────> Relay COM
Máy bơm (+) ────> Relay NC
Máy bơm (-) ────> GND
```

**Logic code (cần đảo):**
- `digitalWrite(RELAY_PUMP, LOW)` → Máy bơm CHẠY
- `digitalWrite(RELAY_PUMP, HIGH)` → Máy bơm TẮT

---

## 📋 Checklist

- [ ] Đã sửa hàm `setPump()` để đảo logic
- [ ] Đã sửa `setup()` để set HIGH ban đầu (tắt máy bơm)
- [ ] Đã upload code mới lên ESP32
- [ ] Đã test máy bơm tắt khi khởi động
- [ ] Đã test máy bơm bật khi đất khô

---

## 💡 Lưu Ý

**Nếu muốn dùng logic bình thường (HIGH = bật):**
- Đổi sang chân **NO** (Normally Open) thay vì NC
- Code sẽ đơn giản hơn: `digitalWrite(RELAY_PUMP, on ? HIGH : LOW)`

---

**Đã sửa code! Hãy upload lại lên ESP32 và test!** 🔧✨

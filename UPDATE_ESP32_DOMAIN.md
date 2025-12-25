# 📡 Cập Nhật ESP32 Code Để Dùng Domain

## 🔄 Thay Đổi

**File:** `Arduino_SmartFarm_Demo/Arduino_SmartFarm_Demo.ino`

**Đã cập nhật:**
```cpp
// TRƯỚC:
const char* serverUrl = "http://109.205.180.72:8080/api/sensor-data/iot";

// SAU:
const char* serverUrl = "http://smartfarm.codex.io.vn/api/sensor-data/iot";
```

---

## ⚠️ Lưu Ý Quan Trọng

**ESP32 dùng HTTP (không HTTPS) vì:**
- HTTPS cần nhiều memory (ESP32 có giới hạn)
- HTTPS phức tạp hơn, dễ lỗi
- HTTP đủ cho IoT sensor data

**Nginx sẽ tự động redirect HTTP → HTTPS cho browser, nhưng:**
- ESP32 vẫn có thể gửi HTTP đến backend
- Backend cần chấp nhận cả HTTP và HTTPS

---

## 🔧 Cấu Hình Backend Để Chấp Nhận HTTP

**Nếu backend chỉ chấp nhận HTTPS, cần cấu hình:**

### Cách 1: Nginx Proxy HTTP → Backend

Nginx đã được cấu hình để proxy HTTP request từ ESP32 đến backend (không redirect).

### Cách 2: Backend Chấp Nhận Cả HTTP và HTTPS

Kiểm tra Spring Boot Security Config để đảm bảo chấp nhận cả HTTP và HTTPS.

---

## 📝 Các Bước

1. **Upload code mới lên ESP32:**
   - Mở `Arduino_SmartFarm_Demo.ino`
   - Upload code
   - Kiểm tra Serial Monitor

2. **Kiểm tra kết nối:**
   - Serial Monitor sẽ hiển thị: `✅ Đã gửi xong!`
   - Kiểm tra database có nhận dữ liệu không

3. **Nếu lỗi kết nối:**
   - Kiểm tra domain có resolve đúng không
   - Kiểm tra Nginx có proxy HTTP đến backend không
   - Kiểm tra firewall có chặn port 80 không

---

**Đã cập nhật code ESP32 để dùng domain!** 📡✨

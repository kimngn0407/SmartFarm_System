# 📺 Kiểm Tra Serial Monitor - ESP32 Đã Chạy?

## ✅ Đã Mở Serial Monitor

Bạn đã mở Serial Monitor và đang kết nối với:
- **Board:** ESP32 Dev Module
- **Port:** COM9
- **Baud Rate:** 115200

---

## 🔍 Kiểm Tra Code Có Chạy

### Bước 1: Xem Output Trong Serial Monitor

**Nếu code chạy thành công, bạn sẽ thấy:**

1. **Thông báo khởi động:**
   ```
   SmartFarm Demo - Starting...
   ```

2. **Thông tin WiFi:**
   ```
   Connecting to WiFi: Wifi miễn phí
   WiFi connected!
   IP address: 192.168.x.x
   ```

3. **Dữ liệu sensor (mỗi 5 giây):**
   ```
   Temperature: 25.0°C
   Humidity: 60.0%
   Soil Moisture: 50%
   Light: 1
   ```

4. **Thông báo gửi dữ liệu:**
   ```
   Sending data to server...
   Data sent successfully!
   ```

---

### Bước 2: Nếu Không Thấy Output

**Có thể do:**

1. **Code chưa upload thành công:**
   - Xem lại thông báo upload
   - Thử upload lại

2. **Baud rate không đúng:**
   - Kiểm tra code có `Serial.begin(115200)` không
   - Đảm bảo Serial Monitor cũng là **115200**

3. **ESP32 chưa reset:**
   - Nhấn nút **RESET** trên ESP32
   - Hoặc rút/cắm lại USB

---

### Bước 3: Reset ESP32

1. **Nhấn nút RESET** trên ESP32
   - Hoặc rút/cắm lại USB

2. **Xem Serial Monitor:**
   - Sẽ thấy output từ đầu

---

## 🎯 Checklist

- [ ] Serial Monitor đã mở (115200 baud)
- [ ] Đã nhấn nút RESET trên ESP32
- [ ] Đã thấy output trong Serial Monitor
- [ ] Code đang chạy thành công

---

## 💡 Lưu Ý

**Nếu Serial Monitor chỉ hiển thị dấu chấm (....):**
- Có thể ESP32 đang chạy nhưng không có output
- Thử nhấn nút RESET
- Kiểm tra code có `Serial.println()` không

**Nếu Serial Monitor trống:**
- Code có thể chưa upload thành công
- Thử upload lại
- Kiểm tra kết nối USB

---

## 🆘 Nếu Vẫn Không Thấy Output

**Vui lòng cho tôi biết:**

1. **Serial Monitor hiển thị gì?** (trống, dấu chấm, hay có text?)
2. **Đã nhấn nút RESET chưa?**
3. **Upload có thành công không?** (có thấy "Done uploading" không?)

---

**Hãy nhấn nút RESET trên ESP32 và xem Serial Monitor có output gì không!** 📺✨



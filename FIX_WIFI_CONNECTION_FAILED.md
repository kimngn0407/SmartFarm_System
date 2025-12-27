# 🔧 Fix WiFi Connection Failed - ESP32

## ❌ Vấn đề

```
❌ WiFi disconnected! Đang thử kết nối lại...
❌ WiFi connection failed!
Status code: X
```

## 🔍 Nguyên nhân có thể

### 1. WiFi Captive Portal (Quan trọng!)

**WiFi công cộng/trường học** thường yêu cầu:
- Đăng nhập qua web browser
- Chấp nhận điều khoản
- Nhập username/password

**ESP32 KHÔNG thể tự động vượt qua captive portal!**

**Giải pháp:**
- Kết nối bằng điện thoại/máy tính trước
- Hoặc dùng WiFi khác không có captive portal

### 2. WiFi không trong phạm vi

**Kiểm tra:**
- ESP32 có gần router không?
- Signal có đủ mạnh không?

**Giải pháp:**
- Đưa ESP32 gần router hơn
- Kiểm tra signal strength

### 3. WiFi yêu cầu MAC Address Whitelist

**Một số WiFi** chỉ cho phép thiết bị đã đăng ký.

**Giải pháp:**
- Đăng ký MAC address của ESP32 với quản trị viên WiFi
- Lấy MAC address từ Serial Monitor

### 4. WiFi 5GHz (ESP32 không hỗ trợ)

**ESP32 chỉ hỗ trợ WiFi 2.4GHz!**

**Kiểm tra:**
- WiFi "HUTECH E1" là 2.4GHz hay 5GHz?

**Giải pháp:**
- Dùng WiFi 2.4GHz

### 5. Code reconnect quá nhanh

**Lỗi:** Code đang cố reconnect trong khi đang kết nối.

**Giải pháp:** Đã sửa trong code mới - kiểm tra status trước khi reconnect.

## ✅ Giải pháp

### Bước 1: Kiểm tra Status Code

**Xem Serial Monitor** để biết status code:

- **Status 0 (WL_IDLE_STATUS):** Đang chờ
- **Status 1 (WL_NO_SSID_AVAIL):** Không tìm thấy SSID
- **Status 2 (WL_SCAN_COMPLETED):** Đã scan xong
- **Status 3 (WL_CONNECTED):** Đã kết nối ✅
- **Status 4 (WL_CONNECT_FAILED):** Kết nối thất bại ❌
- **Status 5 (WL_CONNECTION_LOST):** Mất kết nối
- **Status 6 (WL_DISCONNECTED):** Đã ngắt kết nối

### Bước 2: Test với WiFi khác

**Thử kết nối WiFi khác** (không có captive portal):
- WiFi nhà riêng
- WiFi hotspot từ điện thoại

**Nếu kết nối được** → WiFi "HUTECH E1" có vấn đề (captive portal hoặc whitelist)

### Bước 3: Kiểm tra Captive Portal

**Cách kiểm tra:**
1. Kết nối "HUTECH E1" bằng điện thoại/máy tính
2. Xem có yêu cầu đăng nhập không?
3. Nếu có → ESP32 không thể tự động đăng nhập

**Giải pháp:**
- Dùng WiFi khác không có captive portal
- Hoặc liên hệ quản trị viên để whitelist MAC address ESP32

### Bước 4: Lấy MAC Address ESP32

**Code để lấy MAC:**
```cpp
void setup() {
  Serial.begin(115200);
  Serial.print("MAC Address: ");
  Serial.println(WiFi.macAddress());
}
```

**Sau đó:**
- Gửi MAC address cho quản trị viên WiFi
- Yêu cầu whitelist

### Bước 5: Tăng thời gian đợi

**Code đã được cập nhật:**
- Tăng thời gian đợi từ 10 giây → 20 giây
- Thêm debug status code
- Giảm tần suất reconnect (30 giây/lần)

## 🔧 Code đã sửa

File `test_wifi_simple.ino` đã được cập nhật với:
- ✅ Tăng thời gian đợi kết nối (20 giây)
- ✅ In status code để debug
- ✅ Giảm tần suất reconnect (30 giây/lần)
- ✅ Kiểm tra status trước khi reconnect

## 📋 Checklist Troubleshooting

- [ ] Đã kiểm tra status code trong Serial Monitor
- [ ] Đã thử kết nối WiFi khác (không có captive portal)
- [ ] Đã kiểm tra WiFi có yêu cầu đăng nhập không
- [ ] Đã kiểm tra ESP32 có trong phạm vi WiFi không
- [ ] Đã kiểm tra WiFi là 2.4GHz (không phải 5GHz)
- [ ] Đã lấy MAC address và yêu cầu whitelist (nếu cần)

## 💡 Giải pháp thay thế

### Nếu WiFi "HUTECH E1" không dùng được:

1. **Dùng WiFi hotspot từ điện thoại:**
   - Bật hotspot trên điện thoại
   - Kết nối ESP32 vào hotspot đó
   - Test xem có hoạt động không

2. **Dùng WiFi nhà riêng:**
   - Kết nối ESP32 vào WiFi nhà
   - Test xem có hoạt động không

3. **Liên hệ quản trị viên:**
   - Yêu cầu whitelist MAC address ESP32
   - Hoặc hỏi về captive portal

## 🎯 Kết luận

**Nếu status code là 4 (WL_CONNECT_FAILED):**
- WiFi có thể yêu cầu captive portal
- Hoặc MAC address chưa được whitelist
- Hoặc WiFi không cho phép ESP32 kết nối

**Giải pháp tốt nhất:**
- Test với WiFi khác trước
- Nếu WiFi khác hoạt động → Vấn đề ở "HUTECH E1"
- Nếu WiFi khác cũng không hoạt động → Vấn đề ở ESP32 hoặc code

# 🔧 Fix WiFi Connection Failed - ESP32

## ❌ Vấn đề

```
❌ WiFi disconnected! Đang thử kết nối lại...
❌ WiFi connection failed!
Status code: X
```

## 🔍 Nguyên nhân có thể

### 1. WiFi Captive Portal (Quan trọng!)

**WiFi công cộng/trường học** thường yêu cầu:
- Đăng nhập qua web browser
- Chấp nhận điều khoản
- Nhập username/password

**ESP32 KHÔNG thể tự động vượt qua captive portal!**

**Giải pháp:**
- Kết nối bằng điện thoại/máy tính trước
- Hoặc dùng WiFi khác không có captive portal

### 2. WiFi không trong phạm vi

**Kiểm tra:**
- ESP32 có gần router không?
- Signal có đủ mạnh không?

**Giải pháp:**
- Đưa ESP32 gần router hơn
- Kiểm tra signal strength

### 3. WiFi yêu cầu MAC Address Whitelist

**Một số WiFi** chỉ cho phép thiết bị đã đăng ký.

**Giải pháp:**
- Đăng ký MAC address của ESP32 với quản trị viên WiFi
- Lấy MAC address từ Serial Monitor

### 4. WiFi 5GHz (ESP32 không hỗ trợ)

**ESP32 chỉ hỗ trợ WiFi 2.4GHz!**

**Kiểm tra:**
- WiFi "HUTECH E1" là 2.4GHz hay 5GHz?

**Giải pháp:**
- Dùng WiFi 2.4GHz

### 5. Code reconnect quá nhanh

**Lỗi:** Code đang cố reconnect trong khi đang kết nối.

**Giải pháp:** Đã sửa trong code mới - kiểm tra status trước khi reconnect.

## ✅ Giải pháp

### Bước 1: Kiểm tra Status Code

**Xem Serial Monitor** để biết status code:

- **Status 0 (WL_IDLE_STATUS):** Đang chờ
- **Status 1 (WL_NO_SSID_AVAIL):** Không tìm thấy SSID
- **Status 2 (WL_SCAN_COMPLETED):** Đã scan xong
- **Status 3 (WL_CONNECTED):** Đã kết nối ✅
- **Status 4 (WL_CONNECT_FAILED):** Kết nối thất bại ❌
- **Status 5 (WL_CONNECTION_LOST):** Mất kết nối
- **Status 6 (WL_DISCONNECTED):** Đã ngắt kết nối

### Bước 2: Test với WiFi khác

**Thử kết nối WiFi khác** (không có captive portal):
- WiFi nhà riêng
- WiFi hotspot từ điện thoại

**Nếu kết nối được** → WiFi "HUTECH E1" có vấn đề (captive portal hoặc whitelist)

### Bước 3: Kiểm tra Captive Portal

**Cách kiểm tra:**
1. Kết nối "HUTECH E1" bằng điện thoại/máy tính
2. Xem có yêu cầu đăng nhập không?
3. Nếu có → ESP32 không thể tự động đăng nhập

**Giải pháp:**
- Dùng WiFi khác không có captive portal
- Hoặc liên hệ quản trị viên để whitelist MAC address ESP32

### Bước 4: Lấy MAC Address ESP32

**Code để lấy MAC:**
```cpp
void setup() {
  Serial.begin(115200);
  Serial.print("MAC Address: ");
  Serial.println(WiFi.macAddress());
}
```

**Sau đó:**
- Gửi MAC address cho quản trị viên WiFi
- Yêu cầu whitelist

### Bước 5: Tăng thời gian đợi

**Code đã được cập nhật:**
- Tăng thời gian đợi từ 10 giây → 20 giây
- Thêm debug status code
- Giảm tần suất reconnect (30 giây/lần)

## 🔧 Code đã sửa

File `test_wifi_simple.ino` đã được cập nhật với:
- ✅ Tăng thời gian đợi kết nối (20 giây)
- ✅ In status code để debug
- ✅ Giảm tần suất reconnect (30 giây/lần)
- ✅ Kiểm tra status trước khi reconnect

## 📋 Checklist Troubleshooting

- [ ] Đã kiểm tra status code trong Serial Monitor
- [ ] Đã thử kết nối WiFi khác (không có captive portal)
- [ ] Đã kiểm tra WiFi có yêu cầu đăng nhập không
- [ ] Đã kiểm tra ESP32 có trong phạm vi WiFi không
- [ ] Đã kiểm tra WiFi là 2.4GHz (không phải 5GHz)
- [ ] Đã lấy MAC address và yêu cầu whitelist (nếu cần)

## 💡 Giải pháp thay thế

### Nếu WiFi "HUTECH E1" không dùng được:

1. **Dùng WiFi hotspot từ điện thoại:**
   - Bật hotspot trên điện thoại
   - Kết nối ESP32 vào hotspot đó
   - Test xem có hoạt động không

2. **Dùng WiFi nhà riêng:**
   - Kết nối ESP32 vào WiFi nhà
   - Test xem có hoạt động không

3. **Liên hệ quản trị viên:**
   - Yêu cầu whitelist MAC address ESP32
   - Hoặc hỏi về captive portal

## 🎯 Kết luận

**Nếu status code là 4 (WL_CONNECT_FAILED):**
- WiFi có thể yêu cầu captive portal
- Hoặc MAC address chưa được whitelist
- Hoặc WiFi không cho phép ESP32 kết nối

**Giải pháp tốt nhất:**
- Test với WiFi khác trước
- Nếu WiFi khác hoạt động → Vấn đề ở "HUTECH E1"
- Nếu WiFi khác cũng không hoạt động → Vấn đề ở ESP32 hoặc code


# 📡 Cách Tìm Thông Tin WiFi (SSID và Password)

## 🎯 Tìm Tên WiFi (SSID)

### Trên Windows:

**Cách 1: Nhìn vào Taskbar**
1. Click vào biểu tượng WiFi ở góc dưới bên phải
2. Xem danh sách WiFi
3. WiFi bạn đang dùng sẽ có chữ "Connected" hoặc dấu ✓
4. **Tên WiFi đó chính là SSID**

**Cách 2: Settings**
1. Nhấn `Windows + I` (mở Settings)
2. Chọn **Network & Internet** → **Wi-Fi**
3. Xem **Wi-Fi network name** (tên WiFi hiện tại)

**Cách 3: Command Prompt**
```cmd
netsh wlan show profile
```
Xem danh sách WiFi đã lưu

### Trên Điện Thoại:

**Android:**
1. Settings → Wi-Fi
2. Xem tên WiFi đang kết nối

**iPhone:**
1. Settings → Wi-Fi
2. Xem tên WiFi đang kết nối

## 🔑 Tìm Mật Khẩu WiFi (Password)

### Trên Windows (WiFi đã lưu):

**Cách 1: Command Prompt (Khuyến nghị)**
1. Mở **Command Prompt** (Run as Administrator)
2. Chạy lệnh:
   ```cmd
   netsh wlan show profile name="Tên_WiFi" key=clear
   ```
   (Thay `Tên_WiFi` bằng tên WiFi thực tế)
3. Tìm dòng **Key Content** → Đó chính là mật khẩu

**Ví dụ:**
```cmd
netsh wlan show profile name="MyHomeWiFi" key=clear
```

**Cách 2: Settings**
1. Settings → Network & Internet → Wi-Fi
2. Click **Manage known networks**
3. Click vào WiFi bạn muốn
4. Click **Properties**
5. Bật **Show password** (có thể cần nhập mật khẩu Windows)

### Trên Router:

1. **Tìm địa chỉ IP router:**
   - Mở Command Prompt
   - Chạy: `ipconfig`
   - Xem **Default Gateway** (ví dụ: 192.168.1.1)

2. **Truy cập router:**
   - Mở trình duyệt
   - Gõ địa chỉ IP router (ví dụ: http://192.168.1.1)
   - Đăng nhập (thường là admin/admin hoặc admin/password)

3. **Tìm mật khẩu WiFi:**
   - Tìm mục **Wireless** hoặc **Wi-Fi**
   - Xem **Password** hoặc **Pre-shared Key**

### Trên Điện Thoại (Android - Root):

1. Cài app **WiFi Password Viewer**
2. Xem mật khẩu WiFi đã lưu

## 📝 Ví Dụ Cụ Thể

### Ví dụ 1: WiFi tên "MyHomeWiFi"

**SSID:** `MyHomeWiFi`  
**Password:** `12345678`

**Code sẽ là:**
```cpp
const char* ssid = "MyHomeWiFi";
const char* password = "12345678";
```

### Ví dụ 2: WiFi tên "TP-Link_5G" (nhưng dùng 2.4GHz)

**Lưu ý:** ESP32 chỉ hỗ trợ 2.4GHz, không hỗ trợ 5GHz!

**Nếu router có 2 mạng:**
- `TP-Link_2.4G` → Dùng cái này
- `TP-Link_5G` → KHÔNG dùng (ESP32 không hỗ trợ)

**Code:**
```cpp
const char* ssid = "TP-Link_2.4G";
const char* password = "matkhau123";
```

### Ví dụ 3: WiFi có dấu cách

**SSID:** `My Home WiFi`

**Code:**
```cpp
const char* ssid = "My Home WiFi";  // Giữ nguyên dấu cách
const char* password = "12345678";
```

## ⚠️ Lưu Ý Quan Trọng

1. **ESP32 chỉ hỗ trợ WiFi 2.4GHz**
   - KHÔNG hỗ trợ WiFi 5GHz
   - Nếu router có cả 2, dùng tên WiFi 2.4GHz

2. **SSID và Password phải chính xác:**
   - Phân biệt chữ hoa/thường
   - Không có khoảng trắng thừa
   - Giữ nguyên dấu cách nếu có

3. **Kiểm tra lại:**
   - Thử kết nối bằng điện thoại trước
   - Đảm bảo WiFi đang bật
   - ESP32 phải trong phạm vi WiFi

## 🚀 Quick Command (Windows)

**Tìm tất cả WiFi đã lưu và mật khẩu:**

```cmd
for /f "tokens=2 delims=:" %a in ('netsh wlan show profile ^| findstr "All User Profile"') do @echo %a & netsh wlan show profile name="%a" key=clear | findstr "Key Content"
```

## 💡 Tips

- **Ghi lại SSID và password** vào file text để dễ nhớ
- **Test với code `test_wifi_simple.ino`** trước
- **Nếu không nhớ password**, reset router và đặt lại

# 📡 Cách Tìm Thông Tin WiFi (SSID và Password)

## 🎯 Tìm Tên WiFi (SSID)

### Trên Windows:

**Cách 1: Nhìn vào Taskbar**
1. Click vào biểu tượng WiFi ở góc dưới bên phải
2. Xem danh sách WiFi
3. WiFi bạn đang dùng sẽ có chữ "Connected" hoặc dấu ✓
4. **Tên WiFi đó chính là SSID**

**Cách 2: Settings**
1. Nhấn `Windows + I` (mở Settings)
2. Chọn **Network & Internet** → **Wi-Fi**
3. Xem **Wi-Fi network name** (tên WiFi hiện tại)

**Cách 3: Command Prompt**
```cmd
netsh wlan show profile
```
Xem danh sách WiFi đã lưu

### Trên Điện Thoại:

**Android:**
1. Settings → Wi-Fi
2. Xem tên WiFi đang kết nối

**iPhone:**
1. Settings → Wi-Fi
2. Xem tên WiFi đang kết nối

## 🔑 Tìm Mật Khẩu WiFi (Password)

### Trên Windows (WiFi đã lưu):

**Cách 1: Command Prompt (Khuyến nghị)**
1. Mở **Command Prompt** (Run as Administrator)
2. Chạy lệnh:
   ```cmd
   netsh wlan show profile name="Tên_WiFi" key=clear
   ```
   (Thay `Tên_WiFi` bằng tên WiFi thực tế)
3. Tìm dòng **Key Content** → Đó chính là mật khẩu

**Ví dụ:**
```cmd
netsh wlan show profile name="MyHomeWiFi" key=clear
```

**Cách 2: Settings**
1. Settings → Network & Internet → Wi-Fi
2. Click **Manage known networks**
3. Click vào WiFi bạn muốn
4. Click **Properties**
5. Bật **Show password** (có thể cần nhập mật khẩu Windows)

### Trên Router:

1. **Tìm địa chỉ IP router:**
   - Mở Command Prompt
   - Chạy: `ipconfig`
   - Xem **Default Gateway** (ví dụ: 192.168.1.1)

2. **Truy cập router:**
   - Mở trình duyệt
   - Gõ địa chỉ IP router (ví dụ: http://192.168.1.1)
   - Đăng nhập (thường là admin/admin hoặc admin/password)

3. **Tìm mật khẩu WiFi:**
   - Tìm mục **Wireless** hoặc **Wi-Fi**
   - Xem **Password** hoặc **Pre-shared Key**

### Trên Điện Thoại (Android - Root):

1. Cài app **WiFi Password Viewer**
2. Xem mật khẩu WiFi đã lưu

## 📝 Ví Dụ Cụ Thể

### Ví dụ 1: WiFi tên "MyHomeWiFi"

**SSID:** `MyHomeWiFi`  
**Password:** `12345678`

**Code sẽ là:**
```cpp
const char* ssid = "MyHomeWiFi";
const char* password = "12345678";
```

### Ví dụ 2: WiFi tên "TP-Link_5G" (nhưng dùng 2.4GHz)

**Lưu ý:** ESP32 chỉ hỗ trợ 2.4GHz, không hỗ trợ 5GHz!

**Nếu router có 2 mạng:**
- `TP-Link_2.4G` → Dùng cái này
- `TP-Link_5G` → KHÔNG dùng (ESP32 không hỗ trợ)

**Code:**
```cpp
const char* ssid = "TP-Link_2.4G";
const char* password = "matkhau123";
```

### Ví dụ 3: WiFi có dấu cách

**SSID:** `My Home WiFi`

**Code:**
```cpp
const char* ssid = "My Home WiFi";  // Giữ nguyên dấu cách
const char* password = "12345678";
```

## ⚠️ Lưu Ý Quan Trọng

1. **ESP32 chỉ hỗ trợ WiFi 2.4GHz**
   - KHÔNG hỗ trợ WiFi 5GHz
   - Nếu router có cả 2, dùng tên WiFi 2.4GHz

2. **SSID và Password phải chính xác:**
   - Phân biệt chữ hoa/thường
   - Không có khoảng trắng thừa
   - Giữ nguyên dấu cách nếu có

3. **Kiểm tra lại:**
   - Thử kết nối bằng điện thoại trước
   - Đảm bảo WiFi đang bật
   - ESP32 phải trong phạm vi WiFi

## 🚀 Quick Command (Windows)

**Tìm tất cả WiFi đã lưu và mật khẩu:**

```cmd
for /f "tokens=2 delims=:" %a in ('netsh wlan show profile ^| findstr "All User Profile"') do @echo %a & netsh wlan show profile name="%a" key=clear | findstr "Key Content"
```

## 💡 Tips

- **Ghi lại SSID và password** vào file text để dễ nhớ
- **Test với code `test_wifi_simple.ino`** trước
- **Nếu không nhớ password**, reset router và đặt lại


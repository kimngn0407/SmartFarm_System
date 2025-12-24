# 🔧 Fix Lỗi Download ESP32 Package - Timeout

## ❌ Lỗi

```
Failed to install platform: 'esp32:esp32:3.3.5'.
Error: 4 DEADLINE_EXCEEDED: context deadline exceeded
```

## 🔍 Nguyên nhân

1. **Kết nối internet chậm** - Package ESP32 rất lớn (~200MB)
2. **Timeout quá ngắn** - Arduino IDE timeout trước khi download xong
3. **Firewall/Proxy** chặn kết nối
4. **Server ESP32 quá tải**

## ✅ Giải pháp

### Giải pháp 1: Tăng Timeout trong Arduino IDE (Khuyến nghị)

1. **Đóng Arduino IDE**

2. **Tìm file preferences.txt:**
   - Windows: `C:\Users\YourName\AppData\Local\Arduino15\preferences.txt`
   - Hoặc: File → Preferences → Click vào file path hiển thị

3. **Thêm dòng này vào cuối file:**
   ```
   boardsmanager.additional.urls=https://raw.githubusercontent.com/espressif/arduino-esp32/gh-pages/package_esp32_index.json
   network.timeout=300
   ```

4. **Lưu file và mở lại Arduino IDE**

5. **Thử cài lại ESP32 board**

### Giải pháp 2: Download Manual (Nếu vẫn timeout)

#### Bước 1: Tải package thủ công

1. **Tải ESP32 package:**
   - Link: https://github.com/espressif/arduino-esp32/releases
   - Tải file: `esp32-3.3.5.zip` (hoặc version mới nhất)

2. **Giải nén vào thư mục:**
   ```
   Windows: C:\Users\YourName\AppData\Local\Arduino15\packages\esp32\hardware\esp32\3.3.5
   ```

3. **Tạo thư mục nếu chưa có:**
   ```powershell
   # Mở PowerShell
   New-Item -ItemType Directory -Force -Path "$env:LOCALAPPDATA\Arduino15\packages\esp32\hardware\esp32\3.3.5"
   ```

4. **Giải nén file zip vào thư mục trên**

#### Bước 2: Cài tools

1. **Tải ESP32 tools:**
   - Từ: https://github.com/espressif/arduino-esp32/releases
   - Tải các file tools cần thiết

2. **Đặt vào:**
   ```
   C:\Users\YourName\AppData\Local\Arduino15\packages\esp32\tools\
   ```

### Giải pháp 3: Dùng Mirror/Proxy khác

1. **Thử URL mirror khác:**
   ```
   File → Preferences → Additional Boards Manager URLs
   
   Thêm (thay vì URL gốc):
   https://github.com/espressif/arduino-esp32/releases/download/3.3.5/package_esp32_index.json
   ```

2. **Hoặc dùng proxy nếu có**

### Giải pháp 4: Cài từng phần (Manual Install)

#### Cách 1: Dùng Git để clone

```bash
# Cài Git nếu chưa có: https://git-scm.com/download/win

# Mở Command Prompt hoặc PowerShell
cd %LOCALAPPDATA%\Arduino15\packages\esp32\hardware

# Clone ESP32 core
git clone https://github.com/espressif/arduino-esp32.git esp32

# Vào thư mục
cd esp32

# Checkout version ổn định
git checkout 3.3.5

# Cài tools (sẽ tự động download)
cd tools
python get.py
```

#### Cách 2: Dùng ESP32 Package Manager (ESP-IDF)

1. **Tải ESP-IDF:**
   - Link: https://docs.espressif.com/projects/esp-idf/en/latest/esp32/get-started/windows-setup.html

2. **Cài ESP-IDF với ESP-IDF Tools**

3. **Sau đó cài Arduino ESP32 core**

### Giải pháp 5: Fix Network/Firewall

1. **Tắt Firewall tạm thời:**
   - Windows Security → Firewall → Tắt tạm thời
   - Thử download lại

2. **Kiểm tra Proxy:**
   - Settings → Network → Proxy
   - Nếu có proxy, cấu hình trong Arduino IDE

3. **Dùng VPN nếu cần** (một số region bị chặn GitHub)

### Giải pháp 6: Dùng Version Cũ Hơn (Ổn định hơn)

1. **Xóa URL hiện tại** trong Preferences

2. **Thêm URL version cũ:**
   ```
   https://raw.githubusercontent.com/espressif/arduino-esp32/gh-pages/package_esp32_index.json
   ```

3. **Trong Boards Manager:**
   - Tìm "esp32"
   - Chọn version cũ hơn (ví dụ: 2.0.11 thay vì 3.3.5)
   - Version cũ nhỏ hơn, download nhanh hơn

## 🚀 Quick Fix (Thử ngay)

### Bước 1: Restart và Clear Cache

```powershell
# Đóng Arduino IDE
# Xóa cache
Remove-Item -Recurse -Force "$env:LOCALAPPDATA\Arduino15\staging\packages\*"
Remove-Item -Recurse -Force "$env:LOCALAPPDATA\Arduino15\packages\esp32\*" -ErrorAction SilentlyContinue
```

### Bước 2: Cấu hình Timeout

1. **Mở file preferences.txt:**
   ```
   %LOCALAPPDATA%\Arduino15\preferences.txt
   ```

2. **Thêm:**
   ```
   network.timeout=600
   ```

3. **Lưu và mở lại Arduino IDE**

### Bước 3: Cài lại với Settings

1. **Tools → Board → Boards Manager**
2. **Tìm "esp32"**
3. **Chọn version 2.0.11** (nhỏ hơn, nhanh hơn)
4. **Click Install**

## 📋 Checklist

- [ ] Đã tăng network.timeout trong preferences.txt
- [ ] Đã clear cache Arduino
- [ ] Đã thử version cũ hơn (2.0.11)
- [ ] Đã kiểm tra Firewall/Proxy
- [ ] Đã thử cáp mạng khác (nếu dùng WiFi)
- [ ] Đã restart Arduino IDE

## 💡 Mẹo

1. **Dùng kết nối internet ổn định** (LAN tốt hơn WiFi)
2. **Tắt các ứng dụng download khác** khi cài ESP32
3. **Thử vào giờ ít người dùng** (sáng sớm hoặc đêm khuya)
4. **Dùng version 2.0.11** thay vì 3.3.5 (nhỏ hơn, ổn định hơn)

## 🔗 Download Manual Links

Nếu vẫn không được, tải manual:

- **ESP32 Core 2.0.11:** https://github.com/espressif/arduino-esp32/releases/tag/2.0.11
- **ESP32 Core 3.3.5:** https://github.com/espressif/arduino-esp32/releases/tag/3.3.5

**Sau khi tải:**
1. Giải nén vào: `%LOCALAPPDATA%\Arduino15\packages\esp32\hardware\esp32\`
2. Restart Arduino IDE
3. Board sẽ xuất hiện trong Tools → Board

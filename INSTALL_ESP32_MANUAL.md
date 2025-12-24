# 📦 Hướng dẫn Cài ESP32 Package Manual (Từ File ZIP)

## ✅ Bạn đã có file: `esp32-3.3.5.zip`

## 🚀 Các bước cài đặt

### Bước 1: Tạo thư mục đích

```powershell
# Mở PowerShell
# Tạo thư mục cho ESP32 3.3.5
New-Item -ItemType Directory -Force -Path "$env:LOCALAPPDATA\Arduino15\packages\esp32\hardware\esp32\3.3.5"
```

Hoặc tạo thủ công:
```
C:\Users\ASUS\AppData\Local\Arduino15\packages\esp32\hardware\esp32\3.3.5
```

### Bước 2: Giải nén file ZIP

1. **Right-click vào file `esp32-3.3.5.zip`**
2. **Chọn "Extract All..." hoặc "Extract to..."**
3. **Giải nén vào thư mục:**
   ```
   C:\Users\ASUS\AppData\Local\Arduino15\packages\esp32\hardware\esp32\3.3.5
   ```

**Lưu ý:** 
- Giải nén **trực tiếp** vào thư mục `3.3.5`
- Không tạo thư mục con thêm
- Sau khi giải nén, trong `3.3.5` phải có các file như `boards.txt`, `platform.txt`, `variants/`, `cores/`, v.v.

### Bước 3: Kiểm tra cấu trúc thư mục

Sau khi giải nén, thư mục `3.3.5` phải có cấu trúc như sau:

```
3.3.5/
  ├── boards.txt
  ├── platform.txt
  ├── platform.local.txt
  ├── cores/
  ├── variants/
  ├── libraries/
  ├── tools/
  └── ...
```

### Bước 4: Cài Tools (Quan trọng!)

ESP32 cần các tools để compile và upload. Có 2 cách:

#### Cách 1: Tự động (Khuyến nghị)

1. **Mở Arduino IDE**
2. **Tools → Board → Boards Manager**
3. **Tìm "esp32"**
4. **Click "Install"** cho version 3.3.5
5. Arduino IDE sẽ tự động download tools (có thể vẫn timeout, nhưng tools nhỏ hơn)

#### Cách 2: Manual (Nếu cách 1 timeout)

1. **Tải tools từ:**
   - https://github.com/espressif/arduino-esp32/releases/tag/3.3.5
   - Tìm các file tools (xtensa-esp32-elf, esptool, etc.)

2. **Giải nén vào:**
   ```
   C:\Users\ASUS\AppData\Local\Arduino15\packages\esp32\tools\
   ```

### Bước 5: Restart Arduino IDE

1. **Đóng Arduino IDE hoàn toàn**
2. **Mở lại Arduino IDE**
3. **Tools → Board → ESP32 Arduino → ESP32 Dev Module**
4. **Kiểm tra:** Board phải xuất hiện trong danh sách

### Bước 6: Test

1. **Mở ví dụ:** File → Examples → 01.Basics → Blink
2. **Sửa code:**
   ```cpp
   #define LED_BUILTIN 2  // ESP32
   ```
3. **Chọn board:** Tools → Board → ESP32 Dev Module
4. **Chọn Port:** Tools → Port → COMx
5. **Upload:** Click Upload

## 🔍 Kiểm tra sau khi cài

### Kiểm tra thư mục:

```powershell
# Kiểm tra hardware
dir "C:\Users\ASUS\AppData\Local\Arduino15\packages\esp32\hardware\esp32\3.3.5"

# Phải thấy: boards.txt, platform.txt, cores/, variants/
```

### Kiểm tra trong Arduino IDE:

1. **Tools → Board → ESP32 Arduino**
2. **Phải thấy:** ESP32 Dev Module, ESP32-WROOM-DA Module, v.v.
3. **Chọn ESP32 Dev Module**
4. **Tools → Port:** Phải thấy COM port (nếu ESP32 đã cắm)

## ⚠️ Lưu ý quan trọng

1. **Giải nén đúng thư mục:**
   - ✅ Đúng: `packages\esp32\hardware\esp32\3.3.5\boards.txt`
   - ❌ Sai: `packages\esp32\hardware\esp32\3.3.5\esp32-3.3.5\boards.txt`

2. **Cần tools:**
   - Chỉ giải nén hardware chưa đủ
   - Cần cài tools (xtensa-esp32-elf, esptool, etc.)

3. **Version phải khớp:**
   - Nếu giải nén vào `3.3.5`, Arduino IDE sẽ nhận version 3.3.5
   - Nếu muốn version khác, giải nén vào thư mục tương ứng

## 🐛 Troubleshooting

### Board không xuất hiện trong Arduino IDE:

1. **Kiểm tra đường dẫn:**
   ```powershell
   Test-Path "C:\Users\ASUS\AppData\Local\Arduino15\packages\esp32\hardware\esp32\3.3.5\boards.txt"
   ```
   - Phải trả về `True`

2. **Kiểm tra file boards.txt:**
   ```powershell
   Get-Content "C:\Users\ASUS\AppData\Local\Arduino15\packages\esp32\hardware\esp32\3.3.5\boards.txt" | Select-Object -First 5
   ```
   - Phải thấy nội dung file

3. **Restart Arduino IDE** (đóng hoàn toàn và mở lại)

### Lỗi "Platform not found":

1. **Kiểm tra cấu trúc thư mục** (xem Bước 3)
2. **Kiểm tra file platform.txt có tồn tại không**
3. **Xóa cache:**
   ```powershell
   Remove-Item -Recurse -Force "$env:LOCALAPPDATA\Arduino15\staging\packages\*"
   ```

### Lỗi "Tool not found":

1. **Cài tools** (xem Bước 4)
2. **Hoặc để Arduino IDE tự động download tools**

## 📋 Checklist

- [ ] Đã tạo thư mục `3.3.5`
- [ ] Đã giải nén file zip vào đúng thư mục
- [ ] Đã kiểm tra có file `boards.txt` và `platform.txt`
- [ ] Đã restart Arduino IDE
- [ ] Board ESP32 xuất hiện trong Tools → Board
- [ ] Đã test upload code thành công

## 🎯 Quick Command (PowerShell)

```powershell
# Tạo thư mục
$targetPath = "$env:LOCALAPPDATA\Arduino15\packages\esp32\hardware\esp32\3.3.5"
New-Item -ItemType Directory -Force -Path $targetPath

# Giải nén (thay đổi đường dẫn đến file zip của bạn)
$zipPath = "C:\Users\ASUS\Downloads\esp32-3.3.5.zip"  # Thay bằng đường dẫn thực tế
Expand-Archive -Path $zipPath -DestinationPath $targetPath -Force

# Kiểm tra
Test-Path "$targetPath\boards.txt"
```

**Sau đó:**
1. Restart Arduino IDE
2. Tools → Board → ESP32 Dev Module
3. Test upload code

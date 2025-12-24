# 🔧 Fix - Thư mục hardware\esp32 trống

## ❌ Vấn đề

- ✅ **Tools đã có** (esptool_py, mkspiffs, mklittlefs, ...)
- ❌ **Hardware package chưa có** (thư mục `hardware\esp32` trống)

## ✅ Giải pháp: Giải nén Hardware Package

### Bước 1: Kiểm tra file ZIP đã tải

Bạn đã có file: `esp32-3.3.5.zip` (26.2 MB)

### Bước 2: Giải nén vào đúng thư mục

1. **Right-click vào file `esp32-3.3.5.zip`**
2. **Chọn "Extract All..." hoặc "Extract to..."**
3. **Giải nén vào:**
   ```
   C:\Users\ASUS\AppData\Local\Arduino15\packages\esp32\hardware\esp32\3.3.5
   ```

**⚠️ QUAN TRỌNG:**
- Giải nén **TRỰC TIẾP** vào thư mục `3.3.5`
- **KHÔNG** tạo thư mục con thêm
- Sau khi giải nén, trong `3.3.5` phải có: `boards.txt`, `platform.txt`, `cores/`, `variants/`, v.v.

### Bước 3: Kiểm tra sau khi giải nén

Sau khi giải nén, thư mục `3.3.5` phải có:

```
3.3.5/
  ├── boards.txt          ✅
  ├── platform.txt        ✅
  ├── cores/              ✅
  ├── variants/           ✅
  ├── libraries/          ✅
  └── ...
```

### Bước 4: Restart Arduino IDE

1. **Đóng Arduino IDE hoàn toàn**
2. **Mở lại Arduino IDE**
3. **Tools → Board → ESP32 Arduino → ESP32 Dev Module**
4. **Kiểm tra:** Board phải xuất hiện

## 🚀 Quick Command (PowerShell)

```powershell
# Tạo thư mục
$targetPath = "$env:LOCALAPPDATA\Arduino15\packages\esp32\hardware\esp32\3.3.5"
New-Item -ItemType Directory -Force -Path $targetPath

# Giải nén (thay đường dẫn đến file zip của bạn)
$zipPath = "C:\Users\ASUS\Downloads\esp32-3.3.5.zip"  # Thay bằng đường dẫn thực tế
Expand-Archive -Path $zipPath -DestinationPath $targetPath -Force

# Kiểm tra
Test-Path "$targetPath\boards.txt"
# Phải trả về: True
```

## 🔍 Kiểm tra sau khi giải nén

```powershell
# Kiểm tra file quan trọng
Test-Path "C:\Users\ASUS\AppData\Local\Arduino15\packages\esp32\hardware\esp32\3.3.5\boards.txt"
# Phải trả về: True

# Xem nội dung thư mục
dir "C:\Users\ASUS\AppData\Local\Arduino15\packages\esp32\hardware\esp32\3.3.5"
# Phải thấy: boards.txt, platform.txt, cores/, variants/, libraries/
```

## ⚠️ Lưu ý

1. **Giải nén đúng thư mục:**
   - ✅ Đúng: `packages\esp32\hardware\esp32\3.3.5\boards.txt`
   - ❌ Sai: `packages\esp32\hardware\esp32\3.3.5\esp32-3.3.5\boards.txt`

2. **Nếu giải nén sai:**
   - Di chuyển tất cả file từ thư mục con lên `3.3.5`
   - Hoặc giải nén lại vào đúng thư mục

## 📋 Checklist

- [ ] Đã giải nén `esp32-3.3.5.zip` vào `hardware\esp32\3.3.5`
- [ ] Đã kiểm tra có file `boards.txt` và `platform.txt`
- [ ] Đã kiểm tra có thư mục `cores/` và `variants/`
- [ ] Đã restart Arduino IDE
- [ ] Board ESP32 xuất hiện trong Tools → Board
- [ ] Đã thử compile code (có thể vẫn cần tools)

## 🎯 Sau khi giải nén hardware

1. **Restart Arduino IDE**
2. **Tools → Board → ESP32 Dev Module**
3. **Thử compile code**
4. **Nếu vẫn lỗi "Tool not found"** → Cài tools (xem `FIX_ESP32_TOOLS_MISSING.md`)

# 🔧 Fix Lỗi ESP32 Bootloader Missing

## ❌ Lỗi

```
Invalid value for 'FILENAME': Path
'{runtime.tools.esp32-arduino-libs.path}\esp32\bin\bootloader_qio_80m.elf'
does not exist.
```

## 🔍 Nguyên nhân

File `esp32-3.3.5-libs.zip` đã được download nhưng:
- Chưa được giải nén vào đúng vị trí
- Hoặc cấu trúc thư mục sau khi giải nén không đúng

## ✅ Giải pháp: Giải nén Thủ công

### Bước 1: Kiểm tra file ZIP

File cần có: `C:\Users\ASUS\Downloads\esp32-tools\esp32-3.3.5-libs.zip`

### Bước 2: Giải nén vào đúng thư mục

**Thư mục đích:**
```
C:\Users\ASUS\AppData\Local\Arduino15\packages\esp32\tools\esp32-arduino-libs\idf-release_v5.5-9bb7aa84-v2\
```

### Bước 3: Kiểm tra cấu trúc sau khi giải nén

Sau khi giải nén, phải có:
```
idf-release_v5.5-9bb7aa84-v2/
  ├── esp32/
  │   └── bin/
  │       └── bootloader_qio_80m.elf  ✅
  ├── esp32s2/
  ├── esp32s3/
  └── ...
```

### Bước 4: Kiểm tra file bootloader

```powershell
Test-Path "C:\Users\ASUS\AppData\Local\Arduino15\packages\esp32\tools\esp32-arduino-libs\idf-release_v5.5-9bb7aa84-v2\esp32\bin\bootloader_qio_80m.elf"
```

**Phải trả về:** `True`

## 🚀 Quick Fix (PowerShell)

```powershell
# Thư mục đích
$targetDir = "$env:LOCALAPPDATA\Arduino15\packages\esp32\tools\esp32-arduino-libs\idf-release_v5.5-9bb7aa84-v2"
$zipFile = "$env:USERPROFILE\Downloads\esp32-tools\esp32-3.3.5-libs.zip"

# Tạo thư mục
New-Item -ItemType Directory -Force -Path $targetDir | Out-Null

# Giải nén
$tempDir = "$env:TEMP\esp32-libs-temp"
Remove-Item -Recurse -Force $tempDir -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Force -Path $tempDir | Out-Null

Expand-Archive -Path $zipFile -DestinationPath $tempDir -Force

# Tìm và di chuyển nội dung
$libsDir = Get-ChildItem -Path $tempDir -Recurse -Directory -Filter "esp32-arduino-libs" | Select-Object -First 1
if ($libsDir) {
    Get-ChildItem -Path $libsDir.FullName | Move-Item -Destination $targetDir -Force
} else {
    # Nếu không có thư mục esp32-arduino-libs, di chuyển toàn bộ
    Get-ChildItem -Path $tempDir | Move-Item -Destination $targetDir -Force
}

# Xóa thư mục tạm
Start-Sleep -Seconds 2
Remove-Item -Recurse -Force $tempDir -ErrorAction SilentlyContinue

# Kiểm tra
$bootloader = "$targetDir\esp32\bin\bootloader_qio_80m.elf"
if (Test-Path $bootloader) {
    Write-Host "OK Bootloader da duoc cai dat!" -ForegroundColor Green
} else {
    Write-Host "WARNING: Khong tim thay bootloader" -ForegroundColor Yellow
    Write-Host "Thu tim trong toan bo thu muc..." -ForegroundColor Gray
    Get-ChildItem -Path $targetDir -Recurse -Filter "bootloader*.elf" | Select-Object -First 3
}
```

## 📋 Checklist

- [ ] Đã giải nén `esp32-3.3.5-libs.zip`
- [ ] Đã kiểm tra có thư mục `esp32\bin\` trong `idf-release_v5.5-9bb7aa84-v2\`
- [ ] Đã kiểm tra có file `bootloader_qio_80m.elf`
- [ ] Đã restart Arduino IDE
- [ ] Đã thử compile lại code

## 🎯 Sau khi fix

1. **Restart Arduino IDE**
2. **Thử compile code ESP32**
3. **Phải compile thành công** ✅

# 🔧 Fix Lỗi ESP32 Bootloader Missing

## ❌ Lỗi

```
Invalid value for 'FILENAME': Path
'{runtime.tools.esp32-arduino-libs.path}\esp32\bin\bootloader_qio_80m.elf'
does not exist.
```

## 🔍 Nguyên nhân

File `esp32-3.3.5-libs.zip` đã được download nhưng:
- Chưa được giải nén vào đúng vị trí
- Hoặc cấu trúc thư mục sau khi giải nén không đúng

## ✅ Giải pháp: Giải nén Thủ công

### Bước 1: Kiểm tra file ZIP

File cần có: `C:\Users\ASUS\Downloads\esp32-tools\esp32-3.3.5-libs.zip`

### Bước 2: Giải nén vào đúng thư mục

**Thư mục đích:**
```
C:\Users\ASUS\AppData\Local\Arduino15\packages\esp32\tools\esp32-arduino-libs\idf-release_v5.5-9bb7aa84-v2\
```

### Bước 3: Kiểm tra cấu trúc sau khi giải nén

Sau khi giải nén, phải có:
```
idf-release_v5.5-9bb7aa84-v2/
  ├── esp32/
  │   └── bin/
  │       └── bootloader_qio_80m.elf  ✅
  ├── esp32s2/
  ├── esp32s3/
  └── ...
```

### Bước 4: Kiểm tra file bootloader

```powershell
Test-Path "C:\Users\ASUS\AppData\Local\Arduino15\packages\esp32\tools\esp32-arduino-libs\idf-release_v5.5-9bb7aa84-v2\esp32\bin\bootloader_qio_80m.elf"
```

**Phải trả về:** `True`

## 🚀 Quick Fix (PowerShell)

```powershell
# Thư mục đích
$targetDir = "$env:LOCALAPPDATA\Arduino15\packages\esp32\tools\esp32-arduino-libs\idf-release_v5.5-9bb7aa84-v2"
$zipFile = "$env:USERPROFILE\Downloads\esp32-tools\esp32-3.3.5-libs.zip"

# Tạo thư mục
New-Item -ItemType Directory -Force -Path $targetDir | Out-Null

# Giải nén
$tempDir = "$env:TEMP\esp32-libs-temp"
Remove-Item -Recurse -Force $tempDir -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Force -Path $tempDir | Out-Null

Expand-Archive -Path $zipFile -DestinationPath $tempDir -Force

# Tìm và di chuyển nội dung
$libsDir = Get-ChildItem -Path $tempDir -Recurse -Directory -Filter "esp32-arduino-libs" | Select-Object -First 1
if ($libsDir) {
    Get-ChildItem -Path $libsDir.FullName | Move-Item -Destination $targetDir -Force
} else {
    # Nếu không có thư mục esp32-arduino-libs, di chuyển toàn bộ
    Get-ChildItem -Path $tempDir | Move-Item -Destination $targetDir -Force
}

# Xóa thư mục tạm
Start-Sleep -Seconds 2
Remove-Item -Recurse -Force $tempDir -ErrorAction SilentlyContinue

# Kiểm tra
$bootloader = "$targetDir\esp32\bin\bootloader_qio_80m.elf"
if (Test-Path $bootloader) {
    Write-Host "OK Bootloader da duoc cai dat!" -ForegroundColor Green
} else {
    Write-Host "WARNING: Khong tim thay bootloader" -ForegroundColor Yellow
    Write-Host "Thu tim trong toan bo thu muc..." -ForegroundColor Gray
    Get-ChildItem -Path $targetDir -Recurse -Filter "bootloader*.elf" | Select-Object -First 3
}
```

## 📋 Checklist

- [ ] Đã giải nén `esp32-3.3.5-libs.zip`
- [ ] Đã kiểm tra có thư mục `esp32\bin\` trong `idf-release_v5.5-9bb7aa84-v2\`
- [ ] Đã kiểm tra có file `bootloader_qio_80m.elf`
- [ ] Đã restart Arduino IDE
- [ ] Đã thử compile lại code

## 🎯 Sau khi fix

1. **Restart Arduino IDE**
2. **Thử compile code ESP32**
3. **Phải compile thành công** ✅


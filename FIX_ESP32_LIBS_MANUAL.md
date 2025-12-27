# 🔧 Fix ESP32 Libraries - Giải nén Thủ công

## ❌ Lỗi

```
Invalid value for 'FILENAME': Path
'{runtime.tools.esp32-arduino-libs.path}\esp32\bin\bootloader_qio_80m.elf'
does not exist.
```

## 🔍 Nguyên nhân

File `esp32-3.3.5-libs.zip` (~497MB) đã được download nhưng chưa được giải nén đúng cách.

## ✅ Giải pháp: Giải nén Thủ công bằng Windows Explorer

### Bước 1: Mở File Explorer

1. **Mở File Explorer** (Win + E)
2. **Điều hướng đến:**
   ```
   C:\Users\ASUS\Downloads\esp32-tools
   ```

### Bước 2: Giải nén File ZIP

1. **Right-click vào file:** `esp32-3.3.5-libs.zip`
2. **Chọn:** "Extract All..." hoặc "Extract to esp32-3.3.5-libs\"
3. **Giải nén vào thư mục tạm** (ví dụ: `C:\Users\ASUS\Downloads\esp32-tools\esp32-3.5-libs\`)

### Bước 3: Kiểm tra Cấu trúc sau khi giải nén

Sau khi giải nén, bạn sẽ thấy một trong các cấu trúc sau:

**Cấu trúc 1:**
```
esp32-3.3.5-libs/
  └── esp32-arduino-libs/
      ├── esp32/
      │   └── bin/
      │       └── bootloader_qio_80m.elf  ✅
      ├── esp32s2/
      └── esp32s3/
```

**Cấu trúc 2:**
```
esp32-3.3.5-libs/
  ├── esp32/
  │   └── bin/
  │       └── bootloader_qio_80m.elf  ✅
  ├── esp32s2/
  └── esp32s3/
```

### Bước 4: Copy vào đúng thư mục

**Thư mục đích:**
```
C:\Users\ASUS\AppData\Local\Arduino15\packages\esp32\tools\esp32-arduino-libs\idf-release_v5.5-9bb7aa84-v2\
```

**Cách làm:**

1. **Nếu có thư mục `esp32-arduino-libs` bên trong:**
   - Copy **toàn bộ nội dung** từ `esp32-arduino-libs\` vào `idf-release_v5.5-9bb7aa84-v2\`
   - Phải có: `esp32\`, `esp32s2\`, `esp32s3\`, v.v. trực tiếp trong `idf-release_v5.5-9bb7aa84-v2\`

2. **Nếu không có thư mục `esp32-arduino-libs`:**
   - Copy **toàn bộ nội dung** từ thư mục giải nén vào `idf-release_v5.5-9bb7aa84-v2\`

### Bước 5: Kiểm tra

Sau khi copy, cấu trúc phải là:

```
idf-release_v5.5-9bb7aa84-v2/
  ├── esp32/
  │   └── bin/
  │       └── bootloader_qio_80m.elf  ✅
  ├── esp32s2/
  └── esp32s3/
```

**Kiểm tra bằng PowerShell:**
```powershell
Test-Path "C:\Users\ASUS\AppData\Local\Arduino15\packages\esp32\tools\esp32-arduino-libs\idf-release_v5.5-9bb7aa84-v2\esp32\bin\bootloader_qio_80m.elf"
```

**Phải trả về:** `True`

## 🚀 Quick Command (PowerShell - Nếu giải nén thành công)

Nếu bạn đã giải nén vào `C:\Users\ASUS\Downloads\esp32-tools\esp32-3.3.5-libs\`:

```powershell
$sourceDir = "C:\Users\ASUS\Downloads\esp32-tools\esp32-3.3.5-libs"
$targetDir = "$env:LOCALAPPDATA\Arduino15\packages\esp32\tools\esp32-arduino-libs\idf-release_v5.5-9bb7aa84-v2"

# Xoa thu muc cu
if (Test-Path $targetDir) {
    Remove-Item -Recurse -Force $targetDir
}

# Tao thu muc moi
New-Item -ItemType Directory -Force -Path $targetDir | Out-Null

# Tim thu muc esp32-arduino-libs hoac esp32
$libsDir = Get-ChildItem -Path $sourceDir -Recurse -Directory -Filter "esp32-arduino-libs" | Select-Object -First 1
if ($libsDir) {
    # Copy tu esp32-arduino-libs
    Get-ChildItem -Path $libsDir.FullName | Copy-Item -Destination $targetDir -Recurse -Force
} else {
    # Copy truc tiep neu khong co thu muc long
    $esp32Dir = Get-ChildItem -Path $sourceDir -Directory -Filter "esp32" | Select-Object -First 1
    if ($esp32Dir) {
        Get-ChildItem -Path $sourceDir | Copy-Item -Destination $targetDir -Recurse -Force
    }
}

# Kiem tra
$bootloader = Join-Path $targetDir "esp32\bin\bootloader_qio_80m.elf"
if (Test-Path $bootloader) {
    Write-Host "OK Bootloader da duoc cai dat!" -ForegroundColor Green
} else {
    Write-Host "WARNING: Khong tim thay bootloader" -ForegroundColor Yellow
}
```

## 📋 Checklist

- [ ] Đã giải nén `esp32-3.3.5-libs.zip` bằng Windows Explorer
- [ ] Đã kiểm tra cấu trúc thư mục sau khi giải nén
- [ ] Đã copy nội dung vào `idf-release_v5.5-9bb7aa84-v2\`
- [ ] Đã kiểm tra có file `bootloader_qio_80m.elf` trong `esp32\bin\`
- [ ] Đã restart Arduino IDE
- [ ] Đã thử compile lại code

## 🎯 Sau khi fix

1. **Restart Arduino IDE**
2. **Thử compile code ESP32**
3. **Phải compile thành công** ✅

## 💡 Lưu ý

- File ZIP rất lớn (~497MB) - giải nén có thể mất 1-2 phút
- Đảm bảo có đủ dung lượng ổ đĩa (~1GB)
- Nếu giải nén bị lỗi, thử giải nén lại hoặc kiểm tra file ZIP có bị hỏng không

# 🔧 Fix ESP32 Libraries - Giải nén Thủ công

## ❌ Lỗi

```
Invalid value for 'FILENAME': Path
'{runtime.tools.esp32-arduino-libs.path}\esp32\bin\bootloader_qio_80m.elf'
does not exist.
```

## 🔍 Nguyên nhân

File `esp32-3.3.5-libs.zip` (~497MB) đã được download nhưng chưa được giải nén đúng cách.

## ✅ Giải pháp: Giải nén Thủ công bằng Windows Explorer

### Bước 1: Mở File Explorer

1. **Mở File Explorer** (Win + E)
2. **Điều hướng đến:**
   ```
   C:\Users\ASUS\Downloads\esp32-tools
   ```

### Bước 2: Giải nén File ZIP

1. **Right-click vào file:** `esp32-3.3.5-libs.zip`
2. **Chọn:** "Extract All..." hoặc "Extract to esp32-3.3.5-libs\"
3. **Giải nén vào thư mục tạm** (ví dụ: `C:\Users\ASUS\Downloads\esp32-tools\esp32-3.5-libs\`)

### Bước 3: Kiểm tra Cấu trúc sau khi giải nén

Sau khi giải nén, bạn sẽ thấy một trong các cấu trúc sau:

**Cấu trúc 1:**
```
esp32-3.3.5-libs/
  └── esp32-arduino-libs/
      ├── esp32/
      │   └── bin/
      │       └── bootloader_qio_80m.elf  ✅
      ├── esp32s2/
      └── esp32s3/
```

**Cấu trúc 2:**
```
esp32-3.3.5-libs/
  ├── esp32/
  │   └── bin/
  │       └── bootloader_qio_80m.elf  ✅
  ├── esp32s2/
  └── esp32s3/
```

### Bước 4: Copy vào đúng thư mục

**Thư mục đích:**
```
C:\Users\ASUS\AppData\Local\Arduino15\packages\esp32\tools\esp32-arduino-libs\idf-release_v5.5-9bb7aa84-v2\
```

**Cách làm:**

1. **Nếu có thư mục `esp32-arduino-libs` bên trong:**
   - Copy **toàn bộ nội dung** từ `esp32-arduino-libs\` vào `idf-release_v5.5-9bb7aa84-v2\`
   - Phải có: `esp32\`, `esp32s2\`, `esp32s3\`, v.v. trực tiếp trong `idf-release_v5.5-9bb7aa84-v2\`

2. **Nếu không có thư mục `esp32-arduino-libs`:**
   - Copy **toàn bộ nội dung** từ thư mục giải nén vào `idf-release_v5.5-9bb7aa84-v2\`

### Bước 5: Kiểm tra

Sau khi copy, cấu trúc phải là:

```
idf-release_v5.5-9bb7aa84-v2/
  ├── esp32/
  │   └── bin/
  │       └── bootloader_qio_80m.elf  ✅
  ├── esp32s2/
  └── esp32s3/
```

**Kiểm tra bằng PowerShell:**
```powershell
Test-Path "C:\Users\ASUS\AppData\Local\Arduino15\packages\esp32\tools\esp32-arduino-libs\idf-release_v5.5-9bb7aa84-v2\esp32\bin\bootloader_qio_80m.elf"
```

**Phải trả về:** `True`

## 🚀 Quick Command (PowerShell - Nếu giải nén thành công)

Nếu bạn đã giải nén vào `C:\Users\ASUS\Downloads\esp32-tools\esp32-3.3.5-libs\`:

```powershell
$sourceDir = "C:\Users\ASUS\Downloads\esp32-tools\esp32-3.3.5-libs"
$targetDir = "$env:LOCALAPPDATA\Arduino15\packages\esp32\tools\esp32-arduino-libs\idf-release_v5.5-9bb7aa84-v2"

# Xoa thu muc cu
if (Test-Path $targetDir) {
    Remove-Item -Recurse -Force $targetDir
}

# Tao thu muc moi
New-Item -ItemType Directory -Force -Path $targetDir | Out-Null

# Tim thu muc esp32-arduino-libs hoac esp32
$libsDir = Get-ChildItem -Path $sourceDir -Recurse -Directory -Filter "esp32-arduino-libs" | Select-Object -First 1
if ($libsDir) {
    # Copy tu esp32-arduino-libs
    Get-ChildItem -Path $libsDir.FullName | Copy-Item -Destination $targetDir -Recurse -Force
} else {
    # Copy truc tiep neu khong co thu muc long
    $esp32Dir = Get-ChildItem -Path $sourceDir -Directory -Filter "esp32" | Select-Object -First 1
    if ($esp32Dir) {
        Get-ChildItem -Path $sourceDir | Copy-Item -Destination $targetDir -Recurse -Force
    }
}

# Kiem tra
$bootloader = Join-Path $targetDir "esp32\bin\bootloader_qio_80m.elf"
if (Test-Path $bootloader) {
    Write-Host "OK Bootloader da duoc cai dat!" -ForegroundColor Green
} else {
    Write-Host "WARNING: Khong tim thay bootloader" -ForegroundColor Yellow
}
```

## 📋 Checklist

- [ ] Đã giải nén `esp32-3.3.5-libs.zip` bằng Windows Explorer
- [ ] Đã kiểm tra cấu trúc thư mục sau khi giải nén
- [ ] Đã copy nội dung vào `idf-release_v5.5-9bb7aa84-v2\`
- [ ] Đã kiểm tra có file `bootloader_qio_80m.elf` trong `esp32\bin\`
- [ ] Đã restart Arduino IDE
- [ ] Đã thử compile lại code

## 🎯 Sau khi fix

1. **Restart Arduino IDE**
2. **Thử compile code ESP32**
3. **Phải compile thành công** ✅

## 💡 Lưu ý

- File ZIP rất lớn (~497MB) - giải nén có thể mất 1-2 phút
- Đảm bảo có đủ dung lượng ổ đĩa (~1GB)
- Nếu giải nén bị lỗi, thử giải nén lại hoặc kiểm tra file ZIP có bị hỏng không


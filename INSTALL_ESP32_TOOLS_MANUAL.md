# 📦 Hướng dẫn Download & Cài ESP32 Tools Thủ công

## ❌ Khi nào cần làm thủ công?

- Arduino IDE vẫn timeout sau khi đã tăng `network.timeout=1800`
- Kết nối internet không ổn định
- Muốn cài nhanh hơn bằng cách download trước

## 📥 Bước 1: Download Tools từ GitHub

### Cách 1: Download từ GitHub Releases (Khuyến nghị)

1. **Truy cập:** https://github.com/espressif/arduino-esp32/releases/tag/3.3.5

2. **Chạy script để lấy URLs tự động:**
   ```powershell
   cd e:\SmartFarm
   .\get-esp32-tools-urls.ps1
   ```
   
   Script sẽ hiển thị danh sách URLs và lưu vào `Downloads\esp32-tools\download-urls.txt`

3. **Hoặc download các file tools chính:**
   - `esp32-3.3.5-libs.zip` (~486MB) - **QUAN TRỌNG**
   - `xtensa-esp-elf-14.2.0_20251107-x86_64-w64-mingw32.zip` (~378MB) - Compiler
   - `esptool-v5.1.0-windows-amd64.zip` (~57MB) - Upload tool
   - `x86_64-w64-mingw32-mklittlefs-db0513a.zip` (~0.4MB) - Filesystem tool

**Lưu ý:** 
- Chọn version phù hợp với ESP32 3.3.5
- Nếu không thấy version chính xác, tìm version gần nhất

### Cách 2: Download từ ESP32 Package Index

1. **Truy cập:** https://raw.githubusercontent.com/espressif/arduino-esp32/gh-pages/package_esp32_index.json

2. **Tìm các URL download tools:**
   - Tìm section `tools` trong file JSON
   - Copy các URL download cho Windows 64-bit

3. **Download từng file:**
   - Dùng trình duyệt hoặc download manager
   - Lưu vào thư mục tạm (ví dụ: `C:\Users\ASUS\Downloads\esp32-tools\`)

## 📂 Bước 2: Giải nén Tools vào đúng thư mục

### Thư mục đích:

```
C:\Users\ASUS\AppData\Local\Arduino15\packages\esp32\tools\
```

### Cấu trúc thư mục sau khi giải nén:

```
tools/
  ├── xtensa-esp32-elf-gcc/
  │   └── 8_4_0-esp-2021r2-patch3/
  │       └── xtensa-esp32-elf-gcc.exe
  ├── esptool_py/
  │   └── 4.5.1/
  │       └── esptool.py
  ├── mkspiffs/
  │   └── 0.2.3-arduino-esp32/
  │       └── mkspiffs.exe
  ├── mklittlefs/
  │   └── 3.0.0-gnu12-mc/
  │       └── mklittlefs.exe
  └── partitions/
      └── 2.0.0/
          └── gen_esp32part.exe
```

## 🚀 Bước 3: Script Tự động Giải nén (PowerShell)

Tạo script để tự động giải nén tools:

```powershell
# Script: install-esp32-tools-manual.ps1

$toolsPath = "$env:LOCALAPPDATA\Arduino15\packages\esp32\tools"
$downloadPath = "$env:USERPROFILE\Downloads\esp32-tools"

# Tạo thư mục tools nếu chưa có
New-Item -ItemType Directory -Force -Path $toolsPath | Out-Null

# Giải nén từng tool
$tools = @(
    @{Name="xtensa-esp32-elf-gcc"; Version="8_4_0-esp-2021r2-patch3"; File="xtensa-esp32-elf-gcc-8_4_0-esp-2021r2-patch3-win64.zip"},
    @{Name="esptool_py"; Version="4.5.1"; File="esptool_py-4.5.1.zip"},
    @{Name="mkspiffs"; Version="0.2.3-arduino-esp32"; File="mkspiffs-0.2.3-arduino-esp32-win64.zip"},
    @{Name="mklittlefs"; Version="3.0.0-gnu12-mc"; File="mklittlefs-3.0.0-gnu12-mc-win64.zip"},
    @{Name="partitions"; Version="2.0.0"; File="partitions-2.0.0.zip"}
)

foreach ($tool in $tools) {
    $zipFile = Join-Path $downloadPath $tool.File
    $targetDir = Join-Path $toolsPath $tool.Name
    $versionDir = Join-Path $targetDir $tool.Version
    
    if (Test-Path $zipFile) {
        Write-Host "Giai nen $($tool.Name)..." -ForegroundColor Cyan
        New-Item -ItemType Directory -Force -Path $targetDir | Out-Null
        Expand-Archive -Path $zipFile -DestinationPath $targetDir -Force
        
        # Kiểm tra và di chuyển nếu cần
        if (-not (Test-Path $versionDir)) {
            # Tìm thư mục version trong zip
            $extracted = Get-ChildItem $targetDir -Directory | Select-Object -First 1
            if ($extracted) {
                Rename-Item -Path $extracted.FullName -NewName $tool.Version
            }
        }
        Write-Host "  OK $($tool.Name)" -ForegroundColor Green
    } else {
        Write-Host "  WARNING: Khong tim thay $($tool.File)" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "Hoan tat! Kiem tra tools:" -ForegroundColor Green
Write-Host "  .\check-esp32-tools.ps1" -ForegroundColor Cyan
```

## 📋 Bước 4: Giải nén Thủ công (Nếu không dùng script)

### Tool 1: xtensa-esp32-elf-gcc

1. **Giải nén:** `xtensa-esp32-elf-gcc-8_4_0-esp-2021r2-patch3-win64.zip`
2. **Copy vào:**
   ```
   C:\Users\ASUS\AppData\Local\Arduino15\packages\esp32\tools\xtensa-esp32-elf-gcc\8_4_0-esp-2021r2-patch3\
   ```
3. **Kiểm tra:** Phải có file `xtensa-esp32-elf-gcc.exe` trong thư mục `bin/`

### Tool 2: esptool_py

1. **Giải nén:** `esptool_py-4.5.1.zip`
2. **Copy vào:**
   ```
   C:\Users\ASUS\AppData\Local\Arduino15\packages\esp32\tools\esptool_py\4.5.1\
   ```
3. **Kiểm tra:** Phải có file `esptool.py`

### Tool 3: mkspiffs

1. **Giải nén:** `mkspiffs-0.2.3-arduino-esp32-win64.zip`
2. **Copy vào:**
   ```
   C:\Users\ASUS\AppData\Local\Arduino15\packages\esp32\tools\mkspiffs\0.2.3-arduino-esp32\
   ```
3. **Kiểm tra:** Phải có file `mkspiffs.exe`

### Tool 4: mklittlefs

1. **Giải nén:** `mklittlefs-3.0.0-gnu12-mc-win64.zip`
2. **Copy vào:**
   ```
   C:\Users\ASUS\AppData\Local\Arduino15\packages\esp32\tools\mklittlefs\3.0.0-gnu12-mc\
   ```
3. **Kiểm tra:** Phải có file `mklittlefs.exe`

### Tool 5: partitions

1. **Giải nén:** `partitions-2.0.0.zip`
2. **Copy vào:**
   ```
   C:\Users\ASUS\AppData\Local\Arduino15\packages\esp32\tools\partitions\2.0.0\
   ```
3. **Kiểm tra:** Phải có file `gen_esp32part.exe`

## ✅ Bước 5: Kiểm tra sau khi cài

Chạy script kiểm tra:

```powershell
cd e:\SmartFarm
.\check-esp32-tools.ps1
```

**Phải thấy:**
- ✅ `xtensa-esp32-elf-gcc` (versions: 8_4_0-esp-2021r2-patch3)
- ✅ `esptool_py` (versions: 4.5.1)
- ✅ `mkspiffs` (versions: 0.2.3-arduino-esp32)
- ✅ `mklittlefs` (versions: 3.0.0-gnu12-mc)
- ✅ `partitions` (versions: 2.0.0)

## 🔧 Bước 6: Restart Arduino IDE và Test

1. **Restart Arduino IDE** (đóng và mở lại)
2. **Tools → Board → ESP32 Dev Module**
3. **Thử compile code:**
   ```cpp
   void setup() {
     Serial.begin(115200);
     Serial.println("ESP32 Test");
   }
   
   void loop() {
     delay(1000);
   }
   ```
4. **Phải compile thành công** ✅

## 🔍 Troubleshooting

### Tools không được nhận diện:

1. **Kiểm tra đường dẫn:**
   ```powershell
   dir "C:\Users\ASUS\AppData\Local\Arduino15\packages\esp32\tools"
   ```

2. **Kiểm tra version đúng:**
   - Mở file `platform.txt`:
     ```
     C:\Users\ASUS\AppData\Local\Arduino15\packages\esp32\hardware\esp32\3.3.5\platform.txt
     ```
   - Tìm các dòng `runtime.tools.*.path` để xem version cần

3. **Kiểm tra file thực thi:**
   - Phải có file `.exe` hoặc `.py` trong thư mục version
   - Quyền truy cập phải đúng

### Vẫn lỗi compile:

1. **Xóa cache Arduino IDE:**
   ```powershell
   Remove-Item -Recurse -Force "$env:LOCALAPPDATA\Arduino15\staging\packages\*"
   ```

2. **Restart Arduino IDE**

3. **Thử compile lại**

## 📚 Tài liệu tham khảo

- [ESP32 Arduino Core Releases](https://github.com/espressif/arduino-esp32/releases)
- [ESP32 Tools Package Index](https://raw.githubusercontent.com/espressif/arduino-esp32/gh-pages/package_esp32_index.json)
- [ESP32 Platform.txt Reference](https://github.com/espressif/arduino-esp32/blob/master/platform.txt)

## 💡 Mẹo

1. **Dùng download manager** (IDM, FDM) để download nhanh hơn
2. **Download vào giờ ít người dùng** để tránh server quá tải
3. **Lưu các file ZIP** để dùng lại sau này
4. **Kiểm tra MD5/SHA256** của file download (nếu có) để đảm bảo file không bị lỗi

# 📦 Hướng dẫn Download & Cài ESP32 Tools Thủ công

## ❌ Khi nào cần làm thủ công?

- Arduino IDE vẫn timeout sau khi đã tăng `network.timeout=1800`
- Kết nối internet không ổn định
- Muốn cài nhanh hơn bằng cách download trước

## 📥 Bước 1: Download Tools từ GitHub

### Cách 1: Download từ GitHub Releases (Khuyến nghị)

1. **Truy cập:** https://github.com/espressif/arduino-esp32/releases/tag/3.3.5

2. **Chạy script để lấy URLs tự động:**
   ```powershell
   cd e:\SmartFarm
   .\get-esp32-tools-urls.ps1
   ```
   
   Script sẽ hiển thị danh sách URLs và lưu vào `Downloads\esp32-tools\download-urls.txt`

3. **Hoặc download các file tools chính:**
   - `esp32-3.3.5-libs.zip` (~486MB) - **QUAN TRỌNG**
   - `xtensa-esp-elf-14.2.0_20251107-x86_64-w64-mingw32.zip` (~378MB) - Compiler
   - `esptool-v5.1.0-windows-amd64.zip` (~57MB) - Upload tool
   - `x86_64-w64-mingw32-mklittlefs-db0513a.zip` (~0.4MB) - Filesystem tool

**Lưu ý:** 
- Chọn version phù hợp với ESP32 3.3.5
- Nếu không thấy version chính xác, tìm version gần nhất

### Cách 2: Download từ ESP32 Package Index

1. **Truy cập:** https://raw.githubusercontent.com/espressif/arduino-esp32/gh-pages/package_esp32_index.json

2. **Tìm các URL download tools:**
   - Tìm section `tools` trong file JSON
   - Copy các URL download cho Windows 64-bit

3. **Download từng file:**
   - Dùng trình duyệt hoặc download manager
   - Lưu vào thư mục tạm (ví dụ: `C:\Users\ASUS\Downloads\esp32-tools\`)

## 📂 Bước 2: Giải nén Tools vào đúng thư mục

### Thư mục đích:

```
C:\Users\ASUS\AppData\Local\Arduino15\packages\esp32\tools\
```

### Cấu trúc thư mục sau khi giải nén:

```
tools/
  ├── xtensa-esp32-elf-gcc/
  │   └── 8_4_0-esp-2021r2-patch3/
  │       └── xtensa-esp32-elf-gcc.exe
  ├── esptool_py/
  │   └── 4.5.1/
  │       └── esptool.py
  ├── mkspiffs/
  │   └── 0.2.3-arduino-esp32/
  │       └── mkspiffs.exe
  ├── mklittlefs/
  │   └── 3.0.0-gnu12-mc/
  │       └── mklittlefs.exe
  └── partitions/
      └── 2.0.0/
          └── gen_esp32part.exe
```

## 🚀 Bước 3: Script Tự động Giải nén (PowerShell)

Tạo script để tự động giải nén tools:

```powershell
# Script: install-esp32-tools-manual.ps1

$toolsPath = "$env:LOCALAPPDATA\Arduino15\packages\esp32\tools"
$downloadPath = "$env:USERPROFILE\Downloads\esp32-tools"

# Tạo thư mục tools nếu chưa có
New-Item -ItemType Directory -Force -Path $toolsPath | Out-Null

# Giải nén từng tool
$tools = @(
    @{Name="xtensa-esp32-elf-gcc"; Version="8_4_0-esp-2021r2-patch3"; File="xtensa-esp32-elf-gcc-8_4_0-esp-2021r2-patch3-win64.zip"},
    @{Name="esptool_py"; Version="4.5.1"; File="esptool_py-4.5.1.zip"},
    @{Name="mkspiffs"; Version="0.2.3-arduino-esp32"; File="mkspiffs-0.2.3-arduino-esp32-win64.zip"},
    @{Name="mklittlefs"; Version="3.0.0-gnu12-mc"; File="mklittlefs-3.0.0-gnu12-mc-win64.zip"},
    @{Name="partitions"; Version="2.0.0"; File="partitions-2.0.0.zip"}
)

foreach ($tool in $tools) {
    $zipFile = Join-Path $downloadPath $tool.File
    $targetDir = Join-Path $toolsPath $tool.Name
    $versionDir = Join-Path $targetDir $tool.Version
    
    if (Test-Path $zipFile) {
        Write-Host "Giai nen $($tool.Name)..." -ForegroundColor Cyan
        New-Item -ItemType Directory -Force -Path $targetDir | Out-Null
        Expand-Archive -Path $zipFile -DestinationPath $targetDir -Force
        
        # Kiểm tra và di chuyển nếu cần
        if (-not (Test-Path $versionDir)) {
            # Tìm thư mục version trong zip
            $extracted = Get-ChildItem $targetDir -Directory | Select-Object -First 1
            if ($extracted) {
                Rename-Item -Path $extracted.FullName -NewName $tool.Version
            }
        }
        Write-Host "  OK $($tool.Name)" -ForegroundColor Green
    } else {
        Write-Host "  WARNING: Khong tim thay $($tool.File)" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "Hoan tat! Kiem tra tools:" -ForegroundColor Green
Write-Host "  .\check-esp32-tools.ps1" -ForegroundColor Cyan
```

## 📋 Bước 4: Giải nén Thủ công (Nếu không dùng script)

### Tool 1: xtensa-esp32-elf-gcc

1. **Giải nén:** `xtensa-esp32-elf-gcc-8_4_0-esp-2021r2-patch3-win64.zip`
2. **Copy vào:**
   ```
   C:\Users\ASUS\AppData\Local\Arduino15\packages\esp32\tools\xtensa-esp32-elf-gcc\8_4_0-esp-2021r2-patch3\
   ```
3. **Kiểm tra:** Phải có file `xtensa-esp32-elf-gcc.exe` trong thư mục `bin/`

### Tool 2: esptool_py

1. **Giải nén:** `esptool_py-4.5.1.zip`
2. **Copy vào:**
   ```
   C:\Users\ASUS\AppData\Local\Arduino15\packages\esp32\tools\esptool_py\4.5.1\
   ```
3. **Kiểm tra:** Phải có file `esptool.py`

### Tool 3: mkspiffs

1. **Giải nén:** `mkspiffs-0.2.3-arduino-esp32-win64.zip`
2. **Copy vào:**
   ```
   C:\Users\ASUS\AppData\Local\Arduino15\packages\esp32\tools\mkspiffs\0.2.3-arduino-esp32\
   ```
3. **Kiểm tra:** Phải có file `mkspiffs.exe`

### Tool 4: mklittlefs

1. **Giải nén:** `mklittlefs-3.0.0-gnu12-mc-win64.zip`
2. **Copy vào:**
   ```
   C:\Users\ASUS\AppData\Local\Arduino15\packages\esp32\tools\mklittlefs\3.0.0-gnu12-mc\
   ```
3. **Kiểm tra:** Phải có file `mklittlefs.exe`

### Tool 5: partitions

1. **Giải nén:** `partitions-2.0.0.zip`
2. **Copy vào:**
   ```
   C:\Users\ASUS\AppData\Local\Arduino15\packages\esp32\tools\partitions\2.0.0\
   ```
3. **Kiểm tra:** Phải có file `gen_esp32part.exe`

## ✅ Bước 5: Kiểm tra sau khi cài

Chạy script kiểm tra:

```powershell
cd e:\SmartFarm
.\check-esp32-tools.ps1
```

**Phải thấy:**
- ✅ `xtensa-esp32-elf-gcc` (versions: 8_4_0-esp-2021r2-patch3)
- ✅ `esptool_py` (versions: 4.5.1)
- ✅ `mkspiffs` (versions: 0.2.3-arduino-esp32)
- ✅ `mklittlefs` (versions: 3.0.0-gnu12-mc)
- ✅ `partitions` (versions: 2.0.0)

## 🔧 Bước 6: Restart Arduino IDE và Test

1. **Restart Arduino IDE** (đóng và mở lại)
2. **Tools → Board → ESP32 Dev Module**
3. **Thử compile code:**
   ```cpp
   void setup() {
     Serial.begin(115200);
     Serial.println("ESP32 Test");
   }
   
   void loop() {
     delay(1000);
   }
   ```
4. **Phải compile thành công** ✅

## 🔍 Troubleshooting

### Tools không được nhận diện:

1. **Kiểm tra đường dẫn:**
   ```powershell
   dir "C:\Users\ASUS\AppData\Local\Arduino15\packages\esp32\tools"
   ```

2. **Kiểm tra version đúng:**
   - Mở file `platform.txt`:
     ```
     C:\Users\ASUS\AppData\Local\Arduino15\packages\esp32\hardware\esp32\3.3.5\platform.txt
     ```
   - Tìm các dòng `runtime.tools.*.path` để xem version cần

3. **Kiểm tra file thực thi:**
   - Phải có file `.exe` hoặc `.py` trong thư mục version
   - Quyền truy cập phải đúng

### Vẫn lỗi compile:

1. **Xóa cache Arduino IDE:**
   ```powershell
   Remove-Item -Recurse -Force "$env:LOCALAPPDATA\Arduino15\staging\packages\*"
   ```

2. **Restart Arduino IDE**

3. **Thử compile lại**

## 📚 Tài liệu tham khảo

- [ESP32 Arduino Core Releases](https://github.com/espressif/arduino-esp32/releases)
- [ESP32 Tools Package Index](https://raw.githubusercontent.com/espressif/arduino-esp32/gh-pages/package_esp32_index.json)
- [ESP32 Platform.txt Reference](https://github.com/espressif/arduino-esp32/blob/master/platform.txt)

## 💡 Mẹo

1. **Dùng download manager** (IDM, FDM) để download nhanh hơn
2. **Download vào giờ ít người dùng** để tránh server quá tải
3. **Lưu các file ZIP** để dùng lại sau này
4. **Kiểm tra MD5/SHA256** của file download (nếu có) để đảm bảo file không bị lỗi


# PowerShell Script de tao symbolic link tu o C: den o E:
# Chay: .\create-esp32-libs-symlink.ps1
# 
# Yeu cau: Da giai nen esp32-3.3.5-libs.zip vao E:\SmartFarm\esp32-3.3.5-libs\
# Yeu cau: Chay PowerShell as Administrator

Write-Host "Tao Symbolic Link cho ESP32 Libraries" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""

# Kiểm tra quyền Administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "ERROR: Script can chay voi quyen Administrator!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Huong dan:" -ForegroundColor Cyan
    Write-Host "   1. Right-click vao PowerShell" -ForegroundColor White
    Write-Host "   2. Chon 'Run as Administrator'" -ForegroundColor White
    Write-Host "   3. Chay lai script nay" -ForegroundColor White
    exit 1
}

Write-Host "OK Da co quyen Administrator" -ForegroundColor Green
Write-Host ""

# Thư mục nguồn (trên ổ E:)
# Tự động tìm trong esp32-tools hoặc SmartFarm
$possibleDirs = @(
    "E:\esp32-tools\esp32-3.3.5-libs",
    "E:\SmartFarm\esp32-tools\esp32-3.3.5-libs",
    "E:\SmartFarm\esp32-3.3.5-libs"
)

$sourceDir = $null
foreach ($dir in $possibleDirs) {
    if (Test-Path $dir) {
        $sourceDir = $dir
        break
    }
}

if (-not $sourceDir) {
    # Thử tìm trong toàn bộ thư mục esp32-tools
    $toolsDirs = @("E:\esp32-tools", "E:\SmartFarm\esp32-tools")
    foreach ($toolsDir in $toolsDirs) {
        if (Test-Path $toolsDir) {
            $found = Get-ChildItem -Path $toolsDir -Directory -Filter "*esp32*3.3.5*libs*" -ErrorAction SilentlyContinue | Select-Object -First 1
            if ($found) {
                $sourceDir = $found.FullName
                break
            }
        }
    }
}

# Kiểm tra thư mục nguồn
if (-not $sourceDir -or -not (Test-Path $sourceDir)) {
    Write-Host "ERROR: Khong tim thay thu muc nguon!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Da tim trong:" -ForegroundColor Yellow
    foreach ($dir in $possibleDirs) {
        Write-Host "   - $dir" -ForegroundColor Gray
    }
    Write-Host ""
    Write-Host "Huong dan:" -ForegroundColor Cyan
    Write-Host "   1. Giai nen esp32-3.3.5-libs.zip vao E:\esp32-tools\" -ForegroundColor White
    Write-Host "      Hoac: E:\SmartFarm\esp32-tools\" -ForegroundColor White
    Write-Host "      Hoac: E:\SmartFarm\" -ForegroundColor White
    Write-Host "   2. Chay lai script nay" -ForegroundColor White
    exit 1
}

Write-Host "Tim thay thu muc nguon: $sourceDir" -ForegroundColor Green
Write-Host ""

# Tìm thư mục esp32-arduino-libs hoặc esp32
$libsDir = Get-ChildItem -Path $sourceDir -Recurse -Directory -Filter "esp32-arduino-libs" -ErrorAction SilentlyContinue | Select-Object -First 1

if ($libsDir) {
    $actualSourceDir = $libsDir.FullName
    Write-Host "Tim thay thu muc esp32-arduino-libs" -ForegroundColor Green
    Write-Host "   Duong dan: $actualSourceDir" -ForegroundColor Gray
} else {
    # Kiểm tra có thư mục esp32 không
    $esp32Dir = Get-ChildItem -Path $sourceDir -Directory -Filter "esp32" -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($esp32Dir) {
        $actualSourceDir = $sourceDir
        Write-Host "Tim thay thu muc esp32 trong thu muc goc" -ForegroundColor Green
        Write-Host "   Duong dan: $actualSourceDir" -ForegroundColor Gray
    } else {
        Write-Host "ERROR: Khong tim thay thu muc esp32 hoac esp32-arduino-libs!" -ForegroundColor Red
        Write-Host "   Vui long kiem tra lai cau truc thu muc sau khi giai nen" -ForegroundColor Yellow
        exit 1
    }
}

Write-Host ""

# Kiểm tra bootloader
$bootloader = Join-Path $actualSourceDir "esp32\bin\bootloader_qio_80m.elf"
if (-not (Test-Path $bootloader)) {
    Write-Host "WARNING: Khong tim thay bootloader_qio_80m.elf" -ForegroundColor Yellow
    Write-Host "   Dang tim trong toan bo thu muc..." -ForegroundColor Gray
    $found = Get-ChildItem -Path $actualSourceDir -Recurse -Filter "bootloader*.elf" -ErrorAction SilentlyContinue | Select-Object -First 1
    if (-not $found) {
        Write-Host "   ERROR: Khong tim thay bootloader nao!" -ForegroundColor Red
        Write-Host "   Vui long kiem tra lai cau truc thu muc sau khi giai nen" -ForegroundColor Yellow
        exit 1
    }
} else {
    Write-Host "OK Tim thay bootloader_qio_80m.elf" -ForegroundColor Green
}

Write-Host ""

# Thư mục đích (trên ổ C:)
$targetDir = "$env:LOCALAPPDATA\Arduino15\packages\esp32\tools\esp32-arduino-libs\idf-release_v5.5-9bb7aa84-v2"

# Xóa thư mục cũ nếu có (nếu là thư mục thật, không phải symlink)
if (Test-Path $targetDir) {
    $item = Get-Item $targetDir -Force
    if ($item.LinkType -eq "SymbolicLink") {
        Write-Host "Tim thay symbolic link cu, dang xoa..." -ForegroundColor Yellow
        Remove-Item -Path $targetDir -Force -ErrorAction SilentlyContinue
    } else {
        Write-Host "Tim thay thu muc cu (khong phai symlink), dang xoa..." -ForegroundColor Yellow
        Remove-Item -Recurse -Force $targetDir -ErrorAction SilentlyContinue
    }
    Start-Sleep -Seconds 1
}

# Tạo thư mục cha nếu chưa có
$parentDir = Split-Path $targetDir -Parent
if (-not (Test-Path $parentDir)) {
    Write-Host "Tao thu muc cha..." -ForegroundColor Cyan
    New-Item -ItemType Directory -Force -Path $parentDir | Out-Null
}

# Tạo symbolic link
Write-Host "Tao symbolic link..." -ForegroundColor Cyan
Write-Host "   Tu: $actualSourceDir" -ForegroundColor Gray
Write-Host "   Den: $targetDir" -ForegroundColor Gray
Write-Host ""

try {
    New-Item -ItemType SymbolicLink -Path $targetDir -Target $actualSourceDir -Force | Out-Null
    Write-Host "OK Da tao symbolic link thanh cong!" -ForegroundColor Green
} catch {
    Write-Host "ERROR: Khong the tao symbolic link!" -ForegroundColor Red
    Write-Host "   Loi: $_" -ForegroundColor Yellow
    exit 1
}

# Kiểm tra lại
Write-Host ""
Write-Host "Kiem tra lai..." -ForegroundColor Cyan
if (Test-Path $targetDir) {
    $item = Get-Item $targetDir -Force
    if ($item.LinkType -eq "SymbolicLink") {
        Write-Host "   OK Symbolic link da duoc tao" -ForegroundColor Green
        Write-Host "   Target: $($item.Target)" -ForegroundColor Gray
    } else {
        Write-Host "   WARNING: Khong phai symbolic link!" -ForegroundColor Yellow
    }
    
    # Kiểm tra bootloader qua symlink
    $bootloaderViaLink = Join-Path $targetDir "esp32\bin\bootloader_qio_80m.elf"
    if (Test-Path $bootloaderViaLink) {
        Write-Host "   OK Bootloader co the truy cap qua symlink" -ForegroundColor Green
    } else {
        Write-Host "   WARNING: Khong the truy cap bootloader qua symlink" -ForegroundColor Yellow
    }
} else {
    Write-Host "   ERROR: Symbolic link khong ton tai!" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Hoan tat!" -ForegroundColor Green
Write-Host ""
Write-Host "ESP32 libraries da duoc luu tren o E: va Arduino IDE se su dung qua symbolic link" -ForegroundColor Cyan
Write-Host ""
Write-Host "Sau do:" -ForegroundColor Yellow
Write-Host "   1. Restart Arduino IDE" -ForegroundColor White
Write-Host "   2. Thu compile code ESP32" -ForegroundColor White
Write-Host ""
Write-Host "Luu y: Khong xoa thu muc $actualSourceDir tren o E:" -ForegroundColor Yellow

# PowerShell Script de tao symbolic link tu o C: den o E:
# Chay: .\create-esp32-libs-symlink.ps1
# 
# Yeu cau: Da giai nen esp32-3.3.5-libs.zip vao E:\SmartFarm\esp32-3.3.5-libs\
# Yeu cau: Chay PowerShell as Administrator

Write-Host "Tao Symbolic Link cho ESP32 Libraries" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""

# Kiểm tra quyền Administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "ERROR: Script can chay voi quyen Administrator!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Huong dan:" -ForegroundColor Cyan
    Write-Host "   1. Right-click vao PowerShell" -ForegroundColor White
    Write-Host "   2. Chon 'Run as Administrator'" -ForegroundColor White
    Write-Host "   3. Chay lai script nay" -ForegroundColor White
    exit 1
}

Write-Host "OK Da co quyen Administrator" -ForegroundColor Green
Write-Host ""

# Thư mục nguồn (trên ổ E:)
# Tự động tìm trong esp32-tools hoặc SmartFarm
$possibleDirs = @(
    "E:\esp32-tools\esp32-3.3.5-libs",
    "E:\SmartFarm\esp32-tools\esp32-3.3.5-libs",
    "E:\SmartFarm\esp32-3.3.5-libs"
)

$sourceDir = $null
foreach ($dir in $possibleDirs) {
    if (Test-Path $dir) {
        $sourceDir = $dir
        break
    }
}

if (-not $sourceDir) {
    # Thử tìm trong toàn bộ thư mục esp32-tools
    $toolsDirs = @("E:\esp32-tools", "E:\SmartFarm\esp32-tools")
    foreach ($toolsDir in $toolsDirs) {
        if (Test-Path $toolsDir) {
            $found = Get-ChildItem -Path $toolsDir -Directory -Filter "*esp32*3.3.5*libs*" -ErrorAction SilentlyContinue | Select-Object -First 1
            if ($found) {
                $sourceDir = $found.FullName
                break
            }
        }
    }
}

# Kiểm tra thư mục nguồn
if (-not $sourceDir -or -not (Test-Path $sourceDir)) {
    Write-Host "ERROR: Khong tim thay thu muc nguon!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Da tim trong:" -ForegroundColor Yellow
    foreach ($dir in $possibleDirs) {
        Write-Host "   - $dir" -ForegroundColor Gray
    }
    Write-Host ""
    Write-Host "Huong dan:" -ForegroundColor Cyan
    Write-Host "   1. Giai nen esp32-3.3.5-libs.zip vao E:\esp32-tools\" -ForegroundColor White
    Write-Host "      Hoac: E:\SmartFarm\esp32-tools\" -ForegroundColor White
    Write-Host "      Hoac: E:\SmartFarm\" -ForegroundColor White
    Write-Host "   2. Chay lai script nay" -ForegroundColor White
    exit 1
}

Write-Host "Tim thay thu muc nguon: $sourceDir" -ForegroundColor Green
Write-Host ""

# Tìm thư mục esp32-arduino-libs hoặc esp32
$libsDir = Get-ChildItem -Path $sourceDir -Recurse -Directory -Filter "esp32-arduino-libs" -ErrorAction SilentlyContinue | Select-Object -First 1

if ($libsDir) {
    $actualSourceDir = $libsDir.FullName
    Write-Host "Tim thay thu muc esp32-arduino-libs" -ForegroundColor Green
    Write-Host "   Duong dan: $actualSourceDir" -ForegroundColor Gray
} else {
    # Kiểm tra có thư mục esp32 không
    $esp32Dir = Get-ChildItem -Path $sourceDir -Directory -Filter "esp32" -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($esp32Dir) {
        $actualSourceDir = $sourceDir
        Write-Host "Tim thay thu muc esp32 trong thu muc goc" -ForegroundColor Green
        Write-Host "   Duong dan: $actualSourceDir" -ForegroundColor Gray
    } else {
        Write-Host "ERROR: Khong tim thay thu muc esp32 hoac esp32-arduino-libs!" -ForegroundColor Red
        Write-Host "   Vui long kiem tra lai cau truc thu muc sau khi giai nen" -ForegroundColor Yellow
        exit 1
    }
}

Write-Host ""

# Kiểm tra bootloader
$bootloader = Join-Path $actualSourceDir "esp32\bin\bootloader_qio_80m.elf"
if (-not (Test-Path $bootloader)) {
    Write-Host "WARNING: Khong tim thay bootloader_qio_80m.elf" -ForegroundColor Yellow
    Write-Host "   Dang tim trong toan bo thu muc..." -ForegroundColor Gray
    $found = Get-ChildItem -Path $actualSourceDir -Recurse -Filter "bootloader*.elf" -ErrorAction SilentlyContinue | Select-Object -First 1
    if (-not $found) {
        Write-Host "   ERROR: Khong tim thay bootloader nao!" -ForegroundColor Red
        Write-Host "   Vui long kiem tra lai cau truc thu muc sau khi giai nen" -ForegroundColor Yellow
        exit 1
    }
} else {
    Write-Host "OK Tim thay bootloader_qio_80m.elf" -ForegroundColor Green
}

Write-Host ""

# Thư mục đích (trên ổ C:)
$targetDir = "$env:LOCALAPPDATA\Arduino15\packages\esp32\tools\esp32-arduino-libs\idf-release_v5.5-9bb7aa84-v2"

# Xóa thư mục cũ nếu có (nếu là thư mục thật, không phải symlink)
if (Test-Path $targetDir) {
    $item = Get-Item $targetDir -Force
    if ($item.LinkType -eq "SymbolicLink") {
        Write-Host "Tim thay symbolic link cu, dang xoa..." -ForegroundColor Yellow
        Remove-Item -Path $targetDir -Force -ErrorAction SilentlyContinue
    } else {
        Write-Host "Tim thay thu muc cu (khong phai symlink), dang xoa..." -ForegroundColor Yellow
        Remove-Item -Recurse -Force $targetDir -ErrorAction SilentlyContinue
    }
    Start-Sleep -Seconds 1
}

# Tạo thư mục cha nếu chưa có
$parentDir = Split-Path $targetDir -Parent
if (-not (Test-Path $parentDir)) {
    Write-Host "Tao thu muc cha..." -ForegroundColor Cyan
    New-Item -ItemType Directory -Force -Path $parentDir | Out-Null
}

# Tạo symbolic link
Write-Host "Tao symbolic link..." -ForegroundColor Cyan
Write-Host "   Tu: $actualSourceDir" -ForegroundColor Gray
Write-Host "   Den: $targetDir" -ForegroundColor Gray
Write-Host ""

try {
    New-Item -ItemType SymbolicLink -Path $targetDir -Target $actualSourceDir -Force | Out-Null
    Write-Host "OK Da tao symbolic link thanh cong!" -ForegroundColor Green
} catch {
    Write-Host "ERROR: Khong the tao symbolic link!" -ForegroundColor Red
    Write-Host "   Loi: $_" -ForegroundColor Yellow
    exit 1
}

# Kiểm tra lại
Write-Host ""
Write-Host "Kiem tra lai..." -ForegroundColor Cyan
if (Test-Path $targetDir) {
    $item = Get-Item $targetDir -Force
    if ($item.LinkType -eq "SymbolicLink") {
        Write-Host "   OK Symbolic link da duoc tao" -ForegroundColor Green
        Write-Host "   Target: $($item.Target)" -ForegroundColor Gray
    } else {
        Write-Host "   WARNING: Khong phai symbolic link!" -ForegroundColor Yellow
    }
    
    # Kiểm tra bootloader qua symlink
    $bootloaderViaLink = Join-Path $targetDir "esp32\bin\bootloader_qio_80m.elf"
    if (Test-Path $bootloaderViaLink) {
        Write-Host "   OK Bootloader co the truy cap qua symlink" -ForegroundColor Green
    } else {
        Write-Host "   WARNING: Khong the truy cap bootloader qua symlink" -ForegroundColor Yellow
    }
} else {
    Write-Host "   ERROR: Symbolic link khong ton tai!" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Hoan tat!" -ForegroundColor Green
Write-Host ""
Write-Host "ESP32 libraries da duoc luu tren o E: va Arduino IDE se su dung qua symbolic link" -ForegroundColor Cyan
Write-Host ""
Write-Host "Sau do:" -ForegroundColor Yellow
Write-Host "   1. Restart Arduino IDE" -ForegroundColor White
Write-Host "   2. Thu compile code ESP32" -ForegroundColor White
Write-Host ""
Write-Host "Luu y: Khong xoa thu muc $actualSourceDir tren o E:" -ForegroundColor Yellow


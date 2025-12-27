# PowerShell Script de copy ESP32 libraries tu o E: sang o C:
# Chay: .\copy-esp32-libs-from-e.ps1
# 
# Yeu cau: Da giai nen esp32-3.3.5-libs.zip vao E:\SmartFarm\esp32-3.3.5-libs\

Write-Host "Copy ESP32 Libraries tu o E: sang o C:" -ForegroundColor Cyan
Write-Host "=======================================" -ForegroundColor Cyan
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

# Thư mục đích (trên ổ C:)
$targetDir = "$env:LOCALAPPDATA\Arduino15\packages\esp32\tools\esp32-arduino-libs\idf-release_v5.5-9bb7aa84-v2"

# Kiểm tra dung lượng ổ C:
$cDrive = Get-PSDrive C
$freeSpaceGB = [math]::Round($cDrive.Free / 1GB, 2)
Write-Host "Dung luong o C: con lai: $freeSpaceGB GB" -ForegroundColor Cyan

if ($freeSpaceGB -lt 1) {
    Write-Host "WARNING: O C: chi con $freeSpaceGB GB - co the khong du!" -ForegroundColor Yellow
    Write-Host "   Khuyen nghi: Don dep o C: truoc khi tiep tuc" -ForegroundColor Yellow
    Write-Host ""
    $continue = Read-Host "Ban co muon tiep tuc? (y/n)"
    if ($continue -ne "y" -and $continue -ne "Y") {
        Write-Host "Da huy" -ForegroundColor Yellow
        exit 0
    }
}

Write-Host ""

# Xóa thư mục cũ nếu có
if (Test-Path $targetDir) {
    Write-Host "Xoa thu muc cu..." -ForegroundColor Yellow
    Remove-Item -Recurse -Force $targetDir -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 1
}

# Tạo thư mục mới
Write-Host "Tao thu muc moi..." -ForegroundColor Cyan
New-Item -ItemType Directory -Force -Path $targetDir | Out-Null
Write-Host "   OK Thu muc: $targetDir" -ForegroundColor Green
Write-Host ""

# Tìm thư mục esp32-arduino-libs
Write-Host "Tim thu muc esp32-arduino-libs..." -ForegroundColor Cyan
$libsDir = Get-ChildItem -Path $sourceDir -Recurse -Directory -Filter "esp32-arduino-libs" -ErrorAction SilentlyContinue | Select-Object -First 1

if ($libsDir) {
    Write-Host "   Tim thay: $($libsDir.FullName)" -ForegroundColor Green
    Write-Host "   Dang copy tu E: sang C:..." -ForegroundColor Cyan
    # Copy từ esp32-arduino-libs
    $items = Get-ChildItem -Path $libsDir.FullName
    $totalItems = $items.Count
    $currentItem = 0
    
    foreach ($item in $items) {
        $currentItem++
        $percent = [math]::Round(($currentItem / $totalItems) * 100, 1)
        Write-Progress -Activity "Dang copy..." -Status "$currentItem / $totalItems ($percent%)" -PercentComplete $percent
        Copy-Item -Path $item.FullName -Destination $targetDir -Recurse -Force -ErrorAction SilentlyContinue
    }
    Write-Progress -Activity "Dang copy..." -Completed
} else {
    Write-Host "   Khong tim thay thu muc esp32-arduino-libs" -ForegroundColor Yellow
    Write-Host "   Copy truc tiep tu thu muc goc..." -ForegroundColor Cyan
    
    # Kiểm tra có thư mục esp32 không
    $esp32Dir = Get-ChildItem -Path $sourceDir -Directory -Filter "esp32" -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($esp32Dir) {
        Write-Host "   Tim thay thu muc esp32" -ForegroundColor Green
        $items = Get-ChildItem -Path $sourceDir
        $totalItems = $items.Count
        $currentItem = 0
        
        foreach ($item in $items) {
            $currentItem++
            $percent = [math]::Round(($currentItem / $totalItems) * 100, 1)
            Write-Progress -Activity "Dang copy..." -Status "$currentItem / $totalItems ($percent%)" -PercentComplete $percent
            Copy-Item -Path $item.FullName -Destination $targetDir -Recurse -Force -ErrorAction SilentlyContinue
        }
        Write-Progress -Activity "Dang copy..." -Completed
    } else {
        Write-Host "   ERROR: Khong tim thay thu muc esp32!" -ForegroundColor Red
        Write-Host "   Vui long kiem tra lai cau truc thu muc sau khi giai nen" -ForegroundColor Yellow
        exit 1
    }
}

Write-Host ""
Write-Host "OK Da copy xong!" -ForegroundColor Green
Write-Host ""

# Kiểm tra bootloader
Write-Host "Kiem tra bootloader..." -ForegroundColor Cyan
$bootloader = Join-Path $targetDir "esp32\bin\bootloader_qio_80m.elf"
if (Test-Path $bootloader) {
    Write-Host "   OK Tim thay bootloader_qio_80m.elf" -ForegroundColor Green
    Write-Host "   Duong dan: $bootloader" -ForegroundColor Gray
} else {
    Write-Host "   WARNING: Khong tim thay bootloader_qio_80m.elf" -ForegroundColor Yellow
    Write-Host "   Dang tim trong toan bo thu muc..." -ForegroundColor Gray
    $found = Get-ChildItem -Path $targetDir -Recurse -Filter "bootloader*.elf" -ErrorAction SilentlyContinue | Select-Object -First 3
    if ($found) {
        Write-Host "   Tim thay $($found.Count) file bootloader:" -ForegroundColor Green
        $found | ForEach-Object {
            $relPath = $_.FullName.Replace($targetDir + "\", "")
            Write-Host "      - $relPath" -ForegroundColor Gray
        }
    } else {
        Write-Host "   ERROR: Khong tim thay bootloader nao!" -ForegroundColor Red
        Write-Host "   Vui long kiem tra lai cau truc thu muc sau khi giai nen" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "Hoan tat!" -ForegroundColor Green
Write-Host ""
Write-Host "Sau do:" -ForegroundColor Yellow
Write-Host "   1. Restart Arduino IDE" -ForegroundColor White
Write-Host "   2. Thu compile code ESP32" -ForegroundColor White
Write-Host ""
Write-Host "Ban co the xoa file tam tren o E:" -ForegroundColor Cyan
Write-Host "   Remove-Item -Recurse -Force `"$sourceDir`"" -ForegroundColor Gray

# PowerShell Script de copy ESP32 libraries tu o E: sang o C:
# Chay: .\copy-esp32-libs-from-e.ps1
# 
# Yeu cau: Da giai nen esp32-3.3.5-libs.zip vao E:\SmartFarm\esp32-3.3.5-libs\

Write-Host "Copy ESP32 Libraries tu o E: sang o C:" -ForegroundColor Cyan
Write-Host "=======================================" -ForegroundColor Cyan
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

# Thư mục đích (trên ổ C:)
$targetDir = "$env:LOCALAPPDATA\Arduino15\packages\esp32\tools\esp32-arduino-libs\idf-release_v5.5-9bb7aa84-v2"

# Kiểm tra dung lượng ổ C:
$cDrive = Get-PSDrive C
$freeSpaceGB = [math]::Round($cDrive.Free / 1GB, 2)
Write-Host "Dung luong o C: con lai: $freeSpaceGB GB" -ForegroundColor Cyan

if ($freeSpaceGB -lt 1) {
    Write-Host "WARNING: O C: chi con $freeSpaceGB GB - co the khong du!" -ForegroundColor Yellow
    Write-Host "   Khuyen nghi: Don dep o C: truoc khi tiep tuc" -ForegroundColor Yellow
    Write-Host ""
    $continue = Read-Host "Ban co muon tiep tuc? (y/n)"
    if ($continue -ne "y" -and $continue -ne "Y") {
        Write-Host "Da huy" -ForegroundColor Yellow
        exit 0
    }
}

Write-Host ""

# Xóa thư mục cũ nếu có
if (Test-Path $targetDir) {
    Write-Host "Xoa thu muc cu..." -ForegroundColor Yellow
    Remove-Item -Recurse -Force $targetDir -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 1
}

# Tạo thư mục mới
Write-Host "Tao thu muc moi..." -ForegroundColor Cyan
New-Item -ItemType Directory -Force -Path $targetDir | Out-Null
Write-Host "   OK Thu muc: $targetDir" -ForegroundColor Green
Write-Host ""

# Tìm thư mục esp32-arduino-libs
Write-Host "Tim thu muc esp32-arduino-libs..." -ForegroundColor Cyan
$libsDir = Get-ChildItem -Path $sourceDir -Recurse -Directory -Filter "esp32-arduino-libs" -ErrorAction SilentlyContinue | Select-Object -First 1

if ($libsDir) {
    Write-Host "   Tim thay: $($libsDir.FullName)" -ForegroundColor Green
    Write-Host "   Dang copy tu E: sang C:..." -ForegroundColor Cyan
    # Copy từ esp32-arduino-libs
    $items = Get-ChildItem -Path $libsDir.FullName
    $totalItems = $items.Count
    $currentItem = 0
    
    foreach ($item in $items) {
        $currentItem++
        $percent = [math]::Round(($currentItem / $totalItems) * 100, 1)
        Write-Progress -Activity "Dang copy..." -Status "$currentItem / $totalItems ($percent%)" -PercentComplete $percent
        Copy-Item -Path $item.FullName -Destination $targetDir -Recurse -Force -ErrorAction SilentlyContinue
    }
    Write-Progress -Activity "Dang copy..." -Completed
} else {
    Write-Host "   Khong tim thay thu muc esp32-arduino-libs" -ForegroundColor Yellow
    Write-Host "   Copy truc tiep tu thu muc goc..." -ForegroundColor Cyan
    
    # Kiểm tra có thư mục esp32 không
    $esp32Dir = Get-ChildItem -Path $sourceDir -Directory -Filter "esp32" -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($esp32Dir) {
        Write-Host "   Tim thay thu muc esp32" -ForegroundColor Green
        $items = Get-ChildItem -Path $sourceDir
        $totalItems = $items.Count
        $currentItem = 0
        
        foreach ($item in $items) {
            $currentItem++
            $percent = [math]::Round(($currentItem / $totalItems) * 100, 1)
            Write-Progress -Activity "Dang copy..." -Status "$currentItem / $totalItems ($percent%)" -PercentComplete $percent
            Copy-Item -Path $item.FullName -Destination $targetDir -Recurse -Force -ErrorAction SilentlyContinue
        }
        Write-Progress -Activity "Dang copy..." -Completed
    } else {
        Write-Host "   ERROR: Khong tim thay thu muc esp32!" -ForegroundColor Red
        Write-Host "   Vui long kiem tra lai cau truc thu muc sau khi giai nen" -ForegroundColor Yellow
        exit 1
    }
}

Write-Host ""
Write-Host "OK Da copy xong!" -ForegroundColor Green
Write-Host ""

# Kiểm tra bootloader
Write-Host "Kiem tra bootloader..." -ForegroundColor Cyan
$bootloader = Join-Path $targetDir "esp32\bin\bootloader_qio_80m.elf"
if (Test-Path $bootloader) {
    Write-Host "   OK Tim thay bootloader_qio_80m.elf" -ForegroundColor Green
    Write-Host "   Duong dan: $bootloader" -ForegroundColor Gray
} else {
    Write-Host "   WARNING: Khong tim thay bootloader_qio_80m.elf" -ForegroundColor Yellow
    Write-Host "   Dang tim trong toan bo thu muc..." -ForegroundColor Gray
    $found = Get-ChildItem -Path $targetDir -Recurse -Filter "bootloader*.elf" -ErrorAction SilentlyContinue | Select-Object -First 3
    if ($found) {
        Write-Host "   Tim thay $($found.Count) file bootloader:" -ForegroundColor Green
        $found | ForEach-Object {
            $relPath = $_.FullName.Replace($targetDir + "\", "")
            Write-Host "      - $relPath" -ForegroundColor Gray
        }
    } else {
        Write-Host "   ERROR: Khong tim thay bootloader nao!" -ForegroundColor Red
        Write-Host "   Vui long kiem tra lai cau truc thu muc sau khi giai nen" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "Hoan tat!" -ForegroundColor Green
Write-Host ""
Write-Host "Sau do:" -ForegroundColor Yellow
Write-Host "   1. Restart Arduino IDE" -ForegroundColor White
Write-Host "   2. Thu compile code ESP32" -ForegroundColor White
Write-Host ""
Write-Host "Ban co the xoa file tam tren o E:" -ForegroundColor Cyan
Write-Host "   Remove-Item -Recurse -Force `"$sourceDir`"" -ForegroundColor Gray


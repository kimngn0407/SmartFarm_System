# PowerShell Script de cai esp32-arduino-libs don gian
# Chay: .\install-esp32-libs-simple.ps1

Write-Host "Cai ESP32 Arduino Libraries" -ForegroundColor Cyan
Write-Host "============================" -ForegroundColor Cyan
Write-Host ""

$targetDir = "$env:LOCALAPPDATA\Arduino15\packages\esp32\tools\esp32-arduino-libs\idf-release_v5.5-9bb7aa84-v2"
$zipFile = "$env:USERPROFILE\Downloads\esp32-tools\esp32-3.3.5-libs.zip"

# Kiem tra file ZIP
if (-not (Test-Path $zipFile)) {
    Write-Host "ERROR: Khong tim thay $zipFile" -ForegroundColor Red
    exit 1
}

Write-Host "Tim thay: $zipFile" -ForegroundColor Green
Write-Host ""

# Xoa thu muc cu neu co
if (Test-Path $targetDir) {
    Write-Host "Xoa thu muc cu..." -ForegroundColor Yellow
    Remove-Item -Recurse -Force $targetDir -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 1
}

# Tao thu muc moi
Write-Host "Tao thu muc: $targetDir" -ForegroundColor Cyan
New-Item -ItemType Directory -Force -Path $targetDir | Out-Null

# Giai nen vao thu muc tam
$tempDir = "$env:TEMP\esp32-libs-$(Get-Random)"
Write-Host "Giai nen vao thu muc tam: $tempDir" -ForegroundColor Cyan

if (Test-Path $tempDir) {
    Remove-Item -Recurse -Force $tempDir -ErrorAction SilentlyContinue
}
New-Item -ItemType Directory -Force -Path $tempDir | Out-Null

try {
    Write-Host "Dang giai nen (co the mat 1-2 phut)..." -ForegroundColor Yellow
    Expand-Archive -Path $zipFile -DestinationPath $tempDir -Force
    
    Write-Host "OK Da giai nen xong" -ForegroundColor Green
    Write-Host ""
    
    # Tim thu muc esp32-arduino-libs
    Write-Host "Tim thu muc esp32-arduino-libs..." -ForegroundColor Cyan
    $libsDir = Get-ChildItem -Path $tempDir -Recurse -Directory -Filter "esp32-arduino-libs" -ErrorAction SilentlyContinue | Select-Object -First 1
    
    if ($libsDir) {
        Write-Host "   Tim thay: $($libsDir.FullName)" -ForegroundColor Green
        Write-Host "   Dang di chuyen noi dung..." -ForegroundColor Cyan
        Get-ChildItem -Path $libsDir.FullName | Move-Item -Destination $targetDir -Force
    } else {
        Write-Host "   Khong tim thay thu muc esp32-arduino-libs" -ForegroundColor Yellow
        Write-Host "   Dang tim thu muc chua esp32..." -ForegroundColor Cyan
        
        # Tim thu muc co chua esp32
        $esp32Dir = Get-ChildItem -Path $tempDir -Recurse -Directory -Filter "esp32" -ErrorAction SilentlyContinue | 
                    Where-Object { $_.Parent.Name -ne "esp32-arduino-libs" } | 
                    Select-Object -First 1
        
        if ($esp32Dir) {
            Write-Host "   Tim thay thu muc: $($esp32Dir.Parent.FullName)" -ForegroundColor Green
            # Di chuyen thu muc cha
            $parentDir = $esp32Dir.Parent
            Get-ChildItem -Path $parentDir.FullName | Move-Item -Destination $targetDir -Force
        } else {
            Write-Host "   Di chuyen toan bo noi dung..." -ForegroundColor Cyan
            Get-ChildItem -Path $tempDir | Move-Item -Destination $targetDir -Force
        }
    }
    
    Write-Host ""
    Write-Host "OK Da di chuyen xong" -ForegroundColor Green
    Write-Host ""
    
    # Kiem tra bootloader
    $bootloaderPath = Join-Path $targetDir "esp32\bin\bootloader_qio_80m.elf"
    Write-Host "Kiem tra bootloader..." -ForegroundColor Cyan
    if (Test-Path $bootloaderPath) {
        Write-Host "   OK Tim thay bootloader_qio_80m.elf" -ForegroundColor Green
    } else {
        Write-Host "   WARNING: Khong tim thay bootloader_qio_80m.elf" -ForegroundColor Yellow
        Write-Host "   Dang tim cac file bootloader..." -ForegroundColor Gray
        $bootloaders = Get-ChildItem -Path $targetDir -Recurse -Filter "bootloader*.elf" -ErrorAction SilentlyContinue
        if ($bootloaders) {
            Write-Host "   Tim thay $($bootloaders.Count) file bootloader:" -ForegroundColor Green
            $bootloaders | ForEach-Object {
                $relPath = $_.FullName.Replace($targetDir + "\", "")
                Write-Host "      - $relPath" -ForegroundColor Gray
            }
        } else {
            Write-Host "   ERROR: Khong tim thay file bootloader nao!" -ForegroundColor Red
            Write-Host "   Thu muc hien tai:" -ForegroundColor Yellow
            Get-ChildItem -Path $targetDir -Directory | Select-Object -First 5 | ForEach-Object {
                Write-Host "      - $($_.Name)" -ForegroundColor Gray
            }
        }
    }
    
    # Xoa thu muc tam (sau 2 giay)
    Write-Host ""
    Write-Host "Dang xoa thu muc tam..." -ForegroundColor Cyan
    Start-Sleep -Seconds 2
    Remove-Item -Recurse -Force $tempDir -ErrorAction SilentlyContinue
    
} catch {
    Write-Host "ERROR: Loi khi giai nen: $_" -ForegroundColor Red
    Remove-Item -Recurse -Force $tempDir -ErrorAction SilentlyContinue
    exit 1
}

Write-Host ""
Write-Host "Hoan tat!" -ForegroundColor Green
Write-Host ""
Write-Host "Sau do:" -ForegroundColor Yellow
Write-Host "   1. Restart Arduino IDE" -ForegroundColor White
Write-Host "   2. Thu compile code ESP32" -ForegroundColor White

# PowerShell Script de cai esp32-arduino-libs don gian
# Chay: .\install-esp32-libs-simple.ps1

Write-Host "Cai ESP32 Arduino Libraries" -ForegroundColor Cyan
Write-Host "============================" -ForegroundColor Cyan
Write-Host ""

$targetDir = "$env:LOCALAPPDATA\Arduino15\packages\esp32\tools\esp32-arduino-libs\idf-release_v5.5-9bb7aa84-v2"
$zipFile = "$env:USERPROFILE\Downloads\esp32-tools\esp32-3.3.5-libs.zip"

# Kiem tra file ZIP
if (-not (Test-Path $zipFile)) {
    Write-Host "ERROR: Khong tim thay $zipFile" -ForegroundColor Red
    exit 1
}

Write-Host "Tim thay: $zipFile" -ForegroundColor Green
Write-Host ""

# Xoa thu muc cu neu co
if (Test-Path $targetDir) {
    Write-Host "Xoa thu muc cu..." -ForegroundColor Yellow
    Remove-Item -Recurse -Force $targetDir -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 1
}

# Tao thu muc moi
Write-Host "Tao thu muc: $targetDir" -ForegroundColor Cyan
New-Item -ItemType Directory -Force -Path $targetDir | Out-Null

# Giai nen vao thu muc tam
$tempDir = "$env:TEMP\esp32-libs-$(Get-Random)"
Write-Host "Giai nen vao thu muc tam: $tempDir" -ForegroundColor Cyan

if (Test-Path $tempDir) {
    Remove-Item -Recurse -Force $tempDir -ErrorAction SilentlyContinue
}
New-Item -ItemType Directory -Force -Path $tempDir | Out-Null

try {
    Write-Host "Dang giai nen (co the mat 1-2 phut)..." -ForegroundColor Yellow
    Expand-Archive -Path $zipFile -DestinationPath $tempDir -Force
    
    Write-Host "OK Da giai nen xong" -ForegroundColor Green
    Write-Host ""
    
    # Tim thu muc esp32-arduino-libs
    Write-Host "Tim thu muc esp32-arduino-libs..." -ForegroundColor Cyan
    $libsDir = Get-ChildItem -Path $tempDir -Recurse -Directory -Filter "esp32-arduino-libs" -ErrorAction SilentlyContinue | Select-Object -First 1
    
    if ($libsDir) {
        Write-Host "   Tim thay: $($libsDir.FullName)" -ForegroundColor Green
        Write-Host "   Dang di chuyen noi dung..." -ForegroundColor Cyan
        Get-ChildItem -Path $libsDir.FullName | Move-Item -Destination $targetDir -Force
    } else {
        Write-Host "   Khong tim thay thu muc esp32-arduino-libs" -ForegroundColor Yellow
        Write-Host "   Dang tim thu muc chua esp32..." -ForegroundColor Cyan
        
        # Tim thu muc co chua esp32
        $esp32Dir = Get-ChildItem -Path $tempDir -Recurse -Directory -Filter "esp32" -ErrorAction SilentlyContinue | 
                    Where-Object { $_.Parent.Name -ne "esp32-arduino-libs" } | 
                    Select-Object -First 1
        
        if ($esp32Dir) {
            Write-Host "   Tim thay thu muc: $($esp32Dir.Parent.FullName)" -ForegroundColor Green
            # Di chuyen thu muc cha
            $parentDir = $esp32Dir.Parent
            Get-ChildItem -Path $parentDir.FullName | Move-Item -Destination $targetDir -Force
        } else {
            Write-Host "   Di chuyen toan bo noi dung..." -ForegroundColor Cyan
            Get-ChildItem -Path $tempDir | Move-Item -Destination $targetDir -Force
        }
    }
    
    Write-Host ""
    Write-Host "OK Da di chuyen xong" -ForegroundColor Green
    Write-Host ""
    
    # Kiem tra bootloader
    $bootloaderPath = Join-Path $targetDir "esp32\bin\bootloader_qio_80m.elf"
    Write-Host "Kiem tra bootloader..." -ForegroundColor Cyan
    if (Test-Path $bootloaderPath) {
        Write-Host "   OK Tim thay bootloader_qio_80m.elf" -ForegroundColor Green
    } else {
        Write-Host "   WARNING: Khong tim thay bootloader_qio_80m.elf" -ForegroundColor Yellow
        Write-Host "   Dang tim cac file bootloader..." -ForegroundColor Gray
        $bootloaders = Get-ChildItem -Path $targetDir -Recurse -Filter "bootloader*.elf" -ErrorAction SilentlyContinue
        if ($bootloaders) {
            Write-Host "   Tim thay $($bootloaders.Count) file bootloader:" -ForegroundColor Green
            $bootloaders | ForEach-Object {
                $relPath = $_.FullName.Replace($targetDir + "\", "")
                Write-Host "      - $relPath" -ForegroundColor Gray
            }
        } else {
            Write-Host "   ERROR: Khong tim thay file bootloader nao!" -ForegroundColor Red
            Write-Host "   Thu muc hien tai:" -ForegroundColor Yellow
            Get-ChildItem -Path $targetDir -Directory | Select-Object -First 5 | ForEach-Object {
                Write-Host "      - $($_.Name)" -ForegroundColor Gray
            }
        }
    }
    
    # Xoa thu muc tam (sau 2 giay)
    Write-Host ""
    Write-Host "Dang xoa thu muc tam..." -ForegroundColor Cyan
    Start-Sleep -Seconds 2
    Remove-Item -Recurse -Force $tempDir -ErrorAction SilentlyContinue
    
} catch {
    Write-Host "ERROR: Loi khi giai nen: $_" -ForegroundColor Red
    Remove-Item -Recurse -Force $tempDir -ErrorAction SilentlyContinue
    exit 1
}

Write-Host ""
Write-Host "Hoan tat!" -ForegroundColor Green
Write-Host ""
Write-Host "Sau do:" -ForegroundColor Yellow
Write-Host "   1. Restart Arduino IDE" -ForegroundColor White
Write-Host "   2. Thu compile code ESP32" -ForegroundColor White


# PowerShell Script de fix esp32-arduino-libs
# Chay: .\fix-esp32-libs.ps1

Write-Host "Fix ESP32 Arduino Libraries" -ForegroundColor Cyan
Write-Host "===========================" -ForegroundColor Cyan
Write-Host ""

$toolsPath = "$env:LOCALAPPDATA\Arduino15\packages\esp32\tools"
$libsToolPath = Join-Path $toolsPath "esp32-arduino-libs"
$versionDir = Join-Path $libsToolPath "idf-release_v5.5-9bb7aa84-v2"
$downloadPath = "$env:USERPROFILE\Downloads\esp32-tools"
$libsZip = Get-ChildItem -Path $downloadPath -Filter "*esp32-3.3.5-libs.zip" -ErrorAction SilentlyContinue | Select-Object -First 1

if (-not $libsZip) {
    Write-Host "ERROR: Khong tim thay esp32-3.3.5-libs.zip trong $downloadPath" -ForegroundColor Red
    exit 1
}

Write-Host "Tim thay: $($libsZip.Name)" -ForegroundColor Green
Write-Host ""

# Kiem tra da co chua
if (Test-Path $versionDir) {
    $bootloaderPath = Join-Path $versionDir "esp32\bin\bootloader_qio_80m.elf"
    if (Test-Path $bootloaderPath) {
        Write-Host "OK esp32-arduino-libs da duoc cai dat dung!" -ForegroundColor Green
        Write-Host "   Bootloader: $bootloaderPath" -ForegroundColor Gray
        exit 0
    } else {
        Write-Host "WARNING: esp32-arduino-libs da co nhung cau truc khong dung" -ForegroundColor Yellow
        Write-Host "   Dang xoa va cai lai..." -ForegroundColor Cyan
        Remove-Item -Recurse -Force $versionDir -ErrorAction SilentlyContinue
    }
}

# Giai nen
Write-Host "Dang giai nen esp32-3.3.5-libs.zip..." -ForegroundColor Cyan
$tempDir = Join-Path $env:TEMP "esp32-libs-$(Get-Random)"
if (Test-Path $tempDir) {
    Remove-Item -Recurse -Force $tempDir
}
New-Item -ItemType Directory -Force -Path $tempDir | Out-Null

try {
    Expand-Archive -Path $libsZip.FullName -DestinationPath $tempDir -Force
    
    # Tim thu muc esp32-arduino-libs trong ZIP
    $libsDir = Get-ChildItem -Path $tempDir -Recurse -Directory -Filter "esp32-arduino-libs" -ErrorAction SilentlyContinue | Select-Object -First 1
    
    if ($libsDir) {
        # Neu co thu muc esp32-arduino-libs, di chuyen toan bo noi dung
        Write-Host "   Tim thay thu muc esp32-arduino-libs" -ForegroundColor Gray
        New-Item -ItemType Directory -Force -Path $versionDir | Out-Null
        Get-ChildItem -Path $libsDir.FullName | Move-Item -Destination $versionDir -Force
    } else {
        # Neu khong co, co the la giai nen truc tiep
        $firstDir = Get-ChildItem -Path $tempDir -Directory | Select-Object -First 1
        if ($firstDir) {
            Write-Host "   Tim thay thu muc: $($firstDir.Name)" -ForegroundColor Gray
            New-Item -ItemType Directory -Force -Path $versionDir | Out-Null
            Get-ChildItem -Path $firstDir.FullName | Move-Item -Destination $versionDir -Force
        } else {
            # Giai nen truc tiep vao versionDir
            Write-Host "   Giai nen truc tiep..." -ForegroundColor Gray
            New-Item -ItemType Directory -Force -Path $versionDir | Out-Null
            Get-ChildItem -Path $tempDir | Move-Item -Destination $versionDir -Force
        }
    }
    
    # Kiem tra bootloader
    $bootloaderPath = Join-Path $versionDir "esp32\bin\bootloader_qio_80m.elf"
    if (Test-Path $bootloaderPath) {
        Write-Host "OK Da cai esp32-arduino-libs thanh cong!" -ForegroundColor Green
        Write-Host "   Bootloader: $bootloaderPath" -ForegroundColor Gray
    } else {
        Write-Host "WARNING: Khong tim thay bootloader_qio_80m.elf" -ForegroundColor Yellow
        Write-Host "   Thu tim trong toan bo thu muc..." -ForegroundColor Gray
        $bootloader = Get-ChildItem -Path $versionDir -Recurse -Filter "bootloader_qio_80m.elf" -ErrorAction SilentlyContinue | Select-Object -First 1
        if ($bootloader) {
            Write-Host "   Tim thay: $($bootloader.FullName)" -ForegroundColor Green
        } else {
            Write-Host "   ERROR: Khong tim thay bootloader!" -ForegroundColor Red
        }
    }
    
    # Xoa thu muc tam
    Start-Sleep -Milliseconds 500
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

# PowerShell Script de fix esp32-arduino-libs
# Chay: .\fix-esp32-libs.ps1

Write-Host "Fix ESP32 Arduino Libraries" -ForegroundColor Cyan
Write-Host "===========================" -ForegroundColor Cyan
Write-Host ""

$toolsPath = "$env:LOCALAPPDATA\Arduino15\packages\esp32\tools"
$libsToolPath = Join-Path $toolsPath "esp32-arduino-libs"
$versionDir = Join-Path $libsToolPath "idf-release_v5.5-9bb7aa84-v2"
$downloadPath = "$env:USERPROFILE\Downloads\esp32-tools"
$libsZip = Get-ChildItem -Path $downloadPath -Filter "*esp32-3.3.5-libs.zip" -ErrorAction SilentlyContinue | Select-Object -First 1

if (-not $libsZip) {
    Write-Host "ERROR: Khong tim thay esp32-3.3.5-libs.zip trong $downloadPath" -ForegroundColor Red
    exit 1
}

Write-Host "Tim thay: $($libsZip.Name)" -ForegroundColor Green
Write-Host ""

# Kiem tra da co chua
if (Test-Path $versionDir) {
    $bootloaderPath = Join-Path $versionDir "esp32\bin\bootloader_qio_80m.elf"
    if (Test-Path $bootloaderPath) {
        Write-Host "OK esp32-arduino-libs da duoc cai dat dung!" -ForegroundColor Green
        Write-Host "   Bootloader: $bootloaderPath" -ForegroundColor Gray
        exit 0
    } else {
        Write-Host "WARNING: esp32-arduino-libs da co nhung cau truc khong dung" -ForegroundColor Yellow
        Write-Host "   Dang xoa va cai lai..." -ForegroundColor Cyan
        Remove-Item -Recurse -Force $versionDir -ErrorAction SilentlyContinue
    }
}

# Giai nen
Write-Host "Dang giai nen esp32-3.3.5-libs.zip..." -ForegroundColor Cyan
$tempDir = Join-Path $env:TEMP "esp32-libs-$(Get-Random)"
if (Test-Path $tempDir) {
    Remove-Item -Recurse -Force $tempDir
}
New-Item -ItemType Directory -Force -Path $tempDir | Out-Null

try {
    Expand-Archive -Path $libsZip.FullName -DestinationPath $tempDir -Force
    
    # Tim thu muc esp32-arduino-libs trong ZIP
    $libsDir = Get-ChildItem -Path $tempDir -Recurse -Directory -Filter "esp32-arduino-libs" -ErrorAction SilentlyContinue | Select-Object -First 1
    
    if ($libsDir) {
        # Neu co thu muc esp32-arduino-libs, di chuyen toan bo noi dung
        Write-Host "   Tim thay thu muc esp32-arduino-libs" -ForegroundColor Gray
        New-Item -ItemType Directory -Force -Path $versionDir | Out-Null
        Get-ChildItem -Path $libsDir.FullName | Move-Item -Destination $versionDir -Force
    } else {
        # Neu khong co, co the la giai nen truc tiep
        $firstDir = Get-ChildItem -Path $tempDir -Directory | Select-Object -First 1
        if ($firstDir) {
            Write-Host "   Tim thay thu muc: $($firstDir.Name)" -ForegroundColor Gray
            New-Item -ItemType Directory -Force -Path $versionDir | Out-Null
            Get-ChildItem -Path $firstDir.FullName | Move-Item -Destination $versionDir -Force
        } else {
            # Giai nen truc tiep vao versionDir
            Write-Host "   Giai nen truc tiep..." -ForegroundColor Gray
            New-Item -ItemType Directory -Force -Path $versionDir | Out-Null
            Get-ChildItem -Path $tempDir | Move-Item -Destination $versionDir -Force
        }
    }
    
    # Kiem tra bootloader
    $bootloaderPath = Join-Path $versionDir "esp32\bin\bootloader_qio_80m.elf"
    if (Test-Path $bootloaderPath) {
        Write-Host "OK Da cai esp32-arduino-libs thanh cong!" -ForegroundColor Green
        Write-Host "   Bootloader: $bootloaderPath" -ForegroundColor Gray
    } else {
        Write-Host "WARNING: Khong tim thay bootloader_qio_80m.elf" -ForegroundColor Yellow
        Write-Host "   Thu tim trong toan bo thu muc..." -ForegroundColor Gray
        $bootloader = Get-ChildItem -Path $versionDir -Recurse -Filter "bootloader_qio_80m.elf" -ErrorAction SilentlyContinue | Select-Object -First 1
        if ($bootloader) {
            Write-Host "   Tim thay: $($bootloader.FullName)" -ForegroundColor Green
        } else {
            Write-Host "   ERROR: Khong tim thay bootloader!" -ForegroundColor Red
        }
    }
    
    # Xoa thu muc tam
    Start-Sleep -Milliseconds 500
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


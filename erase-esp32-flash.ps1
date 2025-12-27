# PowerShell Script de erase ESP32 flash bang esptool
# Chay: .\erase-esp32-flash.ps1 [COM_PORT]
# Vi du: .\erase-esp32-flash.ps1 COM9
# 
# Yeu cau: ESP32 da ket noi qua COM port

param(
    [string]$ComPort = ""
)

Write-Host "Erase ESP32 Flash" -ForegroundColor Cyan
Write-Host "=================" -ForegroundColor Cyan
Write-Host ""

# Tim COM port
$comPorts = Get-WmiObject Win32_SerialPort | Where-Object { $_.Description -like "*USB*" -or $_.Description -like "*Serial*" } | Select-Object DeviceID, Description

if (-not $comPorts) {
    Write-Host "ERROR: Khong tim thay COM port nao!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Huong dan:" -ForegroundColor Cyan
    Write-Host "   1. Cam ESP32 vao may tinh" -ForegroundColor White
    Write-Host "   2. Kiem tra trong Arduino IDE: Tools -> Port" -ForegroundColor White
    Write-Host "   3. Chay lai script voi COM port cu the" -ForegroundColor White
    exit 1
}

Write-Host "Tim thay COM ports:" -ForegroundColor Green
$comPorts | ForEach-Object {
    Write-Host "   - $($_.DeviceID): $($_.Description)" -ForegroundColor Gray
}
Write-Host ""

# Xac dinh COM port
if ($ComPort) {
    # Su dung COM port tu tham so
    Write-Host "Su dung COM port: $ComPort" -ForegroundColor Green
} else {
    # Tu dong chon COM port dau tien hoac hoi nguoi dung
    $firstPort = ($comPorts | Select-Object -First 1).DeviceID
    
    if ($Host.UI.RawUI.KeyAvailable -or [Environment]::UserInteractive) {
        # Co the hoi nguoi dung
        try {
            $comPort = Read-Host "Nhap COM port (Enter de dung $firstPort)"
            if (-not $comPort) {
                $comPort = $firstPort
            }
        } catch {
            # Neu khong the hoi, tu dong chon
            $comPort = $firstPort
            Write-Host "Tu dong chon COM port: $comPort" -ForegroundColor Yellow
        }
    } else {
        # Non-interactive mode, tu dong chon
        $comPort = $firstPort
        Write-Host "Tu dong chon COM port: $comPort" -ForegroundColor Yellow
    }
}

if (-not $comPort) {
    Write-Host "ERROR: Khong co COM port!" -ForegroundColor Red
    exit 1
}

# Tim esptool
$esptoolPath = "$env:LOCALAPPDATA\Arduino15\packages\esp32\tools\esptool_py\*\esptool.exe"
$esptool = Get-ChildItem -Path $esptoolPath -ErrorAction SilentlyContinue | Select-Object -First 1

if (-not $esptool) {
    Write-Host "ERROR: Khong tim thay esptool.exe!" -ForegroundColor Red
    Write-Host "   Duong dan tim: $esptoolPath" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Giai phap:" -ForegroundColor Cyan
    Write-Host "   1. Kiem tra ESP32 tools da duoc cai dat" -ForegroundColor White
    Write-Host "   2. Chay: .\check-esp32-tools.ps1" -ForegroundColor White
    exit 1
}

Write-Host "Tim thay esptool: $($esptool.FullName)" -ForegroundColor Green
Write-Host ""

# Canh bao
Write-Host "CANH BAO: Script nay se XOA TOAN BO du lieu trong flash ESP32!" -ForegroundColor Red
Write-Host ""

$shouldContinue = $false
if ($Host.UI.RawUI.KeyAvailable -or [Environment]::UserInteractive) {
    try {
        $confirm = Read-Host "Ban co chac muon tiep tuc? (yes/no)"
        if ($confirm -eq "yes" -or $confirm -eq "y" -or $confirm -eq "Y") {
            $shouldContinue = $true
        }
    } catch {
        # Non-interactive, tu dong tiep tuc
        $shouldContinue = $true
        Write-Host "Non-interactive mode: Tu dong tiep tuc" -ForegroundColor Yellow
    }
} else {
    # Non-interactive mode, tu dong tiep tuc
    $shouldContinue = $true
    Write-Host "Non-interactive mode: Tu dong tiep tuc" -ForegroundColor Yellow
}

if (-not $shouldContinue) {
    Write-Host "Da huy" -ForegroundColor Yellow
    exit 0
}

Write-Host ""
Write-Host "Dang erase flash ESP32..." -ForegroundColor Cyan
Write-Host "   COM Port: $comPort" -ForegroundColor Gray
Write-Host "   Dang cho 3 giay de ban co the nhan nut RESET neu can..." -ForegroundColor Yellow
Start-Sleep -Seconds 3

# Erase flash
Write-Host ""
Write-Host "Dang chay esptool erase_flash..." -ForegroundColor Cyan
& $esptool.FullName --port $comPort erase_flash

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "OK Da erase flash thanh cong!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Sau do:" -ForegroundColor Yellow
    Write-Host "   1. Reset ESP32 (nhan nut RESET)" -ForegroundColor White
    Write-Host "   2. Upload code trong Arduino IDE" -ForegroundColor White
    Write-Host "   3. Phai upload thanh cong!" -ForegroundColor White
} else {
    Write-Host ""
    Write-Host "ERROR: Loi khi erase flash!" -ForegroundColor Red
    Write-Host "   Exit code: $LASTEXITCODE" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Thu:" -ForegroundColor Cyan
    Write-Host "   1. Nhan nut RESET tren ESP32" -ForegroundColor White
    Write-Host "   2. Giu nut BOOT khi chay lenh" -ForegroundColor White
    Write-Host "   3. Chay lai script" -ForegroundColor White
}

# PowerShell Script de erase ESP32 flash bang esptool
# Chay: .\erase-esp32-flash.ps1 [COM_PORT]
# Vi du: .\erase-esp32-flash.ps1 COM9
# 
# Yeu cau: ESP32 da ket noi qua COM port

param(
    [string]$ComPort = ""
)

Write-Host "Erase ESP32 Flash" -ForegroundColor Cyan
Write-Host "=================" -ForegroundColor Cyan
Write-Host ""

# Tim COM port
$comPorts = Get-WmiObject Win32_SerialPort | Where-Object { $_.Description -like "*USB*" -or $_.Description -like "*Serial*" } | Select-Object DeviceID, Description

if (-not $comPorts) {
    Write-Host "ERROR: Khong tim thay COM port nao!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Huong dan:" -ForegroundColor Cyan
    Write-Host "   1. Cam ESP32 vao may tinh" -ForegroundColor White
    Write-Host "   2. Kiem tra trong Arduino IDE: Tools -> Port" -ForegroundColor White
    Write-Host "   3. Chay lai script voi COM port cu the" -ForegroundColor White
    exit 1
}

Write-Host "Tim thay COM ports:" -ForegroundColor Green
$comPorts | ForEach-Object {
    Write-Host "   - $($_.DeviceID): $($_.Description)" -ForegroundColor Gray
}
Write-Host ""

# Xac dinh COM port
if ($ComPort) {
    # Su dung COM port tu tham so
    Write-Host "Su dung COM port: $ComPort" -ForegroundColor Green
} else {
    # Tu dong chon COM port dau tien hoac hoi nguoi dung
    $firstPort = ($comPorts | Select-Object -First 1).DeviceID
    
    if ($Host.UI.RawUI.KeyAvailable -or [Environment]::UserInteractive) {
        # Co the hoi nguoi dung
        try {
            $comPort = Read-Host "Nhap COM port (Enter de dung $firstPort)"
            if (-not $comPort) {
                $comPort = $firstPort
            }
        } catch {
            # Neu khong the hoi, tu dong chon
            $comPort = $firstPort
            Write-Host "Tu dong chon COM port: $comPort" -ForegroundColor Yellow
        }
    } else {
        # Non-interactive mode, tu dong chon
        $comPort = $firstPort
        Write-Host "Tu dong chon COM port: $comPort" -ForegroundColor Yellow
    }
}

if (-not $comPort) {
    Write-Host "ERROR: Khong co COM port!" -ForegroundColor Red
    exit 1
}

# Tim esptool
$esptoolPath = "$env:LOCALAPPDATA\Arduino15\packages\esp32\tools\esptool_py\*\esptool.exe"
$esptool = Get-ChildItem -Path $esptoolPath -ErrorAction SilentlyContinue | Select-Object -First 1

if (-not $esptool) {
    Write-Host "ERROR: Khong tim thay esptool.exe!" -ForegroundColor Red
    Write-Host "   Duong dan tim: $esptoolPath" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Giai phap:" -ForegroundColor Cyan
    Write-Host "   1. Kiem tra ESP32 tools da duoc cai dat" -ForegroundColor White
    Write-Host "   2. Chay: .\check-esp32-tools.ps1" -ForegroundColor White
    exit 1
}

Write-Host "Tim thay esptool: $($esptool.FullName)" -ForegroundColor Green
Write-Host ""

# Canh bao
Write-Host "CANH BAO: Script nay se XOA TOAN BO du lieu trong flash ESP32!" -ForegroundColor Red
Write-Host ""

$shouldContinue = $false
if ($Host.UI.RawUI.KeyAvailable -or [Environment]::UserInteractive) {
    try {
        $confirm = Read-Host "Ban co chac muon tiep tuc? (yes/no)"
        if ($confirm -eq "yes" -or $confirm -eq "y" -or $confirm -eq "Y") {
            $shouldContinue = $true
        }
    } catch {
        # Non-interactive, tu dong tiep tuc
        $shouldContinue = $true
        Write-Host "Non-interactive mode: Tu dong tiep tuc" -ForegroundColor Yellow
    }
} else {
    # Non-interactive mode, tu dong tiep tuc
    $shouldContinue = $true
    Write-Host "Non-interactive mode: Tu dong tiep tuc" -ForegroundColor Yellow
}

if (-not $shouldContinue) {
    Write-Host "Da huy" -ForegroundColor Yellow
    exit 0
}

Write-Host ""
Write-Host "Dang erase flash ESP32..." -ForegroundColor Cyan
Write-Host "   COM Port: $comPort" -ForegroundColor Gray
Write-Host "   Dang cho 3 giay de ban co the nhan nut RESET neu can..." -ForegroundColor Yellow
Start-Sleep -Seconds 3

# Erase flash
Write-Host ""
Write-Host "Dang chay esptool erase_flash..." -ForegroundColor Cyan
& $esptool.FullName --port $comPort erase_flash

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "OK Da erase flash thanh cong!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Sau do:" -ForegroundColor Yellow
    Write-Host "   1. Reset ESP32 (nhan nut RESET)" -ForegroundColor White
    Write-Host "   2. Upload code trong Arduino IDE" -ForegroundColor White
    Write-Host "   3. Phai upload thanh cong!" -ForegroundColor White
} else {
    Write-Host ""
    Write-Host "ERROR: Loi khi erase flash!" -ForegroundColor Red
    Write-Host "   Exit code: $LASTEXITCODE" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Thu:" -ForegroundColor Cyan
    Write-Host "   1. Nhan nut RESET tren ESP32" -ForegroundColor White
    Write-Host "   2. Giu nut BOOT khi chay lenh" -ForegroundColor White
    Write-Host "   3. Chay lai script" -ForegroundColor White
}


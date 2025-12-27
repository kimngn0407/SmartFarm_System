# PowerShell Script de kiem tra ESP32 Tools
# Chay: .\check-esp32-tools.ps1

Write-Host "Kiem tra ESP32 Tools" -ForegroundColor Cyan
Write-Host "====================" -ForegroundColor Cyan
Write-Host ""

$toolsPath = "$env:LOCALAPPDATA\Arduino15\packages\esp32\tools"

# Kiem tra thu muc tools
if (-not (Test-Path $toolsPath)) {
    Write-Host "Thu muc tools khong ton tai" -ForegroundColor Red
    Write-Host "   Duong dan: $toolsPath" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Giai phap:" -ForegroundColor Cyan
    Write-Host "   Tools -> Board -> Boards Manager -> Install ESP32 3.3.5" -ForegroundColor White
    exit 1
}

Write-Host "Thu muc tools ton tai" -ForegroundColor Green
Write-Host "   Duong dan: $toolsPath" -ForegroundColor Gray
Write-Host ""

# Danh sach tools can thiet (ESP32 3.3.5)
$requiredTools = @(
    "esp-x32",              # Compiler (thay cho xtensa-esp32-elf-gcc)
    "esptool_py",           # Upload tool
    "mklittlefs",           # Filesystem tool
    "openocd-esp32"         # Debug tool (tuy chon)
)

Write-Host "Kiem tra tools can thiet:" -ForegroundColor Cyan
Write-Host ""

$allOk = $true
foreach ($tool in $requiredTools) {
    $toolPath = Join-Path $toolsPath $tool
    if (Test-Path $toolPath) {
        $versions = Get-ChildItem $toolPath -Directory -ErrorAction SilentlyContinue
        if ($versions) {
            $versionList = ($versions | ForEach-Object { $_.Name }) -join ", "
            Write-Host "   OK $tool (versions: $versionList)" -ForegroundColor Green
        } else {
            Write-Host "   WARNING $tool - Thu muc trong" -ForegroundColor Yellow
            $allOk = $false
        }
    } else {
        Write-Host "   ERROR $tool - KHONG TIM THAY" -ForegroundColor Red
        $allOk = $false
    }
}

Write-Host ""

if ($allOk) {
    Write-Host "Tat ca tools da duoc cai dat!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Neu van loi compile:" -ForegroundColor Cyan
    Write-Host "   1. Restart Arduino IDE" -ForegroundColor White
    Write-Host "   2. Kiem tra Tools -> Board -> ESP32 Dev Module da chon" -ForegroundColor White
    Write-Host "   3. Kiem tra Tools -> Port -> COMx da chon" -ForegroundColor White
} else {
    Write-Host "Mot so tools chua duoc cai dat!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Giai phap:" -ForegroundColor Cyan
    Write-Host "   1. Tools -> Board -> Boards Manager" -ForegroundColor White
    Write-Host "   2. Tim 'esp32'" -ForegroundColor White
    Write-Host "   3. Click 'INSTALL' cho version 3.3.5" -ForegroundColor White
    Write-Host "   4. Arduino IDE se download tools (khong download hardware nua)" -ForegroundColor White
    Write-Host ""
    Write-Host "   Hoac download manual tu:" -ForegroundColor Yellow
    Write-Host "   https://github.com/espressif/arduino-esp32/releases/tag/3.3.5" -ForegroundColor Yellow
}

Write-Host ""

# Tinh tong kich thuoc tools
try {
    $totalSize = (Get-ChildItem $toolsPath -Recurse -File -ErrorAction SilentlyContinue | 
                  Measure-Object -Property Length -Sum).Sum / 1MB
    Write-Host "Tong kich thuoc tools: $([math]::Round($totalSize, 2)) MB" -ForegroundColor Cyan
} catch {
    Write-Host "Khong the tinh kich thuoc tools" -ForegroundColor Yellow
}

    Write-Host "Khong the tinh kich thuoc tools" -ForegroundColor Yellow
}

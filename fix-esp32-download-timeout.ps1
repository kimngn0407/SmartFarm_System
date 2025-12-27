# PowerShell Script de fix timeout khi download ESP32 tools
# Chay: .\fix-esp32-download-timeout.ps1

Write-Host "Fix Timeout khi Download ESP32 Tools" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

$arduino15Path = "$env:LOCALAPPDATA\Arduino15"
$preferencesPath = "$arduino15Path\preferences.txt"

# Kiem tra Arduino IDE dang chay
$arduinoProcess = Get-Process -Name "arduino" -ErrorAction SilentlyContinue
if ($arduinoProcess) {
    Write-Host "WARNING: Arduino IDE dang chay!" -ForegroundColor Red
    Write-Host "Can dong Arduino IDE de cap nhat preferences.txt" -ForegroundColor Yellow
    Write-Host ""
    $close = Read-Host "Ban co muon dong Arduino IDE ngay bay gio? (y/n)"
    if ($close -eq "y" -or $close -eq "Y") {
        Stop-Process -Name "arduino" -Force -ErrorAction SilentlyContinue
        Start-Sleep -Seconds 2
        Write-Host "OK Da dong Arduino IDE" -ForegroundColor Green
    } else {
        Write-Host "Vui long dong Arduino IDE thu cong va chay lai script" -ForegroundColor Yellow
        exit 1
    }
}

Write-Host ""

# Tao thu muc neu chua co
if (-not (Test-Path $arduino15Path)) {
    Write-Host "Tao thu muc Arduino15..." -ForegroundColor Cyan
    New-Item -ItemType Directory -Force -Path $arduino15Path | Out-Null
}

# Doc hoac tao file preferences.txt
if (Test-Path $preferencesPath) {
    Write-Host "Doc file preferences.txt hien tai..." -ForegroundColor Cyan
    $content = Get-Content $preferencesPath -Raw -ErrorAction SilentlyContinue
    
    # Cap nhat hoac them network.timeout
    if ($content -match "network\.timeout\s*=\s*\d+") {
        $currentTimeout = [regex]::Match($content, "network\.timeout\s*=\s*(\d+)").Groups[1].Value
        Write-Host "   Timeout hien tai: $currentTimeout giay" -ForegroundColor Gray
        
        # Tang len 1800 giay (30 phut) neu nho hon
        if ([int]$currentTimeout -lt 1800) {
            Write-Host "   Dang tang timeout len 1800 giay (30 phut)..." -ForegroundColor Cyan
            $content = $content -replace "network\.timeout\s*=\s*\d+", "network.timeout=1800"
            Set-Content -Path $preferencesPath -Value $content -NoNewline -Encoding UTF8
            Write-Host "   OK Da cap nhat network.timeout=1800" -ForegroundColor Green
        } else {
            Write-Host "   OK Timeout da du lon (>= 1800)" -ForegroundColor Green
        }
    } else {
        Write-Host "   Chua co network.timeout, dang them..." -ForegroundColor Cyan
        if ($content -and -not $content.EndsWith("`n")) {
            $content += "`n"
        }
        $content += "network.timeout=1800`n"
        Set-Content -Path $preferencesPath -Value $content -NoNewline -Encoding UTF8
        Write-Host "   OK Da them network.timeout=1800" -ForegroundColor Green
    }
} else {
    Write-Host "Tao file preferences.txt moi..." -ForegroundColor Cyan
    "network.timeout=1800" | Out-File -FilePath $preferencesPath -Encoding UTF8 -NoNewline
    Write-Host "   OK Da tao file voi network.timeout=1800" -ForegroundColor Green
}

Write-Host ""
Write-Host "Hoan tat!" -ForegroundColor Green
Write-Host ""
Write-Host "Cac buoc tiep theo:" -ForegroundColor Cyan
Write-Host "   1. Mo Arduino IDE" -ForegroundColor White
Write-Host "   2. Tools -> Board -> Boards Manager" -ForegroundColor White
Write-Host "   3. Tim 'esp32'" -ForegroundColor White
Write-Host "   4. Click 'REMOVE' cho version 3.3.5" -ForegroundColor White
Write-Host "   5. Click 'INSTALL' lai cho version 3.3.5" -ForegroundColor White
Write-Host "   6. Doi download tools (co the mat 10-20 phut)" -ForegroundColor White
Write-Host ""
Write-Host "Luu y:" -ForegroundColor Yellow
Write-Host "   - Timeout da duoc tang len 1800 giay (30 phut)" -ForegroundColor Gray
Write-Host "   - Neu van timeout, thu vao gio it nguoi dung" -ForegroundColor Gray
Write-Host "   - Dung ket noi internet on dinh (LAN tot hon WiFi)" -ForegroundColor Gray
Write-Host "   - Tat cac ung dung download khac" -ForegroundColor Gray

# PowerShell Script de fix timeout khi download ESP32 tools
# Chay: .\fix-esp32-download-timeout.ps1

Write-Host "Fix Timeout khi Download ESP32 Tools" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

$arduino15Path = "$env:LOCALAPPDATA\Arduino15"
$preferencesPath = "$arduino15Path\preferences.txt"

# Kiem tra Arduino IDE dang chay
$arduinoProcess = Get-Process -Name "arduino" -ErrorAction SilentlyContinue
if ($arduinoProcess) {
    Write-Host "WARNING: Arduino IDE dang chay!" -ForegroundColor Red
    Write-Host "Can dong Arduino IDE de cap nhat preferences.txt" -ForegroundColor Yellow
    Write-Host ""
    $close = Read-Host "Ban co muon dong Arduino IDE ngay bay gio? (y/n)"
    if ($close -eq "y" -or $close -eq "Y") {
        Stop-Process -Name "arduino" -Force -ErrorAction SilentlyContinue
        Start-Sleep -Seconds 2
        Write-Host "OK Da dong Arduino IDE" -ForegroundColor Green
    } else {
        Write-Host "Vui long dong Arduino IDE thu cong va chay lai script" -ForegroundColor Yellow
        exit 1
    }
}

Write-Host ""

# Tao thu muc neu chua co
if (-not (Test-Path $arduino15Path)) {
    Write-Host "Tao thu muc Arduino15..." -ForegroundColor Cyan
    New-Item -ItemType Directory -Force -Path $arduino15Path | Out-Null
}

# Doc hoac tao file preferences.txt
if (Test-Path $preferencesPath) {
    Write-Host "Doc file preferences.txt hien tai..." -ForegroundColor Cyan
    $content = Get-Content $preferencesPath -Raw -ErrorAction SilentlyContinue
    
    # Cap nhat hoac them network.timeout
    if ($content -match "network\.timeout\s*=\s*\d+") {
        $currentTimeout = [regex]::Match($content, "network\.timeout\s*=\s*(\d+)").Groups[1].Value
        Write-Host "   Timeout hien tai: $currentTimeout giay" -ForegroundColor Gray
        
        # Tang len 1800 giay (30 phut) neu nho hon
        if ([int]$currentTimeout -lt 1800) {
            Write-Host "   Dang tang timeout len 1800 giay (30 phut)..." -ForegroundColor Cyan
            $content = $content -replace "network\.timeout\s*=\s*\d+", "network.timeout=1800"
            Set-Content -Path $preferencesPath -Value $content -NoNewline -Encoding UTF8
            Write-Host "   OK Da cap nhat network.timeout=1800" -ForegroundColor Green
        } else {
            Write-Host "   OK Timeout da du lon (>= 1800)" -ForegroundColor Green
        }
    } else {
        Write-Host "   Chua co network.timeout, dang them..." -ForegroundColor Cyan
        if ($content -and -not $content.EndsWith("`n")) {
            $content += "`n"
        }
        $content += "network.timeout=1800`n"
        Set-Content -Path $preferencesPath -Value $content -NoNewline -Encoding UTF8
        Write-Host "   OK Da them network.timeout=1800" -ForegroundColor Green
    }
} else {
    Write-Host "Tao file preferences.txt moi..." -ForegroundColor Cyan
    "network.timeout=1800" | Out-File -FilePath $preferencesPath -Encoding UTF8 -NoNewline
    Write-Host "   OK Da tao file voi network.timeout=1800" -ForegroundColor Green
}

Write-Host ""
Write-Host "Hoan tat!" -ForegroundColor Green
Write-Host ""
Write-Host "Cac buoc tiep theo:" -ForegroundColor Cyan
Write-Host "   1. Mo Arduino IDE" -ForegroundColor White
Write-Host "   2. Tools -> Board -> Boards Manager" -ForegroundColor White
Write-Host "   3. Tim 'esp32'" -ForegroundColor White
Write-Host "   4. Click 'REMOVE' cho version 3.3.5" -ForegroundColor White
Write-Host "   5. Click 'INSTALL' lai cho version 3.3.5" -ForegroundColor White
Write-Host "   6. Doi download tools (co the mat 10-20 phut)" -ForegroundColor White
Write-Host ""
Write-Host "Luu y:" -ForegroundColor Yellow
Write-Host "   - Timeout da duoc tang len 1800 giay (30 phut)" -ForegroundColor Gray
Write-Host "   - Neu van timeout, thu vao gio it nguoi dung" -ForegroundColor Gray
Write-Host "   - Dung ket noi internet on dinh (LAN tot hon WiFi)" -ForegroundColor Gray
Write-Host "   - Tat cac ung dung download khac" -ForegroundColor Gray


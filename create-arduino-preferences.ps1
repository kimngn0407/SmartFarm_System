# PowerShell Script de tao file preferences.txt cho Arduino IDE
# Chay: .\create-arduino-preferences.ps1

Write-Host "Tao file preferences.txt cho Arduino IDE" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

$arduino15Path = "$env:LOCALAPPDATA\Arduino15"
$preferencesPath = "$arduino15Path\preferences.txt"

# Kiem tra thu muc Arduino15
if (-not (Test-Path $arduino15Path)) {
    Write-Host "Thu muc Arduino15 khong ton tai, dang tao..." -ForegroundColor Yellow
    New-Item -ItemType Directory -Force -Path $arduino15Path | Out-Null
    Write-Host "   OK Da tao thu muc: $arduino15Path" -ForegroundColor Green
} else {
    Write-Host "Thu muc Arduino15 da ton tai" -ForegroundColor Green
    Write-Host "   Duong dan: $arduino15Path" -ForegroundColor Gray
}

Write-Host ""

# Kiem tra file preferences.txt
if (Test-Path $preferencesPath) {
    Write-Host "File preferences.txt da ton tai" -ForegroundColor Yellow
    Write-Host "   Duong dan: $preferencesPath" -ForegroundColor Gray
    Write-Host ""
    
    # Doc noi dung hien tai
    $content = Get-Content $preferencesPath -Raw -ErrorAction SilentlyContinue
    
    # Kiem tra da co network.timeout chua
    if ($content -match "network\.timeout\s*=\s*\d+") {
        Write-Host "   Da co network.timeout trong file" -ForegroundColor Yellow
        $currentTimeout = [regex]::Match($content, "network\.timeout\s*=\s*(\d+)").Groups[1].Value
        Write-Host "   Gia tri hien tai: network.timeout=$currentTimeout" -ForegroundColor Gray
        
        if ([int]$currentTimeout -lt 600) {
            Write-Host "   Dang cap nhat len 600..." -ForegroundColor Cyan
            $content = $content -replace "network\.timeout\s*=\s*\d+", "network.timeout=600"
            Set-Content -Path $preferencesPath -Value $content -NoNewline -Encoding UTF8
            Write-Host "   OK Da cap nhat network.timeout=600" -ForegroundColor Green
        } else {
            Write-Host "   OK Gia tri da du lon (>= 600)" -ForegroundColor Green
        }
    } else {
        Write-Host "   Chua co network.timeout, dang them..." -ForegroundColor Cyan
        if (-not $content.EndsWith("`n") -and $content.Length -gt 0) {
            $content += "`n"
        }
        $content += "network.timeout=600`n"
        Set-Content -Path $preferencesPath -Value $content -NoNewline -Encoding UTF8
        Write-Host "   OK Da them network.timeout=600" -ForegroundColor Green
    }
} else {
    Write-Host "File preferences.txt chua ton tai, dang tao..." -ForegroundColor Yellow
    Write-Host "   Duong dan: $preferencesPath" -ForegroundColor Gray
    
    # Tao file moi voi network.timeout=600
    "network.timeout=600" | Out-File -FilePath $preferencesPath -Encoding UTF8 -NoNewline
    Write-Host "   OK Da tao file preferences.txt voi network.timeout=600" -ForegroundColor Green
}

Write-Host ""
Write-Host "Hoan tat!" -ForegroundColor Green
Write-Host ""
Write-Host "Ban co the mo file de kiem tra:" -ForegroundColor Cyan
Write-Host "   notepad $preferencesPath" -ForegroundColor White
Write-Host ""
Write-Host "Hoac chay lenh:" -ForegroundColor Cyan
Write-Host "   notepad %LOCALAPPDATA%\\Arduino15\\preferences.txt" -ForegroundColor White

# PowerShell Script de tao file preferences.txt cho Arduino IDE
# Chay: .\create-arduino-preferences.ps1

Write-Host "Tao file preferences.txt cho Arduino IDE" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

$arduino15Path = "$env:LOCALAPPDATA\Arduino15"
$preferencesPath = "$arduino15Path\preferences.txt"

# Kiem tra thu muc Arduino15
if (-not (Test-Path $arduino15Path)) {
    Write-Host "Thu muc Arduino15 khong ton tai, dang tao..." -ForegroundColor Yellow
    New-Item -ItemType Directory -Force -Path $arduino15Path | Out-Null
    Write-Host "   OK Da tao thu muc: $arduino15Path" -ForegroundColor Green
} else {
    Write-Host "Thu muc Arduino15 da ton tai" -ForegroundColor Green
    Write-Host "   Duong dan: $arduino15Path" -ForegroundColor Gray
}

Write-Host ""

# Kiem tra file preferences.txt
if (Test-Path $preferencesPath) {
    Write-Host "File preferences.txt da ton tai" -ForegroundColor Yellow
    Write-Host "   Duong dan: $preferencesPath" -ForegroundColor Gray
    Write-Host ""
    
    # Doc noi dung hien tai
    $content = Get-Content $preferencesPath -Raw -ErrorAction SilentlyContinue
    
    # Kiem tra da co network.timeout chua
    if ($content -match "network\.timeout\s*=\s*\d+") {
        Write-Host "   Da co network.timeout trong file" -ForegroundColor Yellow
        $currentTimeout = [regex]::Match($content, "network\.timeout\s*=\s*(\d+)").Groups[1].Value
        Write-Host "   Gia tri hien tai: network.timeout=$currentTimeout" -ForegroundColor Gray
        
        if ([int]$currentTimeout -lt 600) {
            Write-Host "   Dang cap nhat len 600..." -ForegroundColor Cyan
            $content = $content -replace "network\.timeout\s*=\s*\d+", "network.timeout=600"
            Set-Content -Path $preferencesPath -Value $content -NoNewline -Encoding UTF8
            Write-Host "   OK Da cap nhat network.timeout=600" -ForegroundColor Green
        } else {
            Write-Host "   OK Gia tri da du lon (>= 600)" -ForegroundColor Green
        }
    } else {
        Write-Host "   Chua co network.timeout, dang them..." -ForegroundColor Cyan
        if (-not $content.EndsWith("`n") -and $content.Length -gt 0) {
            $content += "`n"
        }
        $content += "network.timeout=600`n"
        Set-Content -Path $preferencesPath -Value $content -NoNewline -Encoding UTF8
        Write-Host "   OK Da them network.timeout=600" -ForegroundColor Green
    }
} else {
    Write-Host "File preferences.txt chua ton tai, dang tao..." -ForegroundColor Yellow
    Write-Host "   Duong dan: $preferencesPath" -ForegroundColor Gray
    
    # Tao file moi voi network.timeout=600
    "network.timeout=600" | Out-File -FilePath $preferencesPath -Encoding UTF8 -NoNewline
    Write-Host "   OK Da tao file preferences.txt voi network.timeout=600" -ForegroundColor Green
}

Write-Host ""
Write-Host "Hoan tat!" -ForegroundColor Green
Write-Host ""
Write-Host "Ban co the mo file de kiem tra:" -ForegroundColor Cyan
Write-Host "   notepad $preferencesPath" -ForegroundColor White
Write-Host ""
Write-Host "Hoac chay lenh:" -ForegroundColor Cyan
Write-Host "   notepad %LOCALAPPDATA%\\Arduino15\\preferences.txt" -ForegroundColor White


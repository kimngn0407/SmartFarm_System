# PowerShell Script để Fix ESP32 Download Timeout
# Chạy: .\fix-esp32-timeout.ps1

Write-Host "🔧 Fix ESP32 Download Timeout" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""

$arduinoPath = "$env:LOCALAPPDATA\Arduino15"
$preferencesFile = "$arduinoPath\preferences.txt"

# Kiểm tra Arduino đã cài chưa
if (-not (Test-Path $preferencesFile)) {
    Write-Host "❌ Không tìm thấy Arduino preferences.txt" -ForegroundColor Red
    Write-Host "   Đảm bảo đã cài Arduino IDE" -ForegroundColor Yellow
    exit 1
}

Write-Host "✅ Tìm thấy Arduino preferences.txt" -ForegroundColor Green
Write-Host ""

# Backup preferences
$backupFile = "$preferencesFile.backup.$(Get-Date -Format 'yyyyMMdd_HHmmss')"
Copy-Item $preferencesFile $backupFile
Write-Host "📦 Đã backup preferences.txt → $backupFile" -ForegroundColor Green

# Đọc file preferences
$content = Get-Content $preferencesFile -Raw

# Kiểm tra và thêm network.timeout
if ($content -notmatch "network\.timeout") {
    Write-Host "➕ Thêm network.timeout=600 vào preferences.txt..." -ForegroundColor Yellow
    Add-Content $preferencesFile "`nnetwork.timeout=600"
    Write-Host "✅ Đã thêm network.timeout=600" -ForegroundColor Green
} else {
    Write-Host "⚠️  network.timeout đã có, đang cập nhật..." -ForegroundColor Yellow
    $content = $content -replace "network\.timeout=\d+", "network.timeout=600"
    Set-Content $preferencesFile $content
    Write-Host "✅ Đã cập nhật network.timeout=600" -ForegroundColor Green
}

# Clear cache
Write-Host ""
Write-Host "🧹 Đang xóa cache..." -ForegroundColor Yellow

$stagingPath = "$arduinoPath\staging\packages"
if (Test-Path $stagingPath) {
    Remove-Item -Recurse -Force "$stagingPath\*" -ErrorAction SilentlyContinue
    Write-Host "✅ Đã xóa staging cache" -ForegroundColor Green
}

$esp32Path = "$arduinoPath\packages\esp32"
if (Test-Path $esp32Path) {
    Write-Host "⚠️  Tìm thấy ESP32 package cũ" -ForegroundColor Yellow
    $response = Read-Host "Bạn có muốn xóa để cài lại? (y/N)"
    if ($response -eq "y" -or $response -eq "Y") {
        Remove-Item -Recurse -Force $esp32Path -ErrorAction SilentlyContinue
        Write-Host "✅ Đã xóa ESP32 package cũ" -ForegroundColor Green
    }
}

Write-Host ""
Write-Host "✅ Hoàn tất!" -ForegroundColor Green
Write-Host ""
Write-Host "📝 Bước tiếp theo:" -ForegroundColor Cyan
Write-Host "   1. Mở Arduino IDE" -ForegroundColor White
Write-Host "   2. File → Preferences" -ForegroundColor White
Write-Host "   3. Thêm URL: https://raw.githubusercontent.com/espressif/arduino-esp32/gh-pages/package_esp32_index.json" -ForegroundColor White
Write-Host "   4. Tools → Board → Boards Manager" -ForegroundColor White
Write-Host "   5. Tìm 'esp32' và cài 'esp32 by Espressif Systems'" -ForegroundColor White
Write-Host ""
Write-Host "💡 Mẹo: Chọn version 2.0.11 thay vì 3.3.5 (nhỏ hơn, nhanh hơn)" -ForegroundColor Yellow

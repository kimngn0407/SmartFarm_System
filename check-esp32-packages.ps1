# PowerShell Script để kiểm tra ESP32 Packages
# Chạy: .\check-esp32-packages.ps1

Write-Host "🔍 Kiểm tra ESP32 Packages" -ForegroundColor Cyan
Write-Host "===========================" -ForegroundColor Cyan
Write-Host ""

$esp32Path = "$env:LOCALAPPDATA\Arduino15\packages\esp32"

# Kiểm tra thư mục có tồn tại không
if (-not (Test-Path $esp32Path)) {
    Write-Host "❌ Thư mục ESP32 packages không tồn tại" -ForegroundColor Red
    Write-Host "   Đường dẫn: $esp32Path" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "💡 Giải pháp:" -ForegroundColor Cyan
    Write-Host "   1. Mở Arduino IDE" -ForegroundColor White
    Write-Host "   2. Tools → Board → Boards Manager" -ForegroundColor White
    Write-Host "   3. Tìm 'esp32' và cài 'esp32 by Espressif Systems'" -ForegroundColor White
    exit 1
}

Write-Host "✅ Thư mục ESP32 packages tồn tại" -ForegroundColor Green
Write-Host "   Đường dẫn: $esp32Path" -ForegroundColor Gray
Write-Host ""

# Kiểm tra hardware
$hardwarePath = "$esp32Path\hardware\esp32"
if (Test-Path $hardwarePath) {
    Write-Host "📦 Hardware packages:" -ForegroundColor Cyan
    $versions = Get-ChildItem $hardwarePath -Directory -ErrorAction SilentlyContinue
    if ($versions) {
        foreach ($version in $versions) {
            $versionName = $version.Name
            $size = (Get-ChildItem $version.FullName -Recurse -File -ErrorAction SilentlyContinue | 
                     Measure-Object -Property Length -Sum).Sum / 1MB
            Write-Host "   ✅ Version: $versionName ($([math]::Round($size, 2)) MB)" -ForegroundColor Green
        }
    } else {
        Write-Host "   ⚠️  Không tìm thấy version nào" -ForegroundColor Yellow
    }
} else {
    Write-Host "❌ Không tìm thấy hardware packages" -ForegroundColor Red
    Write-Host "   Đường dẫn: $hardwarePath" -ForegroundColor Yellow
}

Write-Host ""

# Kiểm tra tools
$toolsPath = "$esp32Path\tools"
if (Test-Path $toolsPath) {
    Write-Host "🔧 Tools:" -ForegroundColor Cyan
    $tools = Get-ChildItem $toolsPath -Directory -ErrorAction SilentlyContinue
    if ($tools) {
        foreach ($tool in $tools) {
            $toolName = $tool.Name
            Write-Host "   ✅ $toolName" -ForegroundColor Green
        }
    } else {
        Write-Host "   ⚠️  Không tìm thấy tools" -ForegroundColor Yellow
    }
} else {
    Write-Host "❌ Không tìm thấy tools" -ForegroundColor Red
    Write-Host "   Đường dẫn: $toolsPath" -ForegroundColor Yellow
}

Write-Host ""

# Tổng kích thước
$totalSize = (Get-ChildItem $esp32Path -Recurse -File -ErrorAction SilentlyContinue | 
              Measure-Object -Property Length -Sum).Sum / 1MB
Write-Host "📊 Tổng kích thước: $([math]::Round($totalSize, 2)) MB" -ForegroundColor Cyan
Write-Host ""

# Kiểm tra preferences.txt
$preferencesFile = "$env:LOCALAPPDATA\Arduino15\preferences.txt"
if (Test-Path $preferencesFile) {
    Write-Host "⚙️  Preferences.txt:" -ForegroundColor Cyan
    $content = Get-Content $preferencesFile -Raw
    
    if ($content -match "network\.timeout=(\d+)") {
        $timeout = $matches[1]
        Write-Host "   ✅ network.timeout = $timeout" -ForegroundColor Green
        if ([int]$timeout -lt 300) {
            Write-Host "   ⚠️  Timeout quá ngắn, nên tăng lên 600" -ForegroundColor Yellow
        }
    } else {
        Write-Host "   ⚠️  Không tìm thấy network.timeout" -ForegroundColor Yellow
        Write-Host "   💡 Nên thêm: network.timeout=600" -ForegroundColor Yellow
    }
    
    if ($content -match "boardsmanager\.additional\.urls.*esp32") {
        Write-Host "   ✅ ESP32 URL đã có trong preferences" -ForegroundColor Green
    } else {
        Write-Host "   ⚠️  ESP32 URL chưa có trong preferences" -ForegroundColor Yellow
    }
} else {
    Write-Host "❌ Không tìm thấy preferences.txt" -ForegroundColor Red
}

Write-Host ""
Write-Host "✅ Kiểm tra hoàn tất!" -ForegroundColor Green

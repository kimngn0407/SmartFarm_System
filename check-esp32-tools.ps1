# PowerShell Script để kiểm tra ESP32 Tools
# Chạy: .\check-esp32-tools.ps1

Write-Host "🔧 Kiểm tra ESP32 Tools" -ForegroundColor Cyan
Write-Host "========================" -ForegroundColor Cyan
Write-Host ""

$toolsPath = "$env:LOCALAPPDATA\Arduino15\packages\esp32\tools"

# Kiểm tra thư mục tools
if (-not (Test-Path $toolsPath)) {
    Write-Host "❌ Thư mục tools không tồn tại" -ForegroundColor Red
    Write-Host "   Đường dẫn: $toolsPath" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "💡 Giải pháp:" -ForegroundColor Cyan
    Write-Host "   Tools → Board → Boards Manager → Install ESP32 3.3.5" -ForegroundColor White
    exit 1
}

Write-Host "✅ Thư mục tools tồn tại" -ForegroundColor Green
Write-Host "   Đường dẫn: $toolsPath" -ForegroundColor Gray
Write-Host ""

# Danh sách tools cần thiết
$requiredTools = @(
    "xtensa-esp32-elf-gcc",
    "esptool_py",
    "mkspiffs",
    "mklittlefs",
    "partitions"
)

Write-Host "📦 Kiểm tra tools cần thiết:" -ForegroundColor Cyan
Write-Host ""

$allOk = $true
foreach ($tool in $requiredTools) {
    $toolPath = Join-Path $toolsPath $tool
    if (Test-Path $toolPath) {
        $versions = Get-ChildItem $toolPath -Directory -ErrorAction SilentlyContinue
        if ($versions) {
            $versionList = ($versions | ForEach-Object { $_.Name }) -join ", "
            Write-Host "   ✅ $tool (versions: $versionList)" -ForegroundColor Green
        } else {
            Write-Host "   ⚠️  $tool - Thư mục trống" -ForegroundColor Yellow
            $allOk = $false
        }
    } else {
        Write-Host "   ❌ $tool - KHÔNG TÌM THẤY" -ForegroundColor Red
        $allOk = $false
    }
}

Write-Host ""

if ($allOk) {
    Write-Host "✅ Tất cả tools đã được cài đặt!" -ForegroundColor Green
    Write-Host ""
    Write-Host "💡 Nếu vẫn lỗi compile:" -ForegroundColor Cyan
    Write-Host "   1. Restart Arduino IDE" -ForegroundColor White
    Write-Host "   2. Kiểm tra Tools → Board → ESP32 Dev Module đã chọn" -ForegroundColor White
    Write-Host "   3. Kiểm tra Tools → Port → COMx đã chọn" -ForegroundColor White
} else {
    Write-Host "❌ Một số tools chưa được cài đặt!" -ForegroundColor Red
    Write-Host ""
    Write-Host "💡 Giải pháp:" -ForegroundColor Cyan
    Write-Host "   1. Tools → Board → Boards Manager" -ForegroundColor White
    Write-Host "   2. Tìm 'esp32'" -ForegroundColor White
    Write-Host "   3. Click 'INSTALL' cho version 3.3.5" -ForegroundColor White
    Write-Host "   4. Arduino IDE sẽ download tools (không download hardware nữa)" -ForegroundColor White
    Write-Host ""
    Write-Host "   Hoặc download manual từ:" -ForegroundColor Yellow
    Write-Host "   https://github.com/espressif/arduino-esp32/releases/tag/3.3.5" -ForegroundColor Yellow
}

Write-Host ""

# Tính tổng kích thước tools
$totalSize = (Get-ChildItem $toolsPath -Recurse -File -ErrorAction SilentlyContinue | 
              Measure-Object -Property Length -Sum).Sum / 1MB
Write-Host "📊 Tổng kích thước tools: $([math]::Round($totalSize, 2)) MB" -ForegroundColor Cyan

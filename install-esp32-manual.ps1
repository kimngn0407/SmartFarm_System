# PowerShell Script để cài ESP32 Package Manual
# Usage: .\install-esp32-manual.ps1 "C:\path\to\esp32-3.3.5.zip"

param(
    [Parameter(Mandatory=$true)]
    [string]$ZipPath
)

Write-Host "📦 Cài ESP32 Package Manual" -ForegroundColor Cyan
Write-Host "============================" -ForegroundColor Cyan
Write-Host ""

# Kiểm tra file zip có tồn tại không
if (-not (Test-Path $ZipPath)) {
    Write-Host "❌ Không tìm thấy file: $ZipPath" -ForegroundColor Red
    Write-Host ""
    Write-Host "💡 Usage: .\install-esp32-manual.ps1 `"C:\path\to\esp32-3.3.5.zip`"" -ForegroundColor Yellow
    exit 1
}

Write-Host "✅ Tìm thấy file: $ZipPath" -ForegroundColor Green
Write-Host ""

# Đường dẫn đích
$targetPath = "$env:LOCALAPPDATA\Arduino15\packages\esp32\hardware\esp32\3.3.5"

Write-Host "📂 Đường dẫn đích: $targetPath" -ForegroundColor Cyan
Write-Host ""

# Tạo thư mục nếu chưa có
if (-not (Test-Path $targetPath)) {
    Write-Host "📁 Đang tạo thư mục..." -ForegroundColor Yellow
    New-Item -ItemType Directory -Force -Path $targetPath | Out-Null
    Write-Host "✅ Đã tạo thư mục" -ForegroundColor Green
} else {
    Write-Host "⚠️  Thư mục đã tồn tại" -ForegroundColor Yellow
    $response = Read-Host "Bạn có muốn xóa và giải nén lại? (y/N)"
    if ($response -eq "y" -or $response -eq "Y") {
        Remove-Item -Recurse -Force $targetPath -ErrorAction SilentlyContinue
        New-Item -ItemType Directory -Force -Path $targetPath | Out-Null
        Write-Host "✅ Đã xóa và tạo lại thư mục" -ForegroundColor Green
    }
}

Write-Host ""
Write-Host "📦 Đang giải nén file ZIP..." -ForegroundColor Yellow

try {
    Expand-Archive -Path $ZipPath -DestinationPath $targetPath -Force
    Write-Host "✅ Đã giải nén thành công!" -ForegroundColor Green
} catch {
    Write-Host "❌ Lỗi khi giải nén: $_" -ForegroundColor Red
    exit 1
}

Write-Host ""

# Kiểm tra file quan trọng
Write-Host "🔍 Kiểm tra files..." -ForegroundColor Cyan

$requiredFiles = @("boards.txt", "platform.txt")
$allOk = $true

foreach ($file in $requiredFiles) {
    $filePath = Join-Path $targetPath $file
    if (Test-Path $filePath) {
        Write-Host "   ✅ $file" -ForegroundColor Green
    } else {
        Write-Host "   ❌ $file - KHÔNG TÌM THẤY!" -ForegroundColor Red
        $allOk = $false
    }
}

# Kiểm tra thư mục quan trọng
$requiredDirs = @("cores", "variants", "libraries")
foreach ($dir in $requiredDirs) {
    $dirPath = Join-Path $targetPath $dir
    if (Test-Path $dirPath) {
        Write-Host "   ✅ $dir/" -ForegroundColor Green
    } else {
        Write-Host "   ⚠️  $dir/ - không tìm thấy" -ForegroundColor Yellow
    }
}

Write-Host ""

if (-not $allOk) {
    Write-Host "⚠️  CẢNH BÁO: Một số file quan trọng không tìm thấy!" -ForegroundColor Red
    Write-Host "   Kiểm tra lại cách giải nén file ZIP" -ForegroundColor Yellow
    Write-Host "   File phải được giải nén TRỰC TIẾP vào thư mục 3.3.5" -ForegroundColor Yellow
    exit 1
}

# Tính kích thước
$size = (Get-ChildItem $targetPath -Recurse -File -ErrorAction SilentlyContinue | 
         Measure-Object -Property Length -Sum).Sum / 1MB
Write-Host "📊 Kích thước: $([math]::Round($size, 2)) MB" -ForegroundColor Cyan
Write-Host ""

Write-Host "✅ Cài đặt hoàn tất!" -ForegroundColor Green
Write-Host ""
Write-Host "📝 Bước tiếp theo:" -ForegroundColor Cyan
Write-Host "   1. Đóng Arduino IDE (nếu đang mở)" -ForegroundColor White
Write-Host "   2. Mở lại Arduino IDE" -ForegroundColor White
Write-Host "   3. Tools → Board → ESP32 Arduino → ESP32 Dev Module" -ForegroundColor White
Write-Host "   4. Tools → Port → Chọn COM port của ESP32" -ForegroundColor White
Write-Host "   5. Test upload code" -ForegroundColor White
Write-Host ""
Write-Host "⚠️  LƯU Ý: Bạn vẫn cần cài Tools (xtensa-esp32-elf, esptool, etc.)" -ForegroundColor Yellow
Write-Host "   Arduino IDE sẽ tự động download tools khi bạn upload code lần đầu" -ForegroundColor Yellow
Write-Host "   Hoặc cài từ Boards Manager (sẽ chỉ download tools, không download hardware nữa)" -ForegroundColor Yellow

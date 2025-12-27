# PowerShell Script để Fix Lỗi Compile ESP32
# Chạy: .\fix-esp32-compile-error.ps1

Write-Host "🔧 Fix Lỗi Compile ESP32 - Tools Missing" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

# Bước 1: Kiểm tra tools
Write-Host "📦 Bước 1: Kiểm tra ESP32 Tools..." -ForegroundColor Yellow
Write-Host ""

$toolsPath = "$env:LOCALAPPDATA\Arduino15\packages\esp32\tools"
$requiredTools = @(
    "xtensa-esp32-elf-gcc",
    "esptool_py",
    "mkspiffs",
    "mklittlefs",
    "partitions"
)

$toolsMissing = $false
if (-not (Test-Path $toolsPath)) {
    Write-Host "❌ Thư mục tools không tồn tại!" -ForegroundColor Red
    $toolsMissing = $true
} else {
    foreach ($tool in $requiredTools) {
        $toolPath = Join-Path $toolsPath $tool
        if (-not (Test-Path $toolPath)) {
            Write-Host "   ❌ $tool - KHÔNG TÌM THẤY" -ForegroundColor Red
            $toolsMissing = $true
        } else {
            $versions = Get-ChildItem $toolPath -Directory -ErrorAction SilentlyContinue
            if (-not $versions) {
                Write-Host "   ⚠️  $tool - Thư mục trống" -ForegroundColor Yellow
                $toolsMissing = $true
            } else {
                Write-Host "   ✅ $tool" -ForegroundColor Green
            }
        }
    }
}

Write-Host ""

if (-not $toolsMissing) {
    Write-Host "✅ Tất cả tools đã có!" -ForegroundColor Green
    Write-Host ""
    Write-Host "💡 Nếu vẫn lỗi compile:" -ForegroundColor Cyan
    Write-Host "   1. Restart Arduino IDE" -ForegroundColor White
    Write-Host "   2. Kiểm tra Tools → Board → ESP32 Dev Module" -ForegroundColor White
    Write-Host "   3. Kiểm tra Tools → Port → COMx" -ForegroundColor White
    exit 0
}

Write-Host "❌ Tools chưa đầy đủ - Cần cài tools" -ForegroundColor Red
Write-Host ""

# Bước 2: Tăng timeout
Write-Host "⏱️  Bước 2: Tăng network timeout..." -ForegroundColor Yellow
Write-Host ""

$arduino15Path = "$env:LOCALAPPDATA\Arduino15"
$preferencesPath = "$arduino15Path\preferences.txt"

# Tạo thư mục Arduino15 nếu chưa có
if (-not (Test-Path $arduino15Path)) {
    Write-Host "   📁 Tạo thư mục Arduino15..." -ForegroundColor Cyan
    New-Item -ItemType Directory -Force -Path $arduino15Path | Out-Null
    Write-Host "   ✅ Đã tạo thư mục Arduino15" -ForegroundColor Green
}

if (Test-Path $preferencesPath) {
    $content = Get-Content $preferencesPath -Raw -ErrorAction SilentlyContinue
    
    if ($content -match "network\.timeout\s*=\s*\d+") {
        Write-Host "   ⚠️  network.timeout đã có, đang cập nhật..." -ForegroundColor Yellow
        $currentTimeout = [regex]::Match($content, "network\.timeout\s*=\s*(\d+)").Groups[1].Value
        if ([int]$currentTimeout -lt 600) {
            $content = $content -replace "network\.timeout\s*=\s*\d+", "network.timeout=600"
            Set-Content -Path $preferencesPath -Value $content -NoNewline -Encoding UTF8
            Write-Host "   ✅ Đã cập nhật network.timeout=600" -ForegroundColor Green
        } else {
            Write-Host "   ✅ network.timeout đã đủ lớn (>= 600)" -ForegroundColor Green
        }
    } else {
        Write-Host "   ➕ Thêm network.timeout=600..." -ForegroundColor Cyan
        if ($content -and -not $content.EndsWith("`n")) {
            $content += "`n"
        }
        $content += "network.timeout=600`n"
        Set-Content -Path $preferencesPath -Value $content -NoNewline -Encoding UTF8
        Write-Host "   ✅ Đã thêm network.timeout=600" -ForegroundColor Green
    }
} else {
    Write-Host "   ⚠️  Không tìm thấy preferences.txt" -ForegroundColor Yellow
    Write-Host "   💡 Tạo file mới..." -ForegroundColor Cyan
    "network.timeout=600" | Out-File -FilePath $preferencesPath -Encoding UTF8 -NoNewline
    Write-Host "   ✅ Đã tạo preferences.txt với network.timeout=600" -ForegroundColor Green
}

Write-Host ""

# Bước 3: Hướng dẫn cài tools
Write-Host "📥 Bước 3: Hướng dẫn cài Tools" -ForegroundColor Yellow
Write-Host ""
Write-Host "   ⚠️  QUAN TRỌNG: Đóng Arduino IDE trước khi tiếp tục!" -ForegroundColor Red
Write-Host ""
Write-Host "   Sau khi đóng Arduino IDE, làm theo các bước sau:" -ForegroundColor White
Write-Host ""
Write-Host "   1. Mở Arduino IDE" -ForegroundColor Cyan
Write-Host "   2. Tools → Board → Boards Manager" -ForegroundColor Cyan
Write-Host "   3. Tìm 'esp32'" -ForegroundColor Cyan
Write-Host "   4. Click 'REMOVE' cho version 3.3.5" -ForegroundColor Cyan
Write-Host "   5. Click 'INSTALL' lại cho version 3.3.5" -ForegroundColor Cyan
Write-Host "   6. Đợi download tools (5-10 phút)" -ForegroundColor Cyan
Write-Host ""
Write-Host "   💡 Lưu ý:" -ForegroundColor Yellow
Write-Host "      - Tools nhỏ hơn hardware (~50-100MB vs ~200MB)" -ForegroundColor Gray
Write-Host "      - Ít bị timeout hơn" -ForegroundColor Gray
Write-Host "      - Arduino IDE sẽ chỉ download tools, không download hardware nữa" -ForegroundColor Gray
Write-Host ""

# Kiểm tra Arduino IDE đang chạy
$arduinoProcess = Get-Process -Name "arduino" -ErrorAction SilentlyContinue
if ($arduinoProcess) {
    Write-Host "   ⚠️  WARNING: Arduino IDE đang chạy!" -ForegroundColor Red
    Write-Host "   💡 Vui lòng đóng Arduino IDE trước khi cài tools" -ForegroundColor Yellow
    Write-Host ""
    $close = Read-Host "   Bạn có muốn đóng Arduino IDE ngay bây giờ? (y/n)"
    if ($close -eq "y" -or $close -eq "Y") {
        Stop-Process -Name "arduino" -Force -ErrorAction SilentlyContinue
        Write-Host "   ✅ Đã đóng Arduino IDE" -ForegroundColor Green
    }
}

Write-Host ""
Write-Host "✅ Script hoàn tất!" -ForegroundColor Green
Write-Host ""
Write-Host "📋 Checklist:" -ForegroundColor Cyan
Write-Host "   [ ] Đã tăng network.timeout=600" -ForegroundColor White
Write-Host "   [ ] Đã đóng Arduino IDE" -ForegroundColor White
Write-Host "   [ ] Đã REMOVE ESP32 3.3.5 từ Boards Manager" -ForegroundColor White
Write-Host "   [ ] Đã INSTALL lại ESP32 3.3.5" -ForegroundColor White
Write-Host "   [ ] Đã đợi download tools hoàn tất" -ForegroundColor White
Write-Host "   [ ] Đã restart Arduino IDE" -ForegroundColor White
Write-Host "   [ ] Đã thử compile lại code" -ForegroundColor White
Write-Host ""
Write-Host "💡 Sau khi cài tools, chạy lại script này để kiểm tra:" -ForegroundColor Cyan
Write-Host "   .\check-esp32-tools.ps1" -ForegroundColor White

# PowerShell Script để Fix Lỗi Compile ESP32
# Chạy: .\fix-esp32-compile-error.ps1

Write-Host "🔧 Fix Lỗi Compile ESP32 - Tools Missing" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

# Bước 1: Kiểm tra tools
Write-Host "📦 Bước 1: Kiểm tra ESP32 Tools..." -ForegroundColor Yellow
Write-Host ""

$toolsPath = "$env:LOCALAPPDATA\Arduino15\packages\esp32\tools"
$requiredTools = @(
    "xtensa-esp32-elf-gcc",
    "esptool_py",
    "mkspiffs",
    "mklittlefs",
    "partitions"
)

$toolsMissing = $false
if (-not (Test-Path $toolsPath)) {
    Write-Host "❌ Thư mục tools không tồn tại!" -ForegroundColor Red
    $toolsMissing = $true
} else {
    foreach ($tool in $requiredTools) {
        $toolPath = Join-Path $toolsPath $tool
        if (-not (Test-Path $toolPath)) {
            Write-Host "   ❌ $tool - KHÔNG TÌM THẤY" -ForegroundColor Red
            $toolsMissing = $true
        } else {
            $versions = Get-ChildItem $toolPath -Directory -ErrorAction SilentlyContinue
            if (-not $versions) {
                Write-Host "   ⚠️  $tool - Thư mục trống" -ForegroundColor Yellow
                $toolsMissing = $true
            } else {
                Write-Host "   ✅ $tool" -ForegroundColor Green
            }
        }
    }
}

Write-Host ""

if (-not $toolsMissing) {
    Write-Host "✅ Tất cả tools đã có!" -ForegroundColor Green
    Write-Host ""
    Write-Host "💡 Nếu vẫn lỗi compile:" -ForegroundColor Cyan
    Write-Host "   1. Restart Arduino IDE" -ForegroundColor White
    Write-Host "   2. Kiểm tra Tools → Board → ESP32 Dev Module" -ForegroundColor White
    Write-Host "   3. Kiểm tra Tools → Port → COMx" -ForegroundColor White
    exit 0
}

Write-Host "❌ Tools chưa đầy đủ - Cần cài tools" -ForegroundColor Red
Write-Host ""

# Bước 2: Tăng timeout
Write-Host "⏱️  Bước 2: Tăng network timeout..." -ForegroundColor Yellow
Write-Host ""

$arduino15Path = "$env:LOCALAPPDATA\Arduino15"
$preferencesPath = "$arduino15Path\preferences.txt"

# Tạo thư mục Arduino15 nếu chưa có
if (-not (Test-Path $arduino15Path)) {
    Write-Host "   📁 Tạo thư mục Arduino15..." -ForegroundColor Cyan
    New-Item -ItemType Directory -Force -Path $arduino15Path | Out-Null
    Write-Host "   ✅ Đã tạo thư mục Arduino15" -ForegroundColor Green
}

if (Test-Path $preferencesPath) {
    $content = Get-Content $preferencesPath -Raw -ErrorAction SilentlyContinue
    
    if ($content -match "network\.timeout\s*=\s*\d+") {
        Write-Host "   ⚠️  network.timeout đã có, đang cập nhật..." -ForegroundColor Yellow
        $currentTimeout = [regex]::Match($content, "network\.timeout\s*=\s*(\d+)").Groups[1].Value
        if ([int]$currentTimeout -lt 600) {
            $content = $content -replace "network\.timeout\s*=\s*\d+", "network.timeout=600"
            Set-Content -Path $preferencesPath -Value $content -NoNewline -Encoding UTF8
            Write-Host "   ✅ Đã cập nhật network.timeout=600" -ForegroundColor Green
        } else {
            Write-Host "   ✅ network.timeout đã đủ lớn (>= 600)" -ForegroundColor Green
        }
    } else {
        Write-Host "   ➕ Thêm network.timeout=600..." -ForegroundColor Cyan
        if ($content -and -not $content.EndsWith("`n")) {
            $content += "`n"
        }
        $content += "network.timeout=600`n"
        Set-Content -Path $preferencesPath -Value $content -NoNewline -Encoding UTF8
        Write-Host "   ✅ Đã thêm network.timeout=600" -ForegroundColor Green
    }
} else {
    Write-Host "   ⚠️  Không tìm thấy preferences.txt" -ForegroundColor Yellow
    Write-Host "   💡 Tạo file mới..." -ForegroundColor Cyan
    "network.timeout=600" | Out-File -FilePath $preferencesPath -Encoding UTF8 -NoNewline
    Write-Host "   ✅ Đã tạo preferences.txt với network.timeout=600" -ForegroundColor Green
}

Write-Host ""

# Bước 3: Hướng dẫn cài tools
Write-Host "📥 Bước 3: Hướng dẫn cài Tools" -ForegroundColor Yellow
Write-Host ""
Write-Host "   ⚠️  QUAN TRỌNG: Đóng Arduino IDE trước khi tiếp tục!" -ForegroundColor Red
Write-Host ""
Write-Host "   Sau khi đóng Arduino IDE, làm theo các bước sau:" -ForegroundColor White
Write-Host ""
Write-Host "   1. Mở Arduino IDE" -ForegroundColor Cyan
Write-Host "   2. Tools → Board → Boards Manager" -ForegroundColor Cyan
Write-Host "   3. Tìm 'esp32'" -ForegroundColor Cyan
Write-Host "   4. Click 'REMOVE' cho version 3.3.5" -ForegroundColor Cyan
Write-Host "   5. Click 'INSTALL' lại cho version 3.3.5" -ForegroundColor Cyan
Write-Host "   6. Đợi download tools (5-10 phút)" -ForegroundColor Cyan
Write-Host ""
Write-Host "   💡 Lưu ý:" -ForegroundColor Yellow
Write-Host "      - Tools nhỏ hơn hardware (~50-100MB vs ~200MB)" -ForegroundColor Gray
Write-Host "      - Ít bị timeout hơn" -ForegroundColor Gray
Write-Host "      - Arduino IDE sẽ chỉ download tools, không download hardware nữa" -ForegroundColor Gray
Write-Host ""

# Kiểm tra Arduino IDE đang chạy
$arduinoProcess = Get-Process -Name "arduino" -ErrorAction SilentlyContinue
if ($arduinoProcess) {
    Write-Host "   ⚠️  WARNING: Arduino IDE đang chạy!" -ForegroundColor Red
    Write-Host "   💡 Vui lòng đóng Arduino IDE trước khi cài tools" -ForegroundColor Yellow
    Write-Host ""
    $close = Read-Host "   Bạn có muốn đóng Arduino IDE ngay bây giờ? (y/n)"
    if ($close -eq "y" -or $close -eq "Y") {
        Stop-Process -Name "arduino" -Force -ErrorAction SilentlyContinue
        Write-Host "   ✅ Đã đóng Arduino IDE" -ForegroundColor Green
    }
}

Write-Host ""
Write-Host "✅ Script hoàn tất!" -ForegroundColor Green
Write-Host ""
Write-Host "📋 Checklist:" -ForegroundColor Cyan
Write-Host "   [ ] Đã tăng network.timeout=600" -ForegroundColor White
Write-Host "   [ ] Đã đóng Arduino IDE" -ForegroundColor White
Write-Host "   [ ] Đã REMOVE ESP32 3.3.5 từ Boards Manager" -ForegroundColor White
Write-Host "   [ ] Đã INSTALL lại ESP32 3.3.5" -ForegroundColor White
Write-Host "   [ ] Đã đợi download tools hoàn tất" -ForegroundColor White
Write-Host "   [ ] Đã restart Arduino IDE" -ForegroundColor White
Write-Host "   [ ] Đã thử compile lại code" -ForegroundColor White
Write-Host ""
Write-Host "💡 Sau khi cài tools, chạy lại script này để kiểm tra:" -ForegroundColor Cyan
Write-Host "   .\check-esp32-tools.ps1" -ForegroundColor White


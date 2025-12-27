# PowerShell Script de lay URLs download ESP32 tools
# Chay: .\get-esp32-tools-urls.ps1

Write-Host "Lay URLs Download ESP32 Tools" -ForegroundColor Cyan
Write-Host "==============================" -ForegroundColor Cyan
Write-Host ""

# Download package index
$packageIndexUrl = "https://raw.githubusercontent.com/espressif/arduino-esp32/gh-pages/package_esp32_index.json"
$tempFile = Join-Path $env:TEMP "package_esp32_index.json"

Write-Host "Dang tai package index..." -ForegroundColor Cyan
try {
    Invoke-WebRequest -Uri $packageIndexUrl -OutFile $tempFile -UseBasicParsing
    Write-Host "OK Da tai package index" -ForegroundColor Green
} catch {
    Write-Host "ERROR: Khong the tai package index: $_" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Dang phan tich package index..." -ForegroundColor Cyan

# Doc JSON
$json = Get-Content $tempFile -Raw | ConvertFrom-Json

# Tim platform ESP32 3.3.5
$platform = $json.packages | Where-Object { $_.name -eq "esp32" } | 
            Select-Object -ExpandProperty platforms | 
            Where-Object { $_.version -eq "3.3.5" } | 
            Select-Object -First 1

if (-not $platform) {
    Write-Host "ERROR: Khong tim thay ESP32 3.3.5 trong package index" -ForegroundColor Red
    exit 1
}

Write-Host "OK Tim thay ESP32 3.3.5" -ForegroundColor Green
Write-Host ""

# Tim tools
$tools = $platform.toolsDependencies | ForEach-Object {
    $toolName = $_.name
    $toolVersion = $_.version
    
    # Tim tool trong package
    $tool = $json.packages | Where-Object { $_.name -eq "esp32" } | 
            Select-Object -ExpandProperty tools | 
            Where-Object { $_.name -eq $toolName -and $_.version -eq $toolVersion } | 
            Select-Object -First 1
    
    if ($tool) {
        # Tim URL cho Windows 64-bit
        $win64Url = $tool.systems | Where-Object { $_.host -eq "x86_64-mingw32" } | 
                    Select-Object -ExpandProperty url -First 1
        
        if ($win64Url) {
            [PSCustomObject]@{
                Name = $toolName
                Version = $toolVersion
                URL = $win64Url
                Size = ($tool.systems | Where-Object { $_.host -eq "x86_64-mingw32" } | Select-Object -ExpandProperty size -First 1)
            }
        }
    }
}

Write-Host "Danh sach Tools can download:" -ForegroundColor Yellow
Write-Host "============================" -ForegroundColor Yellow
Write-Host ""

$downloadPath = "$env:USERPROFILE\Downloads\esp32-tools"
New-Item -ItemType Directory -Force -Path $downloadPath | Out-Null

$index = 1
foreach ($tool in $tools) {
    if ($tool) {
        $fileName = Split-Path $tool.URL -Leaf
        $filePath = Join-Path $downloadPath $fileName
        
        Write-Host "$index. $($tool.Name) (version $($tool.Version))" -ForegroundColor Cyan
        Write-Host "   URL: $($tool.URL)" -ForegroundColor Gray
        if ($tool.Size) {
            $sizeMB = [math]::Round($tool.Size / 1MB, 2)
            Write-Host "   Kich thuoc: $sizeMB MB" -ForegroundColor Gray
        }
        Write-Host "   File: $fileName" -ForegroundColor Gray
        Write-Host ""
        
        $index++
    }
}

Write-Host "============================" -ForegroundColor Yellow
Write-Host ""
Write-Host "Cac buoc tiep theo:" -ForegroundColor Cyan
Write-Host "   1. Download cac file ZIP tu URLs tren" -ForegroundColor White
Write-Host "   2. Luu vao: $downloadPath" -ForegroundColor White
Write-Host "   3. Chay script: .\install-esp32-tools-manual.ps1" -ForegroundColor White
Write-Host ""

# Luu danh sach URLs vao file
$urlsFile = Join-Path $downloadPath "download-urls.txt"
$tools | Where-Object { $_ } | ForEach-Object {
    "$($_.Name) - $($_.Version)`n$($_.URL)`n"
} | Out-File -FilePath $urlsFile -Encoding UTF8

Write-Host "Da luu danh sach URLs vao: $urlsFile" -ForegroundColor Green

# Xoa file tam
Remove-Item $tempFile -ErrorAction SilentlyContinue

# PowerShell Script de lay URLs download ESP32 tools
# Chay: .\get-esp32-tools-urls.ps1

Write-Host "Lay URLs Download ESP32 Tools" -ForegroundColor Cyan
Write-Host "==============================" -ForegroundColor Cyan
Write-Host ""

# Download package index
$packageIndexUrl = "https://raw.githubusercontent.com/espressif/arduino-esp32/gh-pages/package_esp32_index.json"
$tempFile = Join-Path $env:TEMP "package_esp32_index.json"

Write-Host "Dang tai package index..." -ForegroundColor Cyan
try {
    Invoke-WebRequest -Uri $packageIndexUrl -OutFile $tempFile -UseBasicParsing
    Write-Host "OK Da tai package index" -ForegroundColor Green
} catch {
    Write-Host "ERROR: Khong the tai package index: $_" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Dang phan tich package index..." -ForegroundColor Cyan

# Doc JSON
$json = Get-Content $tempFile -Raw | ConvertFrom-Json

# Tim platform ESP32 3.3.5
$platform = $json.packages | Where-Object { $_.name -eq "esp32" } | 
            Select-Object -ExpandProperty platforms | 
            Where-Object { $_.version -eq "3.3.5" } | 
            Select-Object -First 1

if (-not $platform) {
    Write-Host "ERROR: Khong tim thay ESP32 3.3.5 trong package index" -ForegroundColor Red
    exit 1
}

Write-Host "OK Tim thay ESP32 3.3.5" -ForegroundColor Green
Write-Host ""

# Tim tools
$tools = $platform.toolsDependencies | ForEach-Object {
    $toolName = $_.name
    $toolVersion = $_.version
    
    # Tim tool trong package
    $tool = $json.packages | Where-Object { $_.name -eq "esp32" } | 
            Select-Object -ExpandProperty tools | 
            Where-Object { $_.name -eq $toolName -and $_.version -eq $toolVersion } | 
            Select-Object -First 1
    
    if ($tool) {
        # Tim URL cho Windows 64-bit
        $win64Url = $tool.systems | Where-Object { $_.host -eq "x86_64-mingw32" } | 
                    Select-Object -ExpandProperty url -First 1
        
        if ($win64Url) {
            [PSCustomObject]@{
                Name = $toolName
                Version = $toolVersion
                URL = $win64Url
                Size = ($tool.systems | Where-Object { $_.host -eq "x86_64-mingw32" } | Select-Object -ExpandProperty size -First 1)
            }
        }
    }
}

Write-Host "Danh sach Tools can download:" -ForegroundColor Yellow
Write-Host "============================" -ForegroundColor Yellow
Write-Host ""

$downloadPath = "$env:USERPROFILE\Downloads\esp32-tools"
New-Item -ItemType Directory -Force -Path $downloadPath | Out-Null

$index = 1
foreach ($tool in $tools) {
    if ($tool) {
        $fileName = Split-Path $tool.URL -Leaf
        $filePath = Join-Path $downloadPath $fileName
        
        Write-Host "$index. $($tool.Name) (version $($tool.Version))" -ForegroundColor Cyan
        Write-Host "   URL: $($tool.URL)" -ForegroundColor Gray
        if ($tool.Size) {
            $sizeMB = [math]::Round($tool.Size / 1MB, 2)
            Write-Host "   Kich thuoc: $sizeMB MB" -ForegroundColor Gray
        }
        Write-Host "   File: $fileName" -ForegroundColor Gray
        Write-Host ""
        
        $index++
    }
}

Write-Host "============================" -ForegroundColor Yellow
Write-Host ""
Write-Host "Cac buoc tiep theo:" -ForegroundColor Cyan
Write-Host "   1. Download cac file ZIP tu URLs tren" -ForegroundColor White
Write-Host "   2. Luu vao: $downloadPath" -ForegroundColor White
Write-Host "   3. Chay script: .\install-esp32-tools-manual.ps1" -ForegroundColor White
Write-Host ""

# Luu danh sach URLs vao file
$urlsFile = Join-Path $downloadPath "download-urls.txt"
$tools | Where-Object { $_ } | ForEach-Object {
    "$($_.Name) - $($_.Version)`n$($_.URL)`n"
} | Out-File -FilePath $urlsFile -Encoding UTF8

Write-Host "Da luu danh sach URLs vao: $urlsFile" -ForegroundColor Green

# Xoa file tam
Remove-Item $tempFile -ErrorAction SilentlyContinue


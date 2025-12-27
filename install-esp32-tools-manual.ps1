# PowerShell Script de cai ESP32 Tools thu cong
# Chay: .\install-esp32-tools-manual.ps1
# 
# Yeu cau: Da download cac file ZIP tools vao Downloads\esp32-tools

Write-Host "Cai ESP32 Tools Thu cong" -ForegroundColor Cyan
Write-Host "=========================" -ForegroundColor Cyan
Write-Host ""

$toolsPath = "$env:LOCALAPPDATA\Arduino15\packages\esp32\tools"
$downloadPath = "$env:USERPROFILE\Downloads\esp32-tools"

# Kiem tra thu muc download
if (-not (Test-Path $downloadPath)) {
    Write-Host "WARNING: Thu muc download khong ton tai!" -ForegroundColor Red
    Write-Host "   Duong dan: $downloadPath" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Huong dan:" -ForegroundColor Cyan
    Write-Host "   1. Tao thu muc: $downloadPath" -ForegroundColor White
    Write-Host "   2. Download cac file ZIP tools vao thu muc do" -ForegroundColor White
    Write-Host "   3. Chay lai script nay" -ForegroundColor White
    Write-Host ""
    Write-Host "   Xem huong dan chi tiet: INSTALL_ESP32_TOOLS_MANUAL.md" -ForegroundColor Yellow
    exit 1
}

# Tao thu muc tools neu chua co
Write-Host "Tao thu muc tools..." -ForegroundColor Cyan
New-Item -ItemType Directory -Force -Path $toolsPath | Out-Null
Write-Host "   OK Thu muc tools: $toolsPath" -ForegroundColor Green
Write-Host ""

# Mapping giua file ZIP va tool name/version (ESP32 3.3.5)
$toolMappings = @{
    "xtensa-esp-elf-14.2.0_20251107-x86_64-w64-mingw32.zip" = @{
        ToolName = "esp-x32"
        Version = "2511"
        ExeFile = "xtensa-esp-elf-gcc.exe"
        SubDir = "bin"
    }
    "esptool-v5.1.0-windows-amd64.zip" = @{
        ToolName = "esptool_py"
        Version = "5.1.0"
        ExeFile = "esptool.py"
        SubDir = ""
    }
    "x86_64-w64-mingw32-mklittlefs-db0513a.zip" = @{
        ToolName = "mklittlefs"
        Version = "4.0.2-db0513a"
        ExeFile = "mklittlefs.exe"
        SubDir = ""
    }
    "openocd-esp32-win64-0.12.0-esp32-20250707.zip" = @{
        ToolName = "openocd-esp32"
        Version = "v0.12.0-esp32-20250707"
        ExeFile = "openocd.exe"
        SubDir = ""
    }
    "xtensa-esp-elf-gdb-16.3_20250913-x86_64-w64-mingw32.zip" = @{
        ToolName = "xtensa-esp-elf-gdb"
        Version = "16.3_20250913"
        ExeFile = "xtensa-esp-elf-gdb.exe"
        SubDir = "bin"
    }
    "riscv32-esp-elf-14.2.0_20251107-x86_64-w64-mingw32.zip" = @{
        ToolName = "esp-rv32"
        Version = "2511"
        ExeFile = "riscv32-esp-elf-gcc.exe"
        SubDir = "bin"
    }
    "riscv32-esp-elf-gdb-16.3_20250913-x86_64-w64-mingw32.zip" = @{
        ToolName = "riscv32-esp-elf-gdb"
        Version = "16.3_20250913"
        ExeFile = "riscv32-esp-elf-gdb.exe"
        SubDir = "bin"
    }
    "esp32-3.3.5-libs.zip" = @{
        ToolName = "esp32-arduino-libs"
        Version = "idf-release_v5.5-9bb7aa84-v2"
        ExeFile = ""  # Khong co exe, chi la libraries
        SubDir = ""
    }
}

# Tim tat ca file ZIP trong thu muc download
$zipFiles = Get-ChildItem -Path $downloadPath -Filter "*.zip" -ErrorAction SilentlyContinue

if (-not $zipFiles) {
    Write-Host "ERROR: Khong tim thay file ZIP nao trong $downloadPath" -ForegroundColor Red
    exit 1
}

Write-Host "Tim thay $($zipFiles.Count) file ZIP" -ForegroundColor Green
Write-Host ""

$allOk = $true
$installedCount = 0

foreach ($zipFile in $zipFiles) {
    $fileName = $zipFile.Name
    
    # Tim mapping cho file nay
    $mapping = $null
    foreach ($key in $toolMappings.Keys) {
        if ($fileName -like "*$key*" -or $fileName -eq $key) {
            $mapping = $toolMappings[$key]
            break
        }
    }
    
    # Neu khong co mapping, thu tim theo ten file
    if (-not $mapping) {
        if ($fileName -like "*esp32-3.3.5-libs*" -or $fileName -like "*esp32-*-libs*") {
            $mapping = @{
                ToolName = "esp32-arduino-libs"
                Version = "idf-release_v5.5-9bb7aa84-v2"
                ExeFile = ""
                SubDir = ""
            }
        } elseif ($fileName -like "*xtensa-esp-elf*" -and $fileName -notlike "*gdb*") {
            $mapping = @{
                ToolName = "esp-x32"
                Version = "2511"
                ExeFile = "xtensa-esp-elf-gcc.exe"
                SubDir = "bin"
            }
        } elseif ($fileName -like "*esptool*") {
            $mapping = @{
                ToolName = "esptool_py"
                Version = "5.1.0"
                ExeFile = "esptool.py"
                SubDir = ""
            }
        } elseif ($fileName -like "*mklittlefs*") {
            $mapping = @{
                ToolName = "mklittlefs"
                Version = "4.0.2-db0513a"
                ExeFile = "mklittlefs.exe"
                SubDir = ""
            }
        } elseif ($fileName -like "*openocd*") {
            $mapping = @{
                ToolName = "openocd-esp32"
                Version = "v0.12.0-esp32-20250707"
                ExeFile = "openocd.exe"
                SubDir = ""
            }
        } else {
            Write-Host "WARNING: Khong tim thay mapping cho: $fileName" -ForegroundColor Yellow
            Write-Host "   Bo qua file nay" -ForegroundColor Gray
            continue
        }
    }
    
    Write-Host "Xu ly $fileName..." -ForegroundColor Yellow
    Write-Host "   Tool: $($mapping.ToolName) version $($mapping.Version)" -ForegroundColor Gray
    
    # Tao thu muc tool
    $targetDir = Join-Path $toolsPath $mapping.ToolName
    $versionDir = Join-Path $targetDir $mapping.Version
    New-Item -ItemType Directory -Force -Path $targetDir | Out-Null
    
    # Kiem tra da co chua
    if (Test-Path $versionDir) {
        Write-Host "   WARNING: Version $($mapping.Version) da ton tai" -ForegroundColor Yellow
        $skip = Read-Host "   Ban co muon ghi de? (y/n)"
        if ($skip -ne "y" -and $skip -ne "Y") {
            Write-Host "   Bo qua $($mapping.ToolName)" -ForegroundColor Gray
            continue
        }
        Remove-Item -Recurse -Force $versionDir
    }
    
    # Giai nen tam thoi
    $tempDir = Join-Path $env:TEMP "esp32-tool-$($mapping.ToolName)-$(Get-Random)"
    if (Test-Path $tempDir) {
        Remove-Item -Recurse -Force $tempDir
    }
    New-Item -ItemType Directory -Force -Path $tempDir | Out-Null
    
    Write-Host "   Dang giai nen..." -ForegroundColor Cyan
    try {
        Expand-Archive -Path $zipFile.FullName -DestinationPath $tempDir -Force
        
        # Dac biet cho esp32-arduino-libs: Giai nen truc tiep vao versionDir
        if ($mapping.ToolName -eq "esp32-arduino-libs") {
            New-Item -ItemType Directory -Force -Path $versionDir | Out-Null
            # Di chuyen toan bo noi dung tu tempDir vao versionDir
            Get-ChildItem -Path $tempDir | Move-Item -Destination $versionDir -Force
            Write-Host "   OK Da cai $($mapping.ToolName) version $($mapping.Version)" -ForegroundColor Green
            $installedCount++
        } else {
            # Tim thu muc chua file thuc thi hoac di chuyen toan bo
            $firstDir = Get-ChildItem -Path $tempDir -Directory | Select-Object -First 1
            
            if ($firstDir) {
                # Di chuyen toan bo thu muc dau tien vao versionDir
                Move-Item -Path $firstDir.FullName -Destination $versionDir -Force
                Write-Host "   OK Da cai $($mapping.ToolName) version $($mapping.Version)" -ForegroundColor Green
                $installedCount++
            } else {
                # Neu khong co thu muc, co the la file flat - di chuyen toan bo noi dung
                $files = Get-ChildItem -Path $tempDir -File
                if ($files) {
                    New-Item -ItemType Directory -Force -Path $versionDir | Out-Null
                    Move-Item -Path "$tempDir\*" -Destination $versionDir -Force
                    Write-Host "   OK Da cai $($mapping.ToolName) version $($mapping.Version)" -ForegroundColor Green
                    $installedCount++
                } else {
                    Write-Host "   ERROR: Khong the giai nen dung cau truc" -ForegroundColor Red
                    $allOk = $false
                }
            }
        }
        
        # Xoa thu muc tam (neu con ton tai)
        if (Test-Path $tempDir) {
            Start-Sleep -Milliseconds 500
            Remove-Item -Recurse -Force $tempDir -ErrorAction SilentlyContinue
        }
        
    } catch {
        Write-Host "   ERROR: Loi khi giai nen: $_" -ForegroundColor Red
        $allOk = $false
        if (Test-Path $tempDir) {
            Start-Sleep -Milliseconds 500
            Remove-Item -Recurse -Force $tempDir -ErrorAction SilentlyContinue
        }
    }
    
    Write-Host ""
}

Write-Host "=========================" -ForegroundColor Cyan
Write-Host ""

# Ghi chu: esp32-3.3.5-libs.zip da duoc xu ly trong vong lap tren

if ($installedCount -gt 0) {
    Write-Host "Da cai $installedCount tool(s)!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Kiem tra tools:" -ForegroundColor Cyan
    Write-Host "   .\check-esp32-tools.ps1" -ForegroundColor White
    Write-Host ""
    Write-Host "Sau do:" -ForegroundColor Yellow
    Write-Host "   1. Restart Arduino IDE" -ForegroundColor White
    Write-Host "   2. Thu compile code ESP32" -ForegroundColor White
} else {
    Write-Host "Khong cai duoc tool nao!" -ForegroundColor Red
    Write-Host "Vui long kiem tra lai cac file ZIP" -ForegroundColor Yellow
}

# PowerShell Script de cai ESP32 Tools thu cong
# Chay: .\install-esp32-tools-manual.ps1
# 
# Yeu cau: Da download cac file ZIP tools vao Downloads\esp32-tools

Write-Host "Cai ESP32 Tools Thu cong" -ForegroundColor Cyan
Write-Host "=========================" -ForegroundColor Cyan
Write-Host ""

$toolsPath = "$env:LOCALAPPDATA\Arduino15\packages\esp32\tools"
$downloadPath = "$env:USERPROFILE\Downloads\esp32-tools"

# Kiem tra thu muc download
if (-not (Test-Path $downloadPath)) {
    Write-Host "WARNING: Thu muc download khong ton tai!" -ForegroundColor Red
    Write-Host "   Duong dan: $downloadPath" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Huong dan:" -ForegroundColor Cyan
    Write-Host "   1. Tao thu muc: $downloadPath" -ForegroundColor White
    Write-Host "   2. Download cac file ZIP tools vao thu muc do" -ForegroundColor White
    Write-Host "   3. Chay lai script nay" -ForegroundColor White
    Write-Host ""
    Write-Host "   Xem huong dan chi tiet: INSTALL_ESP32_TOOLS_MANUAL.md" -ForegroundColor Yellow
    exit 1
}

# Tao thu muc tools neu chua co
Write-Host "Tao thu muc tools..." -ForegroundColor Cyan
New-Item -ItemType Directory -Force -Path $toolsPath | Out-Null
Write-Host "   OK Thu muc tools: $toolsPath" -ForegroundColor Green
Write-Host ""

# Mapping giua file ZIP va tool name/version (ESP32 3.3.5)
$toolMappings = @{
    "xtensa-esp-elf-14.2.0_20251107-x86_64-w64-mingw32.zip" = @{
        ToolName = "esp-x32"
        Version = "2511"
        ExeFile = "xtensa-esp-elf-gcc.exe"
        SubDir = "bin"
    }
    "esptool-v5.1.0-windows-amd64.zip" = @{
        ToolName = "esptool_py"
        Version = "5.1.0"
        ExeFile = "esptool.py"
        SubDir = ""
    }
    "x86_64-w64-mingw32-mklittlefs-db0513a.zip" = @{
        ToolName = "mklittlefs"
        Version = "4.0.2-db0513a"
        ExeFile = "mklittlefs.exe"
        SubDir = ""
    }
    "openocd-esp32-win64-0.12.0-esp32-20250707.zip" = @{
        ToolName = "openocd-esp32"
        Version = "v0.12.0-esp32-20250707"
        ExeFile = "openocd.exe"
        SubDir = ""
    }
    "xtensa-esp-elf-gdb-16.3_20250913-x86_64-w64-mingw32.zip" = @{
        ToolName = "xtensa-esp-elf-gdb"
        Version = "16.3_20250913"
        ExeFile = "xtensa-esp-elf-gdb.exe"
        SubDir = "bin"
    }
    "riscv32-esp-elf-14.2.0_20251107-x86_64-w64-mingw32.zip" = @{
        ToolName = "esp-rv32"
        Version = "2511"
        ExeFile = "riscv32-esp-elf-gcc.exe"
        SubDir = "bin"
    }
    "riscv32-esp-elf-gdb-16.3_20250913-x86_64-w64-mingw32.zip" = @{
        ToolName = "riscv32-esp-elf-gdb"
        Version = "16.3_20250913"
        ExeFile = "riscv32-esp-elf-gdb.exe"
        SubDir = "bin"
    }
    "esp32-3.3.5-libs.zip" = @{
        ToolName = "esp32-arduino-libs"
        Version = "idf-release_v5.5-9bb7aa84-v2"
        ExeFile = ""  # Khong co exe, chi la libraries
        SubDir = ""
    }
}

# Tim tat ca file ZIP trong thu muc download
$zipFiles = Get-ChildItem -Path $downloadPath -Filter "*.zip" -ErrorAction SilentlyContinue

if (-not $zipFiles) {
    Write-Host "ERROR: Khong tim thay file ZIP nao trong $downloadPath" -ForegroundColor Red
    exit 1
}

Write-Host "Tim thay $($zipFiles.Count) file ZIP" -ForegroundColor Green
Write-Host ""

$allOk = $true
$installedCount = 0

foreach ($zipFile in $zipFiles) {
    $fileName = $zipFile.Name
    
    # Tim mapping cho file nay
    $mapping = $null
    foreach ($key in $toolMappings.Keys) {
        if ($fileName -like "*$key*" -or $fileName -eq $key) {
            $mapping = $toolMappings[$key]
            break
        }
    }
    
    # Neu khong co mapping, thu tim theo ten file
    if (-not $mapping) {
        if ($fileName -like "*esp32-3.3.5-libs*" -or $fileName -like "*esp32-*-libs*") {
            $mapping = @{
                ToolName = "esp32-arduino-libs"
                Version = "idf-release_v5.5-9bb7aa84-v2"
                ExeFile = ""
                SubDir = ""
            }
        } elseif ($fileName -like "*xtensa-esp-elf*" -and $fileName -notlike "*gdb*") {
            $mapping = @{
                ToolName = "esp-x32"
                Version = "2511"
                ExeFile = "xtensa-esp-elf-gcc.exe"
                SubDir = "bin"
            }
        } elseif ($fileName -like "*esptool*") {
            $mapping = @{
                ToolName = "esptool_py"
                Version = "5.1.0"
                ExeFile = "esptool.py"
                SubDir = ""
            }
        } elseif ($fileName -like "*mklittlefs*") {
            $mapping = @{
                ToolName = "mklittlefs"
                Version = "4.0.2-db0513a"
                ExeFile = "mklittlefs.exe"
                SubDir = ""
            }
        } elseif ($fileName -like "*openocd*") {
            $mapping = @{
                ToolName = "openocd-esp32"
                Version = "v0.12.0-esp32-20250707"
                ExeFile = "openocd.exe"
                SubDir = ""
            }
        } else {
            Write-Host "WARNING: Khong tim thay mapping cho: $fileName" -ForegroundColor Yellow
            Write-Host "   Bo qua file nay" -ForegroundColor Gray
            continue
        }
    }
    
    Write-Host "Xu ly $fileName..." -ForegroundColor Yellow
    Write-Host "   Tool: $($mapping.ToolName) version $($mapping.Version)" -ForegroundColor Gray
    
    # Tao thu muc tool
    $targetDir = Join-Path $toolsPath $mapping.ToolName
    $versionDir = Join-Path $targetDir $mapping.Version
    New-Item -ItemType Directory -Force -Path $targetDir | Out-Null
    
    # Kiem tra da co chua
    if (Test-Path $versionDir) {
        Write-Host "   WARNING: Version $($mapping.Version) da ton tai" -ForegroundColor Yellow
        $skip = Read-Host "   Ban co muon ghi de? (y/n)"
        if ($skip -ne "y" -and $skip -ne "Y") {
            Write-Host "   Bo qua $($mapping.ToolName)" -ForegroundColor Gray
            continue
        }
        Remove-Item -Recurse -Force $versionDir
    }
    
    # Giai nen tam thoi
    $tempDir = Join-Path $env:TEMP "esp32-tool-$($mapping.ToolName)-$(Get-Random)"
    if (Test-Path $tempDir) {
        Remove-Item -Recurse -Force $tempDir
    }
    New-Item -ItemType Directory -Force -Path $tempDir | Out-Null
    
    Write-Host "   Dang giai nen..." -ForegroundColor Cyan
    try {
        Expand-Archive -Path $zipFile.FullName -DestinationPath $tempDir -Force
        
        # Dac biet cho esp32-arduino-libs: Giai nen truc tiep vao versionDir
        if ($mapping.ToolName -eq "esp32-arduino-libs") {
            New-Item -ItemType Directory -Force -Path $versionDir | Out-Null
            # Di chuyen toan bo noi dung tu tempDir vao versionDir
            Get-ChildItem -Path $tempDir | Move-Item -Destination $versionDir -Force
            Write-Host "   OK Da cai $($mapping.ToolName) version $($mapping.Version)" -ForegroundColor Green
            $installedCount++
        } else {
            # Tim thu muc chua file thuc thi hoac di chuyen toan bo
            $firstDir = Get-ChildItem -Path $tempDir -Directory | Select-Object -First 1
            
            if ($firstDir) {
                # Di chuyen toan bo thu muc dau tien vao versionDir
                Move-Item -Path $firstDir.FullName -Destination $versionDir -Force
                Write-Host "   OK Da cai $($mapping.ToolName) version $($mapping.Version)" -ForegroundColor Green
                $installedCount++
            } else {
                # Neu khong co thu muc, co the la file flat - di chuyen toan bo noi dung
                $files = Get-ChildItem -Path $tempDir -File
                if ($files) {
                    New-Item -ItemType Directory -Force -Path $versionDir | Out-Null
                    Move-Item -Path "$tempDir\*" -Destination $versionDir -Force
                    Write-Host "   OK Da cai $($mapping.ToolName) version $($mapping.Version)" -ForegroundColor Green
                    $installedCount++
                } else {
                    Write-Host "   ERROR: Khong the giai nen dung cau truc" -ForegroundColor Red
                    $allOk = $false
                }
            }
        }
        
        # Xoa thu muc tam (neu con ton tai)
        if (Test-Path $tempDir) {
            Start-Sleep -Milliseconds 500
            Remove-Item -Recurse -Force $tempDir -ErrorAction SilentlyContinue
        }
        
    } catch {
        Write-Host "   ERROR: Loi khi giai nen: $_" -ForegroundColor Red
        $allOk = $false
        if (Test-Path $tempDir) {
            Start-Sleep -Milliseconds 500
            Remove-Item -Recurse -Force $tempDir -ErrorAction SilentlyContinue
        }
    }
    
    Write-Host ""
}

Write-Host "=========================" -ForegroundColor Cyan
Write-Host ""

# Ghi chu: esp32-3.3.5-libs.zip da duoc xu ly trong vong lap tren

if ($installedCount -gt 0) {
    Write-Host "Da cai $installedCount tool(s)!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Kiem tra tools:" -ForegroundColor Cyan
    Write-Host "   .\check-esp32-tools.ps1" -ForegroundColor White
    Write-Host ""
    Write-Host "Sau do:" -ForegroundColor Yellow
    Write-Host "   1. Restart Arduino IDE" -ForegroundColor White
    Write-Host "   2. Thu compile code ESP32" -ForegroundColor White
} else {
    Write-Host "Khong cai duoc tool nao!" -ForegroundColor Red
    Write-Host "Vui long kiem tra lai cac file ZIP" -ForegroundColor Yellow
}


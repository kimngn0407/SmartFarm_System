# PowerShell Script de chuyen thu muc esp32-tools tu o C: sang o E:
# Chay: .\move-esp32-tools-to-e.ps1

Write-Host "Chuyen ESP32 Tools tu o C: sang o E:" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

# Thư mục nguồn (trên ổ C:)
$sourceDir = "$env:USERPROFILE\Downloads\esp32-tools"

# Thư mục đích (trên ổ E:)
$targetDir = "E:\esp32-tools"

# Kiểm tra thư mục nguồn
if (-not (Test-Path $sourceDir)) {
    Write-Host "WARNING: Khong tim thay thu muc nguon!" -ForegroundColor Yellow
    Write-Host "   Duong dan: $sourceDir" -ForegroundColor Gray
    Write-Host ""
    Write-Host "Co the thu muc da duoc chuyen roi hoac chua ton tai" -ForegroundColor Cyan
    exit 0
}

Write-Host "Tim thay thu muc nguon: $sourceDir" -ForegroundColor Green

# Kiểm tra thư mục đích
if (Test-Path $targetDir) {
    Write-Host ""
    Write-Host "WARNING: Thu muc dich da ton tai!" -ForegroundColor Yellow
    Write-Host "   Duong dan: $targetDir" -ForegroundColor Gray
    Write-Host ""
    $overwrite = Read-Host "Ban co muon ghi de? (y/n)"
    if ($overwrite -ne "y" -and $overwrite -ne "Y") {
        Write-Host "Da huy" -ForegroundColor Yellow
        exit 0
    }
    Write-Host "Dang xoa thu muc cu..." -ForegroundColor Yellow
    Remove-Item -Recurse -Force $targetDir -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 1
}

Write-Host ""
Write-Host "Dang chuyen thu muc..." -ForegroundColor Cyan
Write-Host "   Tu: $sourceDir" -ForegroundColor Gray
Write-Host "   Den: $targetDir" -ForegroundColor Gray
Write-Host ""

try {
    # Di chuyển thư mục
    Move-Item -Path $sourceDir -Destination $targetDir -Force
    Write-Host "OK Da chuyen thu muc thanh cong!" -ForegroundColor Green
    Write-Host ""
    
    # Kiểm tra
    if (Test-Path $targetDir) {
        $fileCount = (Get-ChildItem -Path $targetDir -File -Recurse -ErrorAction SilentlyContinue).Count
        Write-Host "Thu muc dich:" -ForegroundColor Cyan
        Write-Host "   Duong dan: $targetDir" -ForegroundColor Gray
        Write-Host "   So file: $fileCount" -ForegroundColor Gray
        Write-Host ""
        
        # Liệt kê các file ZIP
        $zipFiles = Get-ChildItem -Path $targetDir -Filter "*.zip" -ErrorAction SilentlyContinue
        if ($zipFiles) {
            Write-Host "Cac file ZIP:" -ForegroundColor Cyan
            foreach ($zip in $zipFiles) {
                $sizeMB = [math]::Round($zip.Length / 1MB, 2)
                Write-Host "   - $($zip.Name) ($sizeMB MB)" -ForegroundColor Gray
            }
        }
    }
    
    # Tạo symbolic link từ Downloads sang ổ E: (tùy chọn)
    Write-Host ""
    Write-Host "Ban co muon tao symbolic link tu Downloads sang o E:?" -ForegroundColor Cyan
    Write-Host "   (De cac script cu van hoat dong)" -ForegroundColor Gray
    $createSymlink = Read-Host "   (y/n)"
    
    if ($createSymlink -eq "y" -or $createSymlink -eq "Y") {
        # Kiểm tra quyền Administrator
        $isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
        
        if (-not $isAdmin) {
            Write-Host "WARNING: Can quyen Administrator de tao symbolic link!" -ForegroundColor Yellow
            Write-Host "   Ban co the tao symbolic link thu cong sau" -ForegroundColor Gray
        } else {
            Write-Host "Dang tao symbolic link..." -ForegroundColor Cyan
            try {
                New-Item -ItemType SymbolicLink -Path $sourceDir -Target $targetDir -Force | Out-Null
                Write-Host "OK Da tao symbolic link thanh cong!" -ForegroundColor Green
                Write-Host "   $sourceDir -> $targetDir" -ForegroundColor Gray
            } catch {
                Write-Host "ERROR: Khong the tao symbolic link!" -ForegroundColor Red
                Write-Host "   Loi: $_" -ForegroundColor Yellow
            }
        }
    }
    
} catch {
    Write-Host "ERROR: Khong the chuyen thu muc!" -ForegroundColor Red
    Write-Host "   Loi: $_" -ForegroundColor Yellow
    exit 1
}

Write-Host ""
Write-Host "Hoan tat!" -ForegroundColor Green
Write-Host ""
Write-Host "Luu y:" -ForegroundColor Yellow
Write-Host "   - Cac script se tu dong tim thu muc tren o E:" -ForegroundColor White
Write-Host "   - Neu co symbolic link, cac script cu van hoat dong" -ForegroundColor White
Write-Host "   - Thu muc moi: $targetDir" -ForegroundColor White

# PowerShell Script de chuyen thu muc esp32-tools tu o C: sang o E:
# Chay: .\move-esp32-tools-to-e.ps1

Write-Host "Chuyen ESP32 Tools tu o C: sang o E:" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

# Thư mục nguồn (trên ổ C:)
$sourceDir = "$env:USERPROFILE\Downloads\esp32-tools"

# Thư mục đích (trên ổ E:)
$targetDir = "E:\esp32-tools"

# Kiểm tra thư mục nguồn
if (-not (Test-Path $sourceDir)) {
    Write-Host "WARNING: Khong tim thay thu muc nguon!" -ForegroundColor Yellow
    Write-Host "   Duong dan: $sourceDir" -ForegroundColor Gray
    Write-Host ""
    Write-Host "Co the thu muc da duoc chuyen roi hoac chua ton tai" -ForegroundColor Cyan
    exit 0
}

Write-Host "Tim thay thu muc nguon: $sourceDir" -ForegroundColor Green

# Kiểm tra thư mục đích
if (Test-Path $targetDir) {
    Write-Host ""
    Write-Host "WARNING: Thu muc dich da ton tai!" -ForegroundColor Yellow
    Write-Host "   Duong dan: $targetDir" -ForegroundColor Gray
    Write-Host ""
    $overwrite = Read-Host "Ban co muon ghi de? (y/n)"
    if ($overwrite -ne "y" -and $overwrite -ne "Y") {
        Write-Host "Da huy" -ForegroundColor Yellow
        exit 0
    }
    Write-Host "Dang xoa thu muc cu..." -ForegroundColor Yellow
    Remove-Item -Recurse -Force $targetDir -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 1
}

Write-Host ""
Write-Host "Dang chuyen thu muc..." -ForegroundColor Cyan
Write-Host "   Tu: $sourceDir" -ForegroundColor Gray
Write-Host "   Den: $targetDir" -ForegroundColor Gray
Write-Host ""

try {
    # Di chuyển thư mục
    Move-Item -Path $sourceDir -Destination $targetDir -Force
    Write-Host "OK Da chuyen thu muc thanh cong!" -ForegroundColor Green
    Write-Host ""
    
    # Kiểm tra
    if (Test-Path $targetDir) {
        $fileCount = (Get-ChildItem -Path $targetDir -File -Recurse -ErrorAction SilentlyContinue).Count
        Write-Host "Thu muc dich:" -ForegroundColor Cyan
        Write-Host "   Duong dan: $targetDir" -ForegroundColor Gray
        Write-Host "   So file: $fileCount" -ForegroundColor Gray
        Write-Host ""
        
        # Liệt kê các file ZIP
        $zipFiles = Get-ChildItem -Path $targetDir -Filter "*.zip" -ErrorAction SilentlyContinue
        if ($zipFiles) {
            Write-Host "Cac file ZIP:" -ForegroundColor Cyan
            foreach ($zip in $zipFiles) {
                $sizeMB = [math]::Round($zip.Length / 1MB, 2)
                Write-Host "   - $($zip.Name) ($sizeMB MB)" -ForegroundColor Gray
            }
        }
    }
    
    # Tạo symbolic link từ Downloads sang ổ E: (tùy chọn)
    Write-Host ""
    Write-Host "Ban co muon tao symbolic link tu Downloads sang o E:?" -ForegroundColor Cyan
    Write-Host "   (De cac script cu van hoat dong)" -ForegroundColor Gray
    $createSymlink = Read-Host "   (y/n)"
    
    if ($createSymlink -eq "y" -or $createSymlink -eq "Y") {
        # Kiểm tra quyền Administrator
        $isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
        
        if (-not $isAdmin) {
            Write-Host "WARNING: Can quyen Administrator de tao symbolic link!" -ForegroundColor Yellow
            Write-Host "   Ban co the tao symbolic link thu cong sau" -ForegroundColor Gray
        } else {
            Write-Host "Dang tao symbolic link..." -ForegroundColor Cyan
            try {
                New-Item -ItemType SymbolicLink -Path $sourceDir -Target $targetDir -Force | Out-Null
                Write-Host "OK Da tao symbolic link thanh cong!" -ForegroundColor Green
                Write-Host "   $sourceDir -> $targetDir" -ForegroundColor Gray
            } catch {
                Write-Host "ERROR: Khong the tao symbolic link!" -ForegroundColor Red
                Write-Host "   Loi: $_" -ForegroundColor Yellow
            }
        }
    }
    
} catch {
    Write-Host "ERROR: Khong the chuyen thu muc!" -ForegroundColor Red
    Write-Host "   Loi: $_" -ForegroundColor Yellow
    exit 1
}

Write-Host ""
Write-Host "Hoan tat!" -ForegroundColor Green
Write-Host ""
Write-Host "Luu y:" -ForegroundColor Yellow
Write-Host "   - Cac script se tu dong tim thu muc tren o E:" -ForegroundColor White
Write-Host "   - Neu co symbolic link, cac script cu van hoat dong" -ForegroundColor White
Write-Host "   - Thu muc moi: $targetDir" -ForegroundColor White


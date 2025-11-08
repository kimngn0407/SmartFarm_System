# Script export database PostgreSQL với format sạch, tương thích với VPS
# Usage: .\export-database-clean.ps1

param(
    [Parameter(Mandatory=$false)]
    [string]$ContainerName = "smartfarm-postgres",
    
    [Parameter(Mandatory=$false)]
    [string]$Database = "SmartFarm1",
    
    [Parameter(Mandatory=$false)]
    [string]$User = "postgres",
    
    [Parameter(Mandatory=$false)]
    [string]$OutputFile = ""
)

Write-Host "=== Export Database (Clean Format) ===" -ForegroundColor Cyan
Write-Host ""

# Generate output filename if not provided
if ([string]::IsNullOrEmpty($OutputFile)) {
    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $OutputFile = "smartfarm_backup_clean_$timestamp.sql"
}

Write-Host "Container: $ContainerName" -ForegroundColor Yellow
Write-Host "Database: $Database" -ForegroundColor Yellow
Write-Host "Output file: $OutputFile" -ForegroundColor Yellow
Write-Host ""

# Check if container exists
$containerExists = docker ps -a --format "{{.Names}}" | Select-String -Pattern $ContainerName
if (-not $containerExists) {
    Write-Host "❌ Error: Container '$ContainerName' not found!" -ForegroundColor Red
    exit 1
}

Write-Host "🔄 Exporting database..." -ForegroundColor Cyan

# Export với các options để tạo file dump sạch:
# --no-owner: Bỏ lệnh ALTER TABLE ... OWNER TO
# --no-privileges: Bỏ lệnh GRANT/REVOKE
# --clean: Thêm DROP statements trước CREATE
# --if-exists: Dùng IF EXISTS với DROP
# --create: Thêm CREATE DATABASE statement
# --encoding=UTF8: Đảm bảo encoding đúng
docker exec $ContainerName pg_dump -U $User -d $Database `
    --no-owner `
    --no-privileges `
    --clean `
    --if-exists `
    --create `
    --encoding=UTF8 `
    --format=plain `
    --verbose > $OutputFile

if ($LASTEXITCODE -eq 0) {
    $fileSize = (Get-Item $OutputFile).Length / 1KB
    Write-Host ""
    Write-Host "✅ Export successful!" -ForegroundColor Green
    Write-Host "   File: $OutputFile" -ForegroundColor White
    Write-Host "   Size: $([math]::Round($fileSize, 2)) KB" -ForegroundColor White
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor Yellow
    Write-Host "1. Transfer to VPS: scp $OutputFile root@173.249.48.25:~/projects/SmartFarm/" -ForegroundColor White
    Write-Host "2. On VPS, restore: docker exec -i smartfarm-postgres psql -U postgres < $OutputFile" -ForegroundColor White
} else {
    Write-Host ""
    Write-Host "❌ Export failed!" -ForegroundColor Red
    exit 1
}



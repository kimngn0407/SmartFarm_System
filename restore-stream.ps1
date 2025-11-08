# Script restore database qua SSH streaming (không cần lưu file trên VPS)
# Usage: .\restore-stream.ps1 -DumpFile "database_dump.sql" -VpsHost "173.249.48.25"

param(
    [Parameter(Mandatory=$true)]
    [string]$DumpFile,
    
    [Parameter(Mandatory=$false)]
    [string]$VpsHost = "173.249.48.25",
    
    [Parameter(Mandatory=$false)]
    [string]$VpsUser = "root",
    
    [Parameter(Mandatory=$false)]
    [string]$Database = "SmartFarm1",
    
    [Parameter(Mandatory=$false)]
    [string]$Container = "smartfarm-postgres"
)

Write-Host "=== Restore Database via SSH Streaming ===" -ForegroundColor Cyan
Write-Host ""

# Check if file exists
if (-not (Test-Path $DumpFile)) {
    Write-Host "❌ Error: File not found: $DumpFile" -ForegroundColor Red
    exit 1
}

$fileSize = (Get-Item $DumpFile).Length / 1MB
Write-Host "Dump file: $DumpFile" -ForegroundColor Yellow
Write-Host "File size: $([math]::Round($fileSize, 2)) MB" -ForegroundColor Yellow
Write-Host ""

# Confirm
$confirm = Read-Host "⚠️  This will REPLACE the database on VPS. Continue? (yes/no)"
if ($confirm -ne "yes") {
    Write-Host "❌ Cancelled" -ForegroundColor Red
    exit 0
}

Write-Host ""
Write-Host "🔄 Streaming database dump to VPS..." -ForegroundColor Cyan
Write-Host "This may take a few minutes..." -ForegroundColor Yellow
Write-Host ""

$startTime = Get-Date

# Stream file content via SSH
try {
    Get-Content $DumpFile | ssh "${VpsUser}@${VpsHost}" "docker exec -i ${Container} psql -U postgres -d ${Database}"
    
    $endTime = Get-Date
    $duration = ($endTime - $startTime).TotalSeconds
    
    Write-Host ""
    Write-Host "✅ Restore completed! (took $([math]::Round($duration, 2))s)" -ForegroundColor Green
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor Yellow
    Write-Host "1. Verify data: ssh ${VpsUser}@${VpsHost} 'docker exec -it ${Container} psql -U postgres -d ${Database} -c \"SELECT COUNT(*) FROM account;\"'" -ForegroundColor White
    Write-Host "2. Restart backend: ssh ${VpsUser}@${VpsHost} 'docker compose restart backend'" -ForegroundColor White
    
} catch {
    Write-Host ""
    Write-Host "❌ Restore failed!" -ForegroundColor Red
    Write-Host "Error: $_" -ForegroundColor Red
    Write-Host ""
    Write-Host "Troubleshooting:" -ForegroundColor Yellow
    Write-Host "1. Check SSH connection: ssh ${VpsUser}@${VpsHost}" -ForegroundColor White
    Write-Host "2. Check Docker container: ssh ${VpsUser}@${VpsHost} 'docker ps | grep ${Container}'" -ForegroundColor White
    Write-Host "3. Check database exists: ssh ${VpsUser}@${VpsHost} 'docker exec -it ${Container} psql -U postgres -l'" -ForegroundColor White
    exit 1
}



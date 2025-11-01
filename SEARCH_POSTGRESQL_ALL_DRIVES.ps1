# Search PostgreSQL on ALL drives

Write-Host "="*60 -ForegroundColor Cyan
Write-Host "SEARCHING PostgreSQL ON ALL DRIVES" -ForegroundColor Yellow
Write-Host "This may take 2-5 minutes..." -ForegroundColor Yellow
Write-Host "="*60 -ForegroundColor Cyan
Write-Host ""

$drives = Get-PSDrive -PSProvider FileSystem | Where-Object { $_.Used -ne $null }

Write-Host "Drives to search:" -ForegroundColor Cyan
foreach ($drive in $drives) {
    Write-Host "  $($drive.Name):\" -ForegroundColor White
}
Write-Host ""

$found = @()

foreach ($drive in $drives) {
    $driveLetter = $drive.Name
    Write-Host "Searching drive $driveLetter`:\" -ForegroundColor Yellow
    
    try {
        $results = Get-ChildItem -Path "$driveLetter`:\\" -Recurse -ErrorAction SilentlyContinue -Filter "pg_dump.exe" 2>$null
        
        foreach ($result in $results) {
            $binPath = Split-Path $result.FullName -Parent
            $found += $binPath
            Write-Host "  FOUND: $binPath" -ForegroundColor Green
        }
    } catch {
        # Ignore errors
    }
}

Write-Host ""
Write-Host "="*60 -ForegroundColor Cyan
Write-Host "SEARCH COMPLETE!" -ForegroundColor Green
Write-Host "="*60 -ForegroundColor Cyan
Write-Host ""

if ($found.Count -eq 0) {
    Write-Host "PostgreSQL NOT FOUND on any drive!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Possible reasons:" -ForegroundColor Yellow
    Write-Host "  1. PostgreSQL is not installed" -ForegroundColor White
    Write-Host "  2. You only have pgAdmin (without PostgreSQL)" -ForegroundColor White
    Write-Host "  3. PostgreSQL is installed via WSL" -ForegroundColor White
    Write-Host ""
    Write-Host "Solutions:" -ForegroundColor Yellow
    Write-Host "  Option A: Install PostgreSQL from https://www.postgresql.org/download/windows/" -ForegroundColor White
    Write-Host "  Option B: Use the CREATE_TEST_DATA_VIA_API.html file instead (no PostgreSQL needed!)" -ForegroundColor Cyan
    Write-Host ""
} else {
    Write-Host "Found $($found.Count) PostgreSQL installation(s):" -ForegroundColor Green
    Write-Host ""
    
    for ($i = 0; $i -lt $found.Count; $i++) {
        Write-Host "[$($i+1)] $($found[$i])" -ForegroundColor Magenta
    }
    
    Write-Host ""
    Write-Host "Use this path in AUTO_EXPORT_IMPORT.bat" -ForegroundColor Cyan
    Write-Host ""
    
    # Copy first result to clipboard
    try {
        Set-Clipboard -Value $found[0]
        Write-Host "Path copied to clipboard!" -ForegroundColor Green
    } catch {
        Write-Host "Could not copy to clipboard" -ForegroundColor Yellow
    }
}

Write-Host ""
Read-Host "Press Enter to exit"



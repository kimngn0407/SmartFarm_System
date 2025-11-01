# Find PostgreSQL installation on Windows

Write-Host "🔍 Searching for PostgreSQL..." -ForegroundColor Yellow
Write-Host ""

$possiblePaths = @(
    "C:\Program Files\PostgreSQL",
    "C:\Program Files (x86)\PostgreSQL",
    "D:\PostgreSQL",
    "C:\PostgreSQL"
)

$found = $false

foreach ($basePath in $possiblePaths) {
    if (Test-Path $basePath) {
        Write-Host "Found PostgreSQL folder: $basePath" -ForegroundColor Green
        
        # Get all versions
        $versions = Get-ChildItem -Path $basePath -Directory | Sort-Object Name -Descending
        
        foreach ($version in $versions) {
            $binPath = Join-Path $version.FullName "bin"
            $pgDumpPath = Join-Path $binPath "pg_dump.exe"
            
            if (Test-Path $pgDumpPath) {
                Write-Host ""
                Write-Host "✅ Found pg_dump.exe!" -ForegroundColor Green
                Write-Host "Version: $($version.Name)" -ForegroundColor Cyan
                Write-Host "Path: $binPath" -ForegroundColor Yellow
                Write-Host ""
                Write-Host "Copy this path and paste into the script:" -ForegroundColor White
                Write-Host "$binPath" -ForegroundColor Magenta
                Write-Host ""
                
                # Copy to clipboard if possible
                try {
                    Set-Clipboard -Value $binPath
                    Write-Host "✅ Path copied to clipboard!" -ForegroundColor Green
                } catch {
                    Write-Host "⚠️  Could not copy to clipboard (manual copy needed)" -ForegroundColor Yellow
                }
                
                $found = $true
                break
            }
        }
        
        if ($found) { break }
    }
}

if (-not $found) {
    Write-Host "❌ PostgreSQL not found in common locations!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please check:" -ForegroundColor Yellow
    Write-Host "  1. Is PostgreSQL installed?" -ForegroundColor White
    Write-Host "  2. Where did you install it?" -ForegroundColor White
    Write-Host "  3. Try searching manually in File Explorer" -ForegroundColor White
    Write-Host ""
    Write-Host "Common locations:" -ForegroundColor Yellow
    Write-Host "  - C:\Program Files\PostgreSQL\[version]\bin" -ForegroundColor White
    Write-Host "  - C:\Program Files (x86)\PostgreSQL\[version]\bin" -ForegroundColor White
    Write-Host "  - D:\PostgreSQL\[version]\bin" -ForegroundColor White
}

Write-Host ""
Write-Host "Press any key to exit..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")



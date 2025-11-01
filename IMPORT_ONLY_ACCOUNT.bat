@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion

echo.
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo 🚀 IMPORT CHỈ ACCOUNT TABLE
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.

REM Find PostgreSQL
set "PGBIN="
for %%V in (17 16 15 14) do (
    if exist "C:\Program Files\PostgreSQL\%%V\bin\pg_dump.exe" (
        set "PGBIN=C:\Program Files\PostgreSQL\%%V\bin"
        echo ✅ Tìm thấy PostgreSQL %%V
        goto :FOUND
    )
)

echo ❌ Không tìm thấy PostgreSQL!
pause
exit /b 1

:FOUND

echo.
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo 📤 EXPORT CHỈ ACCOUNT TABLE
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.

set /p "LOCAL_PASSWORD=Nhập password PostgreSQL LOCAL (Ngan0407@!): "
if "!LOCAL_PASSWORD!"=="" set "LOCAL_PASSWORD=Ngan0407@!"

set "PGPASSWORD=!LOCAL_PASSWORD!"
set "ACCOUNT_FILE=%~dp0account_only.sql"

echo Đang export account table...
echo.

"%PGBIN%\pg_dump.exe" -h localhost -p 5432 -U postgres -d SmartFarm1 --table=account --data-only --column-inserts --disable-triggers -f "%ACCOUNT_FILE%"

if errorlevel 1 (
    echo ❌ Export thất bại!
    pause
    exit /b 1
)

for %%A in ("%ACCOUNT_FILE%") do set "FILESIZE=%%~zA"
echo ✅ Export thành công: !FILESIZE! bytes
echo.

echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo 📥 IMPORT VÀO RAILWAY (DISABLE TRIGGERS)
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.

set "RAILWAY_URL=postgresql://postgres:aWdOoPYQUzKzUjLxjSREwszhXUJrZXJn@shinkansen.proxy.rlwy.net:23985/railway"

set /p "CONFIRM=Import account vào Railway? (Y/N): "

if /i not "!CONFIRM!"=="Y" (
    echo Đã hủy!
    pause
    exit /b 0
)

echo.
echo Đang import với ALTER TABLE DISABLE TRIGGER...
echo.

set "PGPASSWORD="

REM Create temp SQL file with trigger disable
set "IMPORT_FILE=%~dp0account_import_temp.sql"

echo ALTER TABLE account DISABLE TRIGGER ALL; > "%IMPORT_FILE%"
type "%ACCOUNT_FILE%" >> "%IMPORT_FILE%"
echo ALTER TABLE account ENABLE TRIGGER ALL; >> "%IMPORT_FILE%"

"%PGBIN%\psql.exe" "%RAILWAY_URL%" -f "%IMPORT_FILE%" -v ON_ERROR_STOP=0

echo.
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo 📊 KIỂM TRA KẾT QUẢ
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.

"%PGBIN%\psql.exe" "%RAILWAY_URL%" -c "SELECT COUNT(*) as account_count FROM account;"

echo.
echo ✅ HOÀN TẤT!
echo.
echo 🎯 TEST NGAY:
echo    https://hackathon-pione-dream.vercel.app/
echo    Login với account từ local!
echo.

REM Cleanup
if exist "%ACCOUNT_FILE%" del "%ACCOUNT_FILE%"
if exist "%IMPORT_FILE%" del "%IMPORT_FILE%"

pause



@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion

echo.
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo 🚀 IMPORT DATABASE TỪ DUMP FILE
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
echo 📤 BƯỚC 1: EXPORT DATA (DATA ONLY)
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.

set /p "LOCAL_PASSWORD=Nhập password PostgreSQL LOCAL (Ngan0407@!): "
if "!LOCAL_PASSWORD!"=="" set "LOCAL_PASSWORD=Ngan0407@!"

set "PGPASSWORD=!LOCAL_PASSWORD!"
set "DUMP_FILE=%~dp0smartfarm_data.sql"

echo Đang export ONLY DATA từ SmartFarm1...
echo.

"%PGBIN%\pg_dump.exe" -h localhost -p 5432 -U postgres -d SmartFarm1 --data-only --column-inserts --disable-triggers -f "%DUMP_FILE%"

if errorlevel 1 (
    echo ❌ Export thất bại!
    pause
    exit /b 1
)

for %%A in ("%DUMP_FILE%") do set "FILESIZE=%%~zA"
echo ✅ Export thành công: !FILESIZE! bytes
echo.

if !FILESIZE! LSS 1000 (
    echo ⚠️  File quá nhỏ, có thể không có data!
    pause
    exit /b 1
)

echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo 📥 BƯỚC 2: XÓA DATA CŨ TRÊN RAILWAY
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.

set "RAILWAY_URL=postgresql://postgres:aWdOoPVQUzkzUjLxjSREwszhXUJrZXJn@shinkansen.proxy.rlwy.net:23985/railway?sslmode=require"

echo ⚠️  XÓA TẤT CẢ DATA TRÊN RAILWAY...
echo.
set /p "CONFIRM=Bạn chắc chắn? (Y/N): "

if /i not "!CONFIRM!"=="Y" (
    echo Đã hủy!
    pause
    exit /b 0
)

set "PGPASSWORD="

echo Đang xóa data...
"%PGBIN%\psql.exe" "!RAILWAY_URL!" -c "TRUNCATE TABLE sensor_data, alert, warning_threshold, coordinates, harvest, irrigation_history, fertilization_history, sensor, field, crop_season, crop_growth_stage, farm, plant, account_roles, account RESTART IDENTITY CASCADE;"

echo ✅ Đã xóa data cũ
echo.

echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo 📥 BƯỚC 3: IMPORT DATA VÀO RAILWAY
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.

echo Đang import...
echo (Có thể mất 1-2 phút...)
echo.

"%PGBIN%\psql.exe" "!RAILWAY_URL!" -f "%DUMP_FILE%" -v ON_ERROR_STOP=0

echo.
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo 📊 BƯỚC 4: KIỂM TRA KẾT QUẢ
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.

"%PGBIN%\psql.exe" "!RAILWAY_URL!" -c "SELECT 'account' as table_name, COUNT(*) FROM account UNION ALL SELECT 'farm', COUNT(*) FROM farm UNION ALL SELECT 'field', COUNT(*) FROM field UNION ALL SELECT 'sensor', COUNT(*) FROM sensor UNION ALL SELECT 'plant', COUNT(*) FROM plant UNION ALL SELECT 'crop_season', COUNT(*) FROM crop_season;"

echo.
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo ✅ HOÀN TẤT!
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.
echo 🎯 TEST NGAY:
echo    1. Refresh Railway Dashboard
echo    2. Vào: https://hackathon-pione-dream.vercel.app/
echo    3. Login với account từ local
echo    4. Xem data hiển thị!
echo.

pause



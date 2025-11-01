@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion

echo.
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo 🚀 IMPORT DATABASE VÀO RAILWAY
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.

REM Find PostgreSQL
set "PGBIN="
for %%V in (17 16 15 14) do (
    if exist "C:\Program Files\PostgreSQL\%%V\bin\psql.exe" (
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
echo 📋 FILE DUMP ĐÃ CÓ SẴN
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.

set "DUMP_FILE=%~dp0smartfarm_data.sql"

if exist "%DUMP_FILE%" (
    for %%A in ("%DUMP_FILE%") do set "FILESIZE=%%~zA"
    echo ✅ File dump tồn tại: !FILESIZE! bytes
    echo    %DUMP_FILE%
) else (
    echo ❌ Không tìm thấy file dump!
    echo    Chạy lại script export trước.
    pause
    exit /b 1
)

echo.
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo 🔐 NHẬP RAILWAY CONNECTION STRING
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.
echo 📋 Vào Railway Dashboard ^> PostgreSQL ^> Connect
echo    Copy "Postgres Connection URL"
echo.
echo 💡 VÍ DỤ:
echo    postgresql://postgres:PASSWORD@shinkansen.proxy.rlwy.net:23985/railway
echo.

set /p "RAILWAY_URL=Paste CONNECTION STRING vào đây: "

if "!RAILWAY_URL!"=="" (
    echo ❌ Bạn chưa nhập connection string!
    pause
    exit /b 1
)

echo.
echo 📋 Connection: !RAILWAY_URL!
echo.

echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo 📥 XÓA DATA CŨ TRÊN RAILWAY
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.

set /p "CONFIRM=Bạn muốn xóa data cũ trên Railway? (Y/N): "

if /i "!CONFIRM!"=="Y" (
    echo Đang xóa data cũ...
    "%PGBIN%\psql.exe" "!RAILWAY_URL!" -c "TRUNCATE TABLE sensor_data, alert, warning_threshold, coordinates, harvest, irrigation_history, fertilization_history, sensor, field, crop_season, crop_growth_stage, farm, plant, account_roles, account RESTART IDENTITY CASCADE;" 2>nul
    
    if errorlevel 1 (
        echo ⚠️  Không thể xóa, có thể tables đã trống
    ) else (
        echo ✅ Đã xóa data cũ
    )
    echo.
)

echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo 📥 IMPORT DATA VÀO RAILWAY
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.

echo Đang import...
echo (Có thể mất 1-2 phút...)
echo.

"%PGBIN%\psql.exe" "!RAILWAY_URL!" -f "%DUMP_FILE%" -v ON_ERROR_STOP=0

if errorlevel 1 (
    echo.
    echo ⚠️  Import có lỗi nhưng có thể một phần data đã được import
    echo.
    echo Thử với sslmode:
    "%PGBIN%\psql.exe" "!RAILWAY_URL!?sslmode=require" -f "%DUMP_FILE%" -v ON_ERROR_STOP=0
)

echo.
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo 📊 KIỂM TRA KẾT QUẢ
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.

"%PGBIN%\psql.exe" "!RAILWAY_URL!" -c "SELECT 'account' as table_name, COUNT(*) FROM account UNION ALL SELECT 'farm', COUNT(*) FROM farm UNION ALL SELECT 'field', COUNT(*) FROM field UNION ALL SELECT 'sensor', COUNT(*) FROM sensor UNION ALL SELECT 'plant', COUNT(*) FROM plant UNION ALL SELECT 'crop_season', COUNT(*) FROM crop_season;"

echo.
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo ✅ HOÀN TẤT!
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.
echo 🎯 TEST NGAY:
echo.
echo 1. Refresh Railway Dashboard
echo    https://railway.app/dashboard → PostgreSQL → Data
echo.
echo 2. Test Frontend
echo    https://hackathon-pione-dream.vercel.app/
echo    Login với account từ local
echo.
echo 3. Nếu thấy data → THÀNH CÔNG! 🎉
echo.

pause



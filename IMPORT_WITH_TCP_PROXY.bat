@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion

echo.
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo 🚀 IMPORT DATA TỪ LOCAL VÀO RAILWAY
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
echo 📋 KIỂM TRA FILE DUMP
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.

set "DUMP_FILE=%~dp0smartfarm_data.sql"

if exist "%DUMP_FILE%" (
    for %%A in ("%DUMP_FILE%") do set "FILESIZE=%%~zA"
    echo ✅ File dump tồn tại: !FILESIZE! bytes
) else (
    echo ❌ Không tìm thấy file dump!
    pause
    exit /b 1
)

echo.
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo 🔐 THỬ KẾT NỐI RAILWAY VỚI TCP PROXY
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.

REM Try with known TCP Proxy
set "RAILWAY_URL=postgresql://postgres:aWdOoPVQUzkzUjLxjSREwszhXUJrZXJn@shinkansen.proxy.rlwy.net:23985/railway"

echo 🔗 URL: shinkansen.proxy.rlwy.net:23985
echo.
echo Đang kiểm tra kết nối...

"%PGBIN%\psql.exe" "%RAILWAY_URL%" -c "SELECT 1;" >nul 2>&1

if errorlevel 1 (
    echo ❌ Kết nối thất bại!
    echo.
    echo ⚠️  Railway credentials có thể đã thay đổi.
    echo.
    echo 📋 VUI LÒNG LẤY CONNECTION STRING MỚI:
    echo    1. Vào: https://railway.app/dashboard
    echo    2. Click: PostgreSQL service
    echo    3. Tab: Connect
    echo    4. Tìm "Available Connections" hoặc "TCP Proxy"
    echo    5. Copy connection string CÓ "shinkansen.proxy.rlwy.net"
    echo.
    echo 💡 VÍ DỤ:
    echo    postgresql://postgres:PASSWORD@shinkansen.proxy.rlwy.net:PORT/railway
    echo.
    echo ❌ KHÔNG dùng: postgres.railway.internal
    echo.
    
    set /p "NEW_URL=Paste CONNECTION STRING mới (hoặc ENTER để thoát): "
    
    if "!NEW_URL!"=="" (
        echo Đã hủy!
        pause
        exit /b 1
    )
    
    set "RAILWAY_URL=!NEW_URL!"
    
    echo.
    echo Đang thử lại...
    "%PGBIN%\psql.exe" "!RAILWAY_URL!" -c "SELECT 1;" >nul 2>&1
    
    if errorlevel 1 (
        echo ❌ Vẫn không kết nối được!
        echo Vui lòng kiểm tra lại URL.
        pause
        exit /b 1
    )
)

echo ✅ Kết nối Railway thành công!
echo.

echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo 📥 XÓA DATA CŨ VÀ IMPORT DATA MỚI
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.

echo ⚠️  Sẽ XÓA HẾT data trên Railway và import data từ local
echo.
set /p "CONFIRM=Bạn chắc chắn? (Y/N): "

if /i not "!CONFIRM!"=="Y" (
    echo Đã hủy!
    pause
    exit /b 0
)

echo.
echo [1/3] Đang xóa data cũ...

"%PGBIN%\psql.exe" "!RAILWAY_URL!" -c "TRUNCATE TABLE sensor_data, alert, warning_threshold, coordinates, harvest, irrigation_history, fertilization_history, sensor, field, crop_season, crop_growth_stage, farm, plant, account_roles, account RESTART IDENTITY CASCADE;" 2>nul

if errorlevel 1 (
    echo    ⚠️  Không thể truncate (có thể tables trống)
) else (
    echo    ✅ Đã xóa data cũ
)

echo.
echo [2/3] Đang import data từ local...
echo       (Có thể mất 1-2 phút, đừng đóng cửa sổ!)
echo.

"%PGBIN%\psql.exe" "!RAILWAY_URL!" -f "%DUMP_FILE%" -v ON_ERROR_STOP=0 2>&1 | findstr /V "INSERT"

echo.
echo [3/3] Đang kiểm tra kết quả...
echo.

"%PGBIN%\psql.exe" "!RAILWAY_URL!" -c "SELECT 'account' as table_name, COUNT(*) as records FROM account UNION ALL SELECT 'farm', COUNT(*) FROM farm UNION ALL SELECT 'field', COUNT(*) FROM field UNION ALL SELECT 'sensor', COUNT(*) FROM sensor UNION ALL SELECT 'plant', COUNT(*) FROM plant UNION ALL SELECT 'crop_season', COUNT(*) FROM crop_season;"

echo.
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo ✅ HOÀN TẤT!
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.
echo 🎯 KIỂM TRA KẾT QUẢ:
echo.
echo 1. Railway Dashboard
echo    https://railway.app/dashboard → PostgreSQL → Data
echo    Click bảng "farm" → Phải thấy 3 records
echo.
echo 2. Frontend
echo    https://hackathon-pione-dream.vercel.app/
echo    Login với account từ local
echo.
echo 3. Nếu thấy data → THÀNH CÔNG! 🎉
echo    Nếu vẫn trống → Kiểm tra lại Railway credentials
echo.

pause



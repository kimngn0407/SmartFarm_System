@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion

echo.
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo 🚀 IMPORT DATABASE VÀO RAILWAY - PHIÊN BẢN CUỐI CÙNG
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.

REM Find PostgreSQL
set "PGBIN="
for %%V in (17 16 15 14 13) do (
    if exist "C:\Program Files\PostgreSQL\%%V\bin\pg_dump.exe" (
        set "PGBIN=C:\Program Files\PostgreSQL\%%V\bin"
        echo ✅ Tìm thấy PostgreSQL %%V: !PGBIN!
        goto :FOUND
    )
)

echo ❌ Không tìm thấy PostgreSQL!
pause
exit /b 1

:FOUND

echo.
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo 📤 BƯỚC 1: EXPORT TỪ LOCAL
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.

set "DUMP_FILE=%~dp0railway_import.sql"

set /p "LOCAL_PASSWORD=Nhập password PostgreSQL LOCAL: "
echo.

set "PGPASSWORD=!LOCAL_PASSWORD!"

echo Đang export từ SmartFarm1...
echo File: %DUMP_FILE%
echo.

"%PGBIN%\pg_dump.exe" -h localhost -p 5432 -U postgres -d SmartFarm1 --data-only --inserts --disable-triggers --column-inserts -f "%DUMP_FILE%"

if errorlevel 1 (
    echo.
    echo ❌ Export THẤT BẠI!
    echo.
    echo Kiểm tra:
    echo 1. Password đúng chưa?
    echo 2. Database SmartFarm1 tồn tại chưa?
    echo 3. PostgreSQL đang chạy chưa?
    echo.
    pause
    exit /b 1
)

if not exist "%DUMP_FILE%" (
    echo ❌ File không được tạo!
    pause
    exit /b 1
)

for %%A in ("%DUMP_FILE%") do set "FILESIZE=%%~zA"

echo.
echo ✅ Export thành công!
echo 📊 Kích thước: !FILESIZE! bytes
echo.

if !FILESIZE! LSS 200 (
    echo ⚠️  File quá nhỏ! Có thể database trống.
    echo.
    type "%DUMP_FILE%"
    echo.
    set /p "CONTINUE=Tiếp tục? (Y/N): "
    if /i not "!CONTINUE!"=="Y" (
        pause
        exit /b 0
    )
)

echo.
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo 📥 BƯỚC 2: IMPORT VÀO RAILWAY
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.

echo 🔗 Railway Connection:
echo    Host: shinkansen.proxy.rlwy.net
echo    Port: 23985
echo    Database: railway
echo    User: postgres
echo.

set "RAILWAY_URL=postgresql://postgres:aWdOoPVQUzkzUjLxjSREwszhXUJrZXJn@shinkansen.proxy.rlwy.net:23985/railway"

set /p "CONFIRM=Import vào Railway? (Y/N): "
if /i not "!CONFIRM!"=="Y" (
    echo Đã hủy!
    pause
    exit /b 0
)

echo.
echo Đang import...
echo (Có thể mất vài phút, đừng đóng cửa sổ!)
echo.

REM Clear PGPASSWORD for Railway connection
set "PGPASSWORD="

REM Try with sslmode=require
"%PGBIN%\psql.exe" "%RAILWAY_URL%?sslmode=require" -f "%DUMP_FILE%" -v ON_ERROR_STOP=0 2>&1

if errorlevel 1 (
    echo.
    echo ⚠️  Có lỗi, thử không dùng SSL...
    echo.
    "%PGBIN%\psql.exe" "%RAILWAY_URL%" -f "%DUMP_FILE%" -v ON_ERROR_STOP=0 2>&1
)

echo.
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo 📊 BƯỚC 3: KIỂM TRA KẾT QUẢ
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.

echo Đang kiểm tra số lượng data...
echo.

"%PGBIN%\psql.exe" "%RAILWAY_URL%?sslmode=require" -c "SELECT 'farm' as table_name, COUNT(*) FROM farm UNION ALL SELECT 'field', COUNT(*) FROM field UNION ALL SELECT 'sensor', COUNT(*) FROM sensor UNION ALL SELECT 'plant', COUNT(*) FROM plant UNION ALL SELECT 'account', COUNT(*) FROM account;" 2>&1

echo.
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo ✅ HOÀN TẤT!
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.
echo 🎯 BƯỚC TIẾP THEO:
echo.
echo 1. Mở Railway Dashboard
echo    https://railway.app/dashboard
echo    → PostgreSQL → Data tab
echo    → Refresh và xem có data chưa
echo.
echo 2. Test Frontend
echo    https://hackathon-pione-dream.vercel.app/
echo    → Login
echo    → Dashboard có data!
echo.
echo 3. Nếu vẫn không có data:
echo    → Mở: CREATE_TEST_DATA_NO_IMPORT.html
echo    → Tạo data mới qua Web
echo.

pause



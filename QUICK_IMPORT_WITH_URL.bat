@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion

echo.
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo 🚀 IMPORT DATABASE SỬ DỤNG CONNECTION STRING
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.

REM Find PostgreSQL
set "PGBIN="
set "VERSIONS=17 16 15 14 13"

for %%V in (%VERSIONS%) do (
    if exist "C:\Program Files\PostgreSQL\%%V\bin\pg_dump.exe" (
        set "PGBIN=C:\Program Files\PostgreSQL\%%V\bin"
        echo ✅ Tìm thấy PostgreSQL %%V
        goto :FOUND
    )
)

echo ❌ KHÔNG TÌM THẤY POSTGRESQL!
echo.
echo Vui lòng cài đặt PostgreSQL hoặc thêm vào PATH
pause
exit /b 1

:FOUND
echo.
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo 📤 BƯỚC 1: EXPORT LOCAL DATABASE
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.

set "DUMP_FILE=%~dp0railway_import.sql"

echo Đang export database "SmartFarm1" từ localhost...
echo.

"%PGBIN%\pg_dump.exe" -h localhost -p 5432 -U postgres -d SmartFarm1 --data-only --inserts --disable-triggers -f "%DUMP_FILE%" 2>nul

if errorlevel 1 (
    echo ❌ Export thất bại!
    echo.
    echo Vui lòng kiểm tra:
    echo - PostgreSQL đang chạy
    echo - Database "SmartFarm1" tồn tại
    echo - User "postgres" có quyền truy cập
    pause
    exit /b 1
)

if not exist "%DUMP_FILE%" (
    echo ❌ File export không được tạo!
    pause
    exit /b 1
)

echo ✅ Export thành công!
echo    File: %DUMP_FILE%
echo.

echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo 📥 BƯỚC 2: IMPORT VÀO RAILWAY
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.
echo Vào Railway Dashboard ^> PostgreSQL ^> Connect
echo Copy "Postgres Connection URL"
echo.
echo VÍ DỤ:
echo postgresql://postgres:PASSWORD@viaduct.proxy.rlwy.net:12345/railway
echo.
set /p "RAILWAY_URL=Paste CONNECTION STRING vào đây: "

if "!RAILWAY_URL!"=="" (
    echo ❌ Bạn chưa nhập CONNECTION STRING!
    pause
    exit /b 1
)

echo.
echo 📋 CONNECTION STRING:
echo !RAILWAY_URL!
echo.
set /p "CONFIRM=Bạn có chắc muốn import? (Y/N): "

if /i not "!CONFIRM!"=="Y" (
    echo ❌ Đã hủy!
    pause
    exit /b 0
)

echo.
echo Đang import vào Railway...
echo.

"%PGBIN%\psql.exe" "!RAILWAY_URL!" -f "%DUMP_FILE%" 2>nul

if errorlevel 1 (
    echo.
    echo ⚠️  Có thể có lỗi nhưng data có thể đã import một phần.
    echo.
    echo Thử thêm sslmode=require:
    echo.
    "%PGBIN%\psql.exe" "!RAILWAY_URL!?sslmode=require" -f "%DUMP_FILE%"
    
    if errorlevel 1 (
        echo.
        echo ❌ Import thất bại!
        echo.
        echo VUI LÒNG KIỂM TRA:
        echo 1. CONNECTION STRING đúng chưa?
        echo 2. Railway PostgreSQL có bật TCP Proxy chưa?
        echo 3. Thử trong Railway Dashboard:
        echo    Settings ^> Networking ^> Generate Domain
        pause
        exit /b 1
    )
)

echo.
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo ✅ IMPORT HOÀN TẤT!
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.
echo 🎯 TEST NGAY:
echo    https://hackathon-pione-dream.vercel.app/
echo.
echo 📊 Kiểm tra data trong Railway:
echo    Railway Dashboard ^> PostgreSQL ^> Data tab
echo.

pause



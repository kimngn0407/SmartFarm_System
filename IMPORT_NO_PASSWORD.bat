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
set "VERSIONS=17 16 15 14 13"

for %%V in (%VERSIONS%) do (
    if exist "C:\Program Files\PostgreSQL\%%V\bin\pg_dump.exe" (
        set "PGBIN=C:\Program Files\PostgreSQL\%%V\bin"
        echo ✅ Tìm thấy PostgreSQL %%V
        goto :FOUND
    )
)

echo ❌ KHÔNG TÌM THẤY POSTGRESQL!
pause
exit /b 1

:FOUND
echo.
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo 📤 BƯỚC 1: NHẬP PASSWORD LOCAL DATABASE
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.
set /p "LOCAL_PASSWORD=Nhập password của PostgreSQL LOCAL (localhost): "

if "!LOCAL_PASSWORD!"=="" (
    echo ❌ Bạn chưa nhập password!
    pause
    exit /b 1
)

echo.
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo 📤 BƯỚC 2: EXPORT LOCAL DATABASE
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.

set "DUMP_FILE=%~dp0railway_import.sql"
set "PGPASSWORD=!LOCAL_PASSWORD!"

echo Đang export database "SmartFarm1" từ localhost...
echo.

"%PGBIN%\pg_dump.exe" -h localhost -p 5432 -U postgres -d SmartFarm1 --data-only --inserts --disable-triggers -f "%DUMP_FILE%"

if errorlevel 1 (
    echo ❌ Export thất bại!
    echo.
    echo Kiểm tra lại:
    echo - Password đúng chưa?
    echo - Database "SmartFarm1" tồn tại chưa?
    echo - PostgreSQL đang chạy chưa?
    pause
    exit /b 1
)

if not exist "%DUMP_FILE%" (
    echo ❌ File export không được tạo!
    pause
    exit /b 1
)

echo ✅ Export thành công!
echo.

REM Check file size
for %%A in ("%DUMP_FILE%") do set "FILESIZE=%%~zA"
echo 📊 Kích thước file: !FILESIZE! bytes
echo.

if !FILESIZE! LSS 100 (
    echo ⚠️  File quá nhỏ, có thể không có data!
    set /p "CONTINUE=Bạn có muốn tiếp tục? (Y/N): "
    if /i not "!CONTINUE!"=="Y" (
        pause
        exit /b 0
    )
)

echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo 📥 BƯỚC 3: IMPORT VÀO RAILWAY
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.
echo 🔗 RAILWAY CONNECTION STRING:
echo.
echo postgresql://postgres:aWdOoPVQUzkzUjLxjSREwszhXUJrZXJn@shinkansen.proxy.rlwy.net:23985/railway
echo.
echo.

set "RAILWAY_URL=postgresql://postgres:aWdOoPVQUzkzUjLxjSREwszhXUJrZXJn@shinkansen.proxy.rlwy.net:23985/railway"

echo 📋 Sử dụng connection trên để import
echo.
set /p "CONFIRM=Bạn có chắc muốn import vào Railway? (Y/N): "

if /i not "!CONFIRM!"=="Y" (
    echo ❌ Đã hủy!
    pause
    exit /b 0
)

echo.
echo Đang import vào Railway...
echo (Có thể mất vài phút...)
echo.

"%PGBIN%\psql.exe" "!RAILWAY_URL!" -f "%DUMP_FILE%"

if errorlevel 1 (
    echo.
    echo ⚠️  Có lỗi, thử lại với SSL mode...
    echo.
    "%PGBIN%\psql.exe" "!RAILWAY_URL!?sslmode=require" -f "%DUMP_FILE%"
)

echo.
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo ✅ HOÀN TẤT!
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.
echo 🎯 TEST NGAY:
echo    https://hackathon-pione-dream.vercel.app/
echo.
echo 📊 Kiểm tra data trong Railway:
echo    https://railway.app/dashboard
echo    → PostgreSQL → Data tab
echo.

pause



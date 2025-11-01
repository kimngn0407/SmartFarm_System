@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion

echo.
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo 🔍 KIỂM TRA DATABASE LOCAL
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
echo 📊 KIỂM TRA DATABASE "SmartFarm1"
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.

set /p "LOCAL_PASSWORD=Nhập password PostgreSQL LOCAL: "

echo.
echo Đang kiểm tra database SmartFarm1...
echo.

set "PGPASSWORD=!LOCAL_PASSWORD!"

REM Check if database exists
"%PGBIN%\psql.exe" -h localhost -p 5432 -U postgres -d SmartFarm1 -c "SELECT 1" >nul 2>&1

if errorlevel 1 (
    echo ❌ Database "SmartFarm1" KHÔNG TỒN TẠI hoặc password SAI!
    echo.
    echo Các database có sẵn:
    "%PGBIN%\psql.exe" -h localhost -p 5432 -U postgres -l
    echo.
    echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    echo ⚠️  VUI LÒNG:
    echo    1. Kiểm tra tên database đúng chưa?
    echo    2. Hoặc dùng CÁCH 2: Tạo data mới qua Web
    echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    pause
    exit /b 1
)

echo ✅ Kết nối thành công!
echo.

REM Count data
echo 📊 Đếm số lượng data:
echo.

for %%T in (farm field sensor plant account) do (
    echo Đang kiểm tra table: %%T
    "%PGBIN%\psql.exe" -h localhost -p 5432 -U postgres -d SmartFarm1 -t -c "SELECT COUNT(*) FROM %%T" 2>nul
    if errorlevel 1 (
        echo    ⚠️  Table %%T không tồn tại
    )
)

echo.
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo ✅ KIỂM TRA XONG!
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.
echo NẾU TẤT CẢ = 0:
echo    → Dùng CÁCH 2: Tạo data mới qua Web
echo    → Mở file: CREATE_TEST_DATA_NO_IMPORT.html
echo.
echo NẾU CÓ DATA (^> 0):
echo    → Tiếp tục với IMPORT_TO_RAILWAY_FINAL.bat
echo.
pause



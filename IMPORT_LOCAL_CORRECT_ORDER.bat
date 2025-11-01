@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion

echo.
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo 🚀 IMPORT DATA TỪ LOCAL - ĐÚNG THỨ TỰ
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
echo 📤 BƯỚC 1: EXPORT TỪ LOCAL (TỪNG TABLE)
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.

set /p "LOCAL_PASSWORD=Nhập password PostgreSQL LOCAL (Ngan0407@!): "
if "!LOCAL_PASSWORD!"=="" set "LOCAL_PASSWORD=Ngan0407@!"

set "PGPASSWORD=!LOCAL_PASSWORD!"

echo.
echo Đang export từng table...
echo.

REM Export theo thứ tự: account → farm → field → sensor → plant
for %%T in (account farm field sensor plant crop_season crop_growth_stage) do (
    echo [%%T] Đang export...
    "%PGBIN%\pg_dump.exe" -h localhost -p 5432 -U postgres -d SmartFarm1 --table=%%T --data-only --column-inserts --inserts -f "%~dp0%%T.sql" 2>nul
    
    if errorlevel 1 (
        echo    ⚠️  Lỗi export %%T
    ) else (
        for %%A in ("%~dp0%%T.sql") do set "SIZE=%%~zA"
        echo    ✅ Export %%T - !SIZE! bytes
    )
)

echo.
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo 📥 BƯỚC 2: XÓA DATA CŨ TRÊN RAILWAY (NẾU CÓ)
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.

set "RAILWAY_URL=postgresql://postgres:aWdOoPVQUzkzUjLxjSREwszhXUJrZXJn@shinkansen.proxy.rlwy.net:23985/railway"

echo ⚠️  Xóa data cũ để import data mới từ local...
echo.

set /p "CONFIRM_DELETE=Bạn có muốn XÓA HẾT data trên Railway và import lại? (Y/N): "
if /i not "!CONFIRM_DELETE!"=="Y" (
    echo Đã hủy!
    pause
    exit /b 0
)

echo.
echo Đang xóa data cũ...
echo.

set "PGPASSWORD="

REM Delete in reverse order (foreign key constraints)
echo [sensor] Đang xóa...
"%PGBIN%\psql.exe" "!RAILWAY_URL!?sslmode=require" -c "DELETE FROM sensor;" 2>nul
echo    ✅ Đã xóa sensor

echo [field] Đang xóa...
"%PGBIN%\psql.exe" "!RAILWAY_URL!?sslmode=require" -c "DELETE FROM field;" 2>nul
echo    ✅ Đã xóa field

echo [farm] Đang xóa...
"%PGBIN%\psql.exe" "!RAILWAY_URL!?sslmode=require" -c "DELETE FROM farm;" 2>nul
echo    ✅ Đã xóa farm

echo [plant] Đang xóa...
"%PGBIN%\psql.exe" "!RAILWAY_URL!?sslmode=require" -c "DELETE FROM plant;" 2>nul
echo    ✅ Đã xóa plant

echo [crop_growth_stage] Đang xóa...
"%PGBIN%\psql.exe" "!RAILWAY_URL!?sslmode=require" -c "DELETE FROM crop_growth_stage;" 2>nul
echo    ✅ Đã xóa crop_growth_stage

echo [crop_season] Đang xóa...
"%PGBIN%\psql.exe" "!RAILWAY_URL!?sslmode=require" -c "DELETE FROM crop_season;" 2>nul
echo    ✅ Đã xóa crop_season

echo [account_roles] Đang xóa...
"%PGBIN%\psql.exe" "!RAILWAY_URL!?sslmode=require" -c "DELETE FROM account_roles;" 2>nul
echo    ✅ Đã xóa account_roles

echo.
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo 📥 BƯỚC 3: IMPORT VÀO RAILWAY (ĐÚNG THỨ TỰ)
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.

echo Đang import từng table theo thứ tự...
echo.

REM Import theo thứ tự: account → farm → field → sensor → plant
if exist "%~dp0account.sql" (
    echo [account] Đang import...
    "%PGBIN%\psql.exe" "!RAILWAY_URL!?sslmode=require" -f "%~dp0account.sql" 2>nul
    echo    ✅ Import account thành công
)

if exist "%~dp0farm.sql" (
    echo [farm] Đang import...
    "%PGBIN%\psql.exe" "!RAILWAY_URL!?sslmode=require" -f "%~dp0farm.sql" 2>nul
    echo    ✅ Import farm thành công
)

if exist "%~dp0field.sql" (
    echo [field] Đang import...
    "%PGBIN%\psql.exe" "!RAILWAY_URL!?sslmode=require" -f "%~dp0field.sql" 2>nul
    echo    ✅ Import field thành công
)

if exist "%~dp0sensor.sql" (
    echo [sensor] Đang import...
    "%PGBIN%\psql.exe" "!RAILWAY_URL!?sslmode=require" -f "%~dp0sensor.sql" 2>nul
    echo    ✅ Import sensor thành công
)

if exist "%~dp0plant.sql" (
    echo [plant] Đang import...
    "%PGBIN%\psql.exe" "!RAILWAY_URL!?sslmode=require" -f "%~dp0plant.sql" 2>nul
    echo    ✅ Import plant thành công
)

if exist "%~dp0crop_season.sql" (
    echo [crop_season] Đang import...
    "%PGBIN%\psql.exe" "!RAILWAY_URL!?sslmode=require" -f "%~dp0crop_season.sql" 2>nul
    echo    ✅ Import crop_season thành công
)

if exist "%~dp0crop_growth_stage.sql" (
    echo [crop_growth_stage] Đang import...
    "%PGBIN%\psql.exe" "!RAILWAY_URL!?sslmode=require" -f "%~dp0crop_growth_stage.sql" 2>nul
    echo    ✅ Import crop_growth_stage thành công
)

echo.
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo 📊 BƯỚC 4: KIỂM TRA KẾT QUẢ
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.

echo Đếm số lượng data trên Railway...
echo.

"%PGBIN%\psql.exe" "!RAILWAY_URL!?sslmode=require" -c "SELECT 'account' as table_name, COUNT(*) as count FROM account UNION ALL SELECT 'farm', COUNT(*) FROM farm UNION ALL SELECT 'field', COUNT(*) FROM field UNION ALL SELECT 'sensor', COUNT(*) FROM sensor UNION ALL SELECT 'plant', COUNT(*) FROM plant;" 2>&1

echo.
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo ✅ HOÀN TẤT!
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.
echo 🎯 BƯỚC TIẾP THEO:
echo.
echo 1. Kiểm tra Railway Dashboard
echo    https://railway.app/dashboard → PostgreSQL → Data
echo.
echo 2. Test Frontend
echo    https://hackathon-pione-dream.vercel.app/
echo    Login với account từ local của bạn!
echo.
echo 3. Dashboard sẽ hiển thị:
echo    ✅ Farms từ local
echo    ✅ Fields từ local
echo    ✅ Sensors từ local
echo    ✅ Plants từ local
echo.

REM Cleanup temp files
echo Đang dọn dẹp file tạm...
if exist "%~dp0account.sql" del "%~dp0account.sql"
if exist "%~dp0farm.sql" del "%~dp0farm.sql"
if exist "%~dp0field.sql" del "%~dp0field.sql"
if exist "%~dp0sensor.sql" del "%~dp0sensor.sql"
if exist "%~dp0plant.sql" del "%~dp0plant.sql"
if exist "%~dp0crop_season.sql" del "%~dp0crop_season.sql"
if exist "%~dp0crop_growth_stage.sql" del "%~dp0crop_growth_stage.sql"
echo ✅ Đã xóa file tạm

pause


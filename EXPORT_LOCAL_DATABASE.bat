@echo off
chcp 65001 >nul
echo.
echo ╔════════════════════════════════════════════════════════════╗
echo ║        EXPORT LOCAL DATABASE TO PRODUCTION                 ║
echo ╚════════════════════════════════════════════════════════════╝
echo.

REM Find PostgreSQL installation
echo 🔍 Tìm PostgreSQL installation...
echo.

set "PG_PATH="

REM Check common PostgreSQL installation paths
if exist "C:\Program Files\PostgreSQL\16\bin\pg_dump.exe" set "PG_PATH=C:\Program Files\PostgreSQL\16\bin"
if exist "C:\Program Files\PostgreSQL\15\bin\pg_dump.exe" set "PG_PATH=C:\Program Files\PostgreSQL\15\bin"
if exist "C:\Program Files\PostgreSQL\14\bin\pg_dump.exe" set "PG_PATH=C:\Program Files\PostgreSQL\14\bin"
if exist "C:\Program Files\PostgreSQL\13\bin\pg_dump.exe" set "PG_PATH=C:\Program Files\PostgreSQL\13\bin"
if exist "C:\Program Files\PostgreSQL\12\bin\pg_dump.exe" set "PG_PATH=C:\Program Files\PostgreSQL\12\bin"

if "%PG_PATH%"=="" (
    echo ❌ Không tìm thấy PostgreSQL!
    echo.
    echo Vui lòng nhập đường dẫn thủ công:
    echo Ví dụ: C:\Program Files\PostgreSQL\16\bin
    echo.
    set /p PG_PATH="Nhập đường dẫn PostgreSQL bin: "
)

if not exist "%PG_PATH%\pg_dump.exe" (
    echo ❌ pg_dump.exe không tồn tại trong: %PG_PATH%
    echo.
    pause
    exit /b 1
)

echo ✅ Tìm thấy PostgreSQL tại: %PG_PATH%
echo.

REM Set local database info
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo 📋 THÔNG TIN LOCAL DATABASE
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.

set "LOCAL_HOST=localhost"
set "LOCAL_PORT=5432"
set "LOCAL_DB=SmartFarm1"
set "LOCAL_USER=postgres"
set "LOCAL_PASSWORD=Ngan0407@!"

echo Host:     %LOCAL_HOST%
echo Port:     %LOCAL_PORT%
echo Database: %LOCAL_DB%
echo Username: %LOCAL_USER%
echo.

set /p CONFIRM="Thông tin này đúng không? (Y/N): "
if /i not "%CONFIRM%"=="Y" (
    echo.
    set /p LOCAL_HOST="Host (default: localhost): "
    set /p LOCAL_PORT="Port (default: 5432): "
    set /p LOCAL_DB="Database name: "
    set /p LOCAL_USER="Username: "
    set /p LOCAL_PASSWORD="Password: "
)

echo.
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo 📊 BƯỚC 1: KIỂM TRA KẾT NỐI LOCAL DATABASE
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.

set "PGPASSWORD=%LOCAL_PASSWORD%"

"%PG_PATH%\psql.exe" -h %LOCAL_HOST% -p %LOCAL_PORT% -U %LOCAL_USER% -d %LOCAL_DB% -c "SELECT version();"

if errorlevel 1 (
    echo.
    echo ❌ Không thể kết nối local database!
    echo Kiểm tra lại thông tin database.
    echo.
    pause
    exit /b 1
)

echo.
echo ✅ Kết nối local database thành công!
echo.

echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo 📊 Current local database data:
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.

"%PG_PATH%\psql.exe" -h %LOCAL_HOST% -p %LOCAL_PORT% -U %LOCAL_USER% -d %LOCAL_DB% -c "SELECT 'Accounts:' as table_name, COUNT(*) as count FROM accounts UNION ALL SELECT 'Farms:', COUNT(*) FROM farms UNION ALL SELECT 'Fields:', COUNT(*) FROM fields UNION ALL SELECT 'Sensors:', COUNT(*) FROM sensors UNION ALL SELECT 'Plants:', COUNT(*) FROM plants;"

echo.
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo 📤 BƯỚC 2: EXPORT DATA
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.
echo Đang export data (chỉ data, không schema)...
echo.

"%PG_PATH%\pg_dump.exe" -h %LOCAL_HOST% -p %LOCAL_PORT% -U %LOCAL_USER% -d %LOCAL_DB% --data-only --inserts --column-inserts -f local_database_export.sql

if errorlevel 1 (
    echo ❌ Export thất bại!
    pause
    exit /b 1
)

echo.
echo ✅ Export thành công!
echo 📁 File: local_database_export.sql
echo.

REM Show file size
for %%I in (local_database_export.sql) do echo File size: %%~zI bytes
echo.

echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo 📥 BƯỚC 3: CHUẨN BỊ IMPORT VÀO RAILWAY
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.
echo Lấy thông tin Railway database credentials:
echo.
echo 1. Vào: https://railway.app/dashboard
echo 2. Click project: hackathonpionedream-production
echo 3. Click service: PostgreSQL
echo 4. Tab "Connect" → Copy credentials
echo.

set /p RAILWAY_HOST="PGHOST (xxx.railway.app): "
set /p RAILWAY_PORT="PGPORT (default 5432): "
set /p RAILWAY_DB="PGDATABASE (default railway): "
set /p RAILWAY_USER="PGUSER (default postgres): "
set /p RAILWAY_PASSWORD="PGPASSWORD: "

echo.
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo 🔍 BƯỚC 4: KIỂM TRA KẾT NỐI RAILWAY DATABASE
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.

set "PGPASSWORD=%RAILWAY_PASSWORD%"

"%PG_PATH%\psql.exe" -h %RAILWAY_HOST% -p %RAILWAY_PORT% -U %RAILWAY_USER% -d %RAILWAY_DB% -c "SELECT version();"

if errorlevel 1 (
    echo.
    echo ❌ Không thể kết nối Railway database!
    echo Kiểm tra lại credentials.
    echo.
    pause
    exit /b 1
)

echo.
echo ✅ Kết nối Railway database thành công!
echo.

echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo 📊 Current Railway database data:
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.

"%PG_PATH%\psql.exe" -h %RAILWAY_HOST% -p %RAILWAY_PORT% -U %RAILWAY_USER% -d %RAILWAY_DB% -c "SELECT 'Accounts:' as table_name, COUNT(*) as count FROM accounts UNION ALL SELECT 'Farms:', COUNT(*) FROM farms UNION ALL SELECT 'Fields:', COUNT(*) FROM fields UNION ALL SELECT 'Sensors:', COUNT(*) FROM sensors;"

echo.
echo ⚠️  WARNING: Import sẽ thêm data vào Railway database.
echo    Nếu có data trùng ID, có thể bị lỗi.
echo.

set /p PROCEED="Tiếp tục import? (Y/N): "
if /i not "%PROCEED%"=="Y" (
    echo.
    echo ❌ Hủy import.
    pause
    exit /b 0
)

echo.
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo 📥 BƯỚC 5: IMPORT DATA VÀO RAILWAY
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.
echo Đang import data vào Railway...
echo (Có thể mất vài phút nếu data lớn)
echo.

"%PG_PATH%\psql.exe" -h %RAILWAY_HOST% -p %RAILWAY_PORT% -U %RAILWAY_USER% -d %RAILWAY_DB% -f local_database_export.sql

echo.
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo 📊 Updated Railway database data:
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.

"%PG_PATH%\psql.exe" -h %RAILWAY_HOST% -p %RAILWAY_PORT% -U %RAILWAY_USER% -d %RAILWAY_DB% -c "SELECT 'Accounts:' as table_name, COUNT(*) as count FROM accounts UNION ALL SELECT 'Farms:', COUNT(*) FROM farms UNION ALL SELECT 'Fields:', COUNT(*) FROM fields UNION ALL SELECT 'Sensors:', COUNT(*) FROM sensors UNION ALL SELECT 'Plants:', COUNT(*) FROM plants UNION ALL SELECT 'Sensor Data:', COUNT(*) FROM sensor_data;"

echo.
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo ✅ HOÀN TẤT!
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.
echo 📁 Export file: local_database_export.sql
echo.
echo 🌐 Test your Frontend:
echo    https://hackathon-pione-dream.vercel.app/
echo.
echo    Bạn sẽ thấy data từ local database!
echo.
pause



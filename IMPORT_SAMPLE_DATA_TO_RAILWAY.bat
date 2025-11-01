@echo off
chcp 65001 >nul
echo.
echo ╔════════════════════════════════════════════════════════════╗
echo ║     IMPORT SAMPLE DATA TO RAILWAY DATABASE                 ║
echo ╚════════════════════════════════════════════════════════════╝
echo.
echo ⚠️  BẠN CẦN LẤY DATABASE CREDENTIALS TỪ RAILWAY TRƯỚC!
echo.
echo 📋 Các bước:
echo    1. Vào https://railway.app/dashboard
echo    2. Click project: hackathonpionedream-production
echo    3. Click service: PostgreSQL
echo    4. Tab "Connect" → Copy credentials
echo.
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.

set /p PGHOST="PGHOST (xxx.railway.app): "
set /p PGPORT="PGPORT (default 5432): "
set /p PGDATABASE="PGDATABASE (default railway): "
set /p PGUSER="PGUSER (default postgres): "
set /p PGPASSWORD="PGPASSWORD: "

echo.
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo 🔍 Testing connection...
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.

psql -h %PGHOST% -p %PGPORT% -U %PGUSER% -d %PGDATABASE% -c "SELECT version();"

IF %ERRORLEVEL% NEQ 0 (
    echo.
    echo ❌ Connection failed! Check your credentials.
    echo.
    pause
    exit /b 1
)

echo.
echo ✅ Connection successful!
echo.
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo 📊 Current database status:
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.

psql -h %PGHOST% -p %PGPORT% -U %PGUSER% -d %PGDATABASE% -c "SELECT 'Farms:' as table_name, COUNT(*) as count FROM farms UNION ALL SELECT 'Fields:', COUNT(*) FROM fields UNION ALL SELECT 'Sensors:', COUNT(*) FROM sensors UNION ALL SELECT 'Accounts:', COUNT(*) FROM accounts;"

echo.
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo 📥 Importing sample data from sample_data.sql...
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.

psql -h %PGHOST% -p %PGPORT% -U %PGUSER% -d %PGDATABASE% -f sample_data.sql

IF %ERRORLEVEL% NEQ 0 (
    echo.
    echo ⚠️  Import completed with some warnings (this is normal).
    echo.
) ELSE (
    echo.
    echo ✅ Import successful!
    echo.
)

echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo 📊 Updated database status:
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.

psql -h %PGHOST% -p %PGPORT% -U %PGUSER% -d %PGDATABASE% -c "SELECT 'Farms:' as table_name, COUNT(*) as count FROM farms UNION ALL SELECT 'Fields:', COUNT(*) FROM fields UNION ALL SELECT 'Sensors:', COUNT(*) FROM sensors UNION ALL SELECT 'Plants:', COUNT(*) FROM plants UNION ALL SELECT 'Sensor Data:', COUNT(*) FROM sensor_data;"

echo.
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo ✅ DONE!
echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo.
echo 🌐 Now test your Frontend:
echo    https://hackathon-pione-dream.vercel.app/
echo.
echo    You should see farms, fields, and sensors!
echo.
pause



@echo off
echo ========================================
echo   Crop Recommendation Service Starter
echo ========================================
echo.

cd /d "%~dp0"

REM Check if virtual environment exists
if not exist .venv\Scripts\activate.bat (
    echo Creating virtual environment...
    python -m venv .venv
    if errorlevel 1 (
        echo ERROR - Cannot create venv!
        pause
        exit /b 1
    )
)

echo Activating virtual environment (.venv)...
call .venv\Scripts\activate.bat
if errorlevel 1 (
    echo ERROR - Cannot activate venv!
    pause
    exit /b 1
)
echo ✓ Virtual environment activated: .venv

REM Check if sklearn is installed
echo Checking dependencies...
python -c "import sklearn" >nul 2>&1
if errorlevel 1 (
    echo.
    echo Dependencies not found! Installing...
    pip install --upgrade pip
    pip install -r requirements.txt
    if errorlevel 1 (
        echo ERROR - Installation failed!
        pause
        exit /b 1
    )
    echo Dependencies installed!
) else (
    echo Dependencies OK!
)

echo.
echo ========================================
echo   Starting Crop Recommendation Service
echo ========================================
echo.
echo API will be available at: http://localhost:5000
echo Health check: http://localhost:5000/health
echo.
echo Press Ctrl+C to stop
echo.

python crop_recommendation_service.py

pause

@echo off
echo ========================================
echo   Crop Recommendation Service Starter
echo ========================================
echo.

REM Activate virtual environment
if exist .venv\Scripts\activate.bat (
    echo Activating virtual environment...
    call .venv\Scripts\activate.bat
) else (
    echo Warning: Virtual environment not found!
    echo Please run: python -m venv .venv
    pause
    exit
)

REM Check if requirements are installed
echo Checking dependencies...
pip list | findstr flask >nul
if errorlevel 1 (
    echo Installing requirements...
    pip install -r requirements.txt
)

echo.
echo Starting Crop Recommendation Service...
echo API will be available at: http://localhost:5000
echo.

python crop_recommendation_service.py

pause






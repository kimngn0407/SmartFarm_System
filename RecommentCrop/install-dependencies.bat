@echo off
echo ========================================
echo   Install Python Dependencies
echo ========================================
echo.

cd /d "%~dp0"

REM Check if virtual environment exists
if not exist ".venv\" (
    echo Creating virtual environment...
    python -m venv .venv
    if errorlevel 1 (
        echo ERROR - Cannot create venv!
        pause
        exit /b 1
    )
)

echo [1/2] Activating virtual environment...
call .venv\Scripts\activate
if errorlevel 1 (
    echo ERROR - Cannot activate venv!
    pause
    exit /b 1
)
echo   OK!
echo.

echo [2/2] Installing dependencies from requirements.txt...
pip install --upgrade pip
pip install -r requirements.txt

if errorlevel 1 (
    echo.
    echo ERROR - Installation failed!
    pause
    exit /b 1
)

echo.
echo ========================================
echo   INSTALLATION COMPLETE!
echo ========================================
echo.
echo Verifying installation...
python -c "import sklearn; print('sklearn version:', sklearn.__version__)"
python -c "import flask; print('flask version:', flask.__version__)"
python -c "import numpy; print('numpy version:', numpy.__version__)"
echo.
echo You can now run: python crop_recommendation_service.py
echo.
pause



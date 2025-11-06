@echo off
echo ========================================
echo   Clean Install - Fresh Start
echo ========================================
echo.
echo WARNING: This will DELETE existing .venv!
echo Press Ctrl+C to cancel, or
pause

cd /d "%~dp0"

echo [1/3] Removing old virtual environment...
if exist ".venv\" (
    rmdir /s /q .venv
    echo   Old venv deleted!
) else (
    echo   No venv found, creating new one...
)
echo.

echo [2/3] Creating fresh virtual environment...
python -m venv .venv
if errorlevel 1 (
    echo ERROR - Cannot create venv!
    pause
    exit /b 1
)
echo.

echo [3/3] Installing dependencies...
call .venv\Scripts\activate
pip install --upgrade pip
pip install -r requirements.txt

if errorlevel 1 (
    echo ERROR - Installation failed!
    pause
    exit /b 1
)

echo.
echo ========================================
echo   VERIFYING INSTALLATION...
echo ========================================
python -c "import sklearn; print('✓ sklearn:', sklearn.__version__)"
python -c "import numpy; print('✓ numpy:', numpy.__version__)"
python -c "import flask; print('✓ flask:', flask.__version__)"
echo.

echo ========================================
echo   CHECKING FOR CONFLICTS...
echo ========================================
pip check
echo.

echo ========================================
echo   INSTALLATION COMPLETE!
echo ========================================
echo.
echo You can now run: python crop_recommendation_service.py
echo.
pause



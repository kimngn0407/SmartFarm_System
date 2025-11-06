@echo off
echo ========================================
echo   Fix Dependencies Conflicts
echo ========================================
echo.

cd /d "%~dp0"

REM Check if virtual environment exists
if not exist ".venv\" (
    echo Creating virtual environment...
    python -m venv .venv
)

echo Activating virtual environment...
call .venv\Scripts\activate
if errorlevel 1 (
    echo ERROR - Cannot activate venv!
    pause
    exit /b 1
)

echo.
echo [1/4] Removing conflicting packages...
pip uninstall -y shap tensorflow 2>nul
echo.

echo [2/4] Installing required versions...
pip install --upgrade pip
pip install numpy==1.24.3
pip install scikit-learn==1.2.2
echo.

echo [3/4] Installing other dependencies...
pip install flask==3.0.0
pip install flask-cors==4.0.0
echo.

echo [4/4] Verifying installation...
python -c "import sklearn; print('sklearn:', sklearn.__version__)"
python -c "import numpy; print('numpy:', numpy.__version__)"
python -c "import flask; print('flask:', flask.__version__)"
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



@echo off
REM Smart Farm Arduino Forwarder - Auto Start Script
REM Tự động chạy forwarder khi cắm USB Arduino

echo ============================================================
echo   Smart Farm Arduino Forwarder - Auto Start
echo ============================================================
echo.

REM Chuyển đến thư mục script
cd /d "%~dp0"

REM Kích hoạt virtual environment (nếu có)
if exist "venv\Scripts\activate.bat" (
    call venv\Scripts\activate.bat
    echo [OK] Virtual environment activated
) else (
    echo [WARN] Virtual environment not found, using system Python
)

REM Chạy forwarder với auto port detection
echo.
echo [INFO] Starting Arduino forwarder...
echo [INFO] Press Ctrl+C to stop
echo.

python forwarder_auto.py

REM Nếu script thoát, đợi để người dùng xem lỗi
if errorlevel 1 (
    echo.
    echo [ERROR] Script exited with error code %errorlevel%
    pause
)


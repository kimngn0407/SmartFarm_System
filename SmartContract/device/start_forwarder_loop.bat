@echo off
REM Smart Farm Arduino Forwarder - Auto Start với Auto-Retry
REM Tự động chạy lại khi mất kết nối

echo ============================================================
echo   Smart Farm Arduino Forwarder - Auto Start (Loop Mode)
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

REM Vòng lặp vô hạn - tự động chạy lại khi mất kết nối
:loop
echo.
echo [INFO] Starting Arduino forwarder...
echo [INFO] Press Ctrl+C to stop
echo.

python forwarder_auto.py

REM Kiểm tra exit code
if errorlevel 1 (
    echo.
    echo [WARN] Connection lost or error occurred
    echo [INFO] Waiting 5 seconds before retry...
    timeout /t 5 /nobreak >nul
    echo [INFO] Retrying...
    goto loop
) else (
    echo.
    echo [INFO] Script exited normally
    pause
)


@echo off
echo ================================================
echo   Starting Local HTTP Server for Testing
echo ================================================
echo.
echo Test URL will be available at:
echo http://localhost:8000/TEST_BACKEND_RESPONSE.html
echo.
echo Press Ctrl+C to stop the server
echo ================================================
echo.

cd /d "%~dp0"
python -m http.server 8000

pause


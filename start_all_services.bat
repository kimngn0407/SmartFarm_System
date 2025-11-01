@echo off
echo ============================================
echo   Smart Farm - Start All Services
echo ============================================
echo.

REM Start Python ML Service
echo [1/3] Starting Python ML Service...
start "Python ML Service" cmd /k "cd RecommentCrop && .venv\Scripts\activate && python crop_recommendation_service.py"

timeout /t 5 /nobreak >nul

REM Start Spring Boot Backend
echo [2/3] Starting Spring Boot Backend...
start "Spring Boot Backend" cmd /k "cd demoSmartFarm\demo && mvn spring-boot:run"

timeout /t 10 /nobreak >nul

REM Start React Frontend
echo [3/3] Starting React Frontend...
start "React Frontend" cmd /k "cd J2EE_Frontend && npm start"

echo.
echo ============================================
echo   All Services Starting...
echo ============================================
echo.
echo Python ML Service:    http://localhost:5000
echo Spring Boot Backend:  http://localhost:8080
echo React Frontend:       http://localhost:3000
echo.
echo Press any key to exit this window...
echo Note: Services are running in separate windows
pause >nul






@echo off
echo Testing Backend Health...
echo.
powershell -Command "(Invoke-WebRequest -Uri 'https://hackathonpionedream-production.up.railway.app/actuator/health' -UseBasicParsing).Content"
echo.
echo.
echo Testing Auth Endpoint...
echo.
powershell -Command "$body = @{email='test@test.com';password='test'} | ConvertTo-Json; try { (Invoke-WebRequest -Uri 'https://hackathonpionedream-production.up.railway.app/api/auth/register' -Method POST -Body $body -ContentType 'application/json' -UseBasicParsing).Content } catch { $_.Exception.Message }"
pause



@echo off
REM Script rebuild Python virtual environments trên Windows
REM Sử dụng: rebuild_venv.bat

echo ========================================
echo Rebuild Python Virtual Environments
echo ========================================
echo.

REM Flask API service
if exist "SmartContract\flask-api" (
    echo [1/4] Rebuilding flask-api .venv...
    cd SmartContract\flask-api
    if exist .venv (
        rmdir /s /q .venv
    )
    python -m venv .venv
    call .venv\Scripts\activate.bat
    python -m pip install --upgrade pip
    if exist requirements.txt (
        pip install -r requirements.txt
    ) else (
        pip install Flask==3.0.2 SQLAlchemy==2.0.30 psycopg2-binary==2.9.9 eth-utils==2.3.1 "eth-hash[pycryptodome]" python-dotenv==1.0.1 requests==2.32.3
    )
    deactivate
    cd ..\..
    echo [OK] flask-api .venv rebuilt
    echo.
) else (
    echo [SKIP] SmartContract\flask-api not found
    echo.
)

REM Device forwarder service
if exist "SmartContract\device" (
    echo [2/4] Rebuilding device venv...
    cd SmartContract\device
    if exist venv (
        rmdir /s /q venv
    )
    python -m venv venv
    call venv\Scripts\activate.bat
    python -m pip install --upgrade pip
    pip install pyserial requests
    deactivate
    cd ..\..
    echo [OK] device venv rebuilt
    echo.
) else (
    echo [SKIP] SmartContract\device not found
    echo.
)

REM Crop Recommendation service
if exist "RecommentCrop" (
    echo [3/4] Rebuilding RecommentCrop .venv...
    cd RecommentCrop
    if exist .venv (
        rmdir /s /q .venv
    )
    python -m venv .venv
    call .venv\Scripts\activate.bat
    python -m pip install --upgrade pip
    if exist requirements.txt (
        pip install -r requirements.txt
    )
    deactivate
    cd ..
    echo [OK] RecommentCrop .venv rebuilt
    echo.
) else (
    echo [SKIP] RecommentCrop not found
    echo.
)

REM Pest and Disease service
if exist "PestAndDisease" (
    echo [4/4] Rebuilding PestAndDisease .venv...
    cd PestAndDisease
    if exist .venv (
        rmdir /s /q .venv
    )
    python -m venv .venv
    call .venv\Scripts\activate.bat
    python -m pip install --upgrade pip
    if exist requirements.txt (
        pip install -r requirements.txt
    )
    deactivate
    cd ..
    echo [OK] PestAndDisease .venv rebuilt
    echo.
) else (
    echo [SKIP] PestAndDisease not found
    echo.
)

echo ========================================
echo Rebuild completed!
echo ========================================
pause


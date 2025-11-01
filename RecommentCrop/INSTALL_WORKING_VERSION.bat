@echo off
echo ============================================
echo   Quick Install - Working Version
echo ============================================
cd /d E:\DoAnJ2EE\RecommentCrop
call .venv\Scripts\activate.bat

echo Installing scikit-learn 1.2.2 (works with Python 3.11)...
pip install -q scikit-learn==1.2.2

echo.
echo Testing...
python try_load_anyway.py
pause






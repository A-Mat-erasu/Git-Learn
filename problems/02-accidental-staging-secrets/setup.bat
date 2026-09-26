@echo off
setlocal enabledelayedexpansion

title Setup Problem 02: Staging Secrets

echo =====================================================================
echo       Setting up Problem 02: Accidental Staging of Secrets ^& Bloat
echo =====================================================================
echo.

cd /d "%~dp0"

if exist workspace (
    echo [*] Cleaning existing workspace folder...
    rmdir /s /q workspace
)

mkdir workspace
cd workspace

echo [*] Initializing challenge repository...
git init -b main >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    git init >nul 2>&1
    git branch -M main >nul 2>&1
)

git config user.name "Student Developer"
git config user.email "student@college.edu"

:: Base commit
echo # AI Lab Project > README.md
git add README.md
git commit -m "chore: initialize project" >nul

:: Create predict.py
(
echo import math
echo def predict(x^):
echo     return 2.5 * x + 1.2
echo if __name__ == '__main__':
echo     print(f"Prediction: {predict(4^)}"^)
) > predict.py

:: Create simulated confidential secret file
(
echo # CONFIDENTIAL API TOKENS - NEVER COMMIT
echo OPENAI_API_KEY=sk-proj-99887766554433221100aabbccddeeff
echo DATABASE_PASSWORD=super_secret_lab_password_2026
) > secret_api_key.env

:: Create simulated large dataset file
(
echo id,feature_1,feature_2,label
echo 1,0.45,1.23,0
echo 2,0.89,0.12,1
echo 3,0.12,0.98,0
) > raw_dataset.csv

:: Mistakenly stage all 3 files
git add .

echo.
echo =====================================================================
echo [SUCCESS] Problem 02 scenario generated in: workspace/
echo.
echo Next steps:
echo   1. cd workspace
echo   2. Read the instructions in ..\README.md
echo   3. Run 'git status' to observe the staged files
echo   4. Fix the issue using Git commands!
echo   5. Run '..\verify.bat' to verify your solution
echo =====================================================================
echo.
pause

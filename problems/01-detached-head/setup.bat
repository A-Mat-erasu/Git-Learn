@echo off
setlocal enabledelayedexpansion

title Setup Problem 01: Detached HEAD

echo =====================================================================
echo          Setting up Problem 01: The Detached Time Traveler
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

:: Configure local user identity for problem sandbox
git config user.name "Student Developer"
git config user.email "student@college.edu"

:: Commit 1
echo def add(a, b):> calculator.py
echo     return a + b>> calculator.py
git add calculator.py
git commit -m "feat: add addition function" >nul

:: Commit 2
echo.>> calculator.py
echo def multiply(a, b):>> calculator.py
echo     return a * b>> calculator.py
git add calculator.py
git commit -m "feat: add multiplication function" >nul

:: Commit 3
echo Simple Calculator CLI Application> usage.txt
echo Usage: run calculator.py in python>> usage.txt
git add usage.txt
git commit -m "docs: add usage guide" >nul

:: Detach HEAD by checking out commit 2
for /f "tokens=*" %%i in ('git rev-parse HEAD~1') do set TARGET_HASH=%%i
git checkout %TARGET_HASH% >nul 2>&1

echo.
echo =====================================================================
echo [SUCCESS] Problem 01 scenario generated in: workspace/
echo.
echo Next steps:
echo   1. cd workspace
echo   2. Read the instructions in ..\README.md
echo   3. Run 'git status' to observe the symptoms
echo   4. Fix the issue using Git commands!
echo   5. Run '..\verify.bat' to verify your solution
echo =====================================================================
echo.
pause

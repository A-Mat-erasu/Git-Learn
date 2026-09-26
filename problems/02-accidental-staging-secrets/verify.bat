@echo off
setlocal

title Verify Problem 02

echo =====================================================================
echo       Verifying Problem 02: Accidental Staging of Secrets ^& Bloat
echo =====================================================================
echo.

set "TARGET_DIR=%~dp0workspace"

if not exist "%TARGET_DIR%\.git" (
    echo [ERROR] No workspace found at: %TARGET_DIR%
    echo Please run setup.bat first.
    pause
    exit /b 1
)

cd /d "%TARGET_DIR%"

:: 1. Verify local files still exist on disk
if not exist "secret_api_key.env" (
    echo [X] FAILED: 'secret_api_key.env' was deleted from disk.
    echo     Requirement: The file must be un-staged from Git, but preserved locally.
    echo.
    pause
    exit /b 1
)

if not exist "raw_dataset.csv" (
    echo [X] FAILED: 'raw_dataset.csv' was deleted from disk.
    echo     Requirement: The file must be un-staged from Git, but preserved locally.
    echo.
    pause
    exit /b 1
)

if not exist "predict.py" (
    echo [X] FAILED: 'predict.py' is missing from the workspace.
    echo.
    pause
    exit /b 1
)

:: 2. Check staged files in index
set "PREDICT_STAGED=0"
set "SECRET_STAGED=0"
set "CSV_STAGED=0"

for /f "tokens=*" %%f in ('git diff --cached --name-only') do (
    if "%%f"=="predict.py" set "PREDICT_STAGED=1"
    if "%%f"=="secret_api_key.env" set "SECRET_STAGED=1"
    if "%%f"=="raw_dataset.csv" set "CSV_STAGED=1"
)

if "%SECRET_STAGED%"=="1" (
    echo [X] FAILED: 'secret_api_key.env' is still staged for commit.
    echo     Hint: Remove it from the staging area without deleting the physical file.
    echo.
    pause
    exit /b 1
)

if "%CSV_STAGED%"=="1" (
    echo [X] FAILED: 'raw_dataset.csv' is still staged for commit.
    echo     Hint: Remove it from the staging area without deleting the physical file.
    echo.
    pause
    exit /b 1
)

if "%PREDICT_STAGED%"=="0" (
    echo [X] FAILED: predict.py is NOT staged for commit.
    echo     Requirement: Legitimate code predict.py must remain staged and ready to commit.
    echo.
    pause
    exit /b 1
)

:: 3. Check if files are properly ignored by Git
git check-ignore secret_api_key.env >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [X] FAILED: 'secret_api_key.env' is not ignored by Git.
    echo     Requirement: Configure repository ignore rules so .env files are permanently ignored.
    echo.
    pause
    exit /b 1
)

git check-ignore raw_dataset.csv >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [X] FAILED: 'raw_dataset.csv' is not ignored by Git.
    echo     Requirement: Configure repository ignore rules so .csv files are permanently ignored.
    echo.
    pause
    exit /b 1
)

echo [OK] Code Staged        : predict.py is staged and ready for commit
echo [OK] Secrets Unstaged   : secret_api_key.env is safely removed from index
echo [OK] Dataset Unstaged   : raw_dataset.csv is safely removed from index
echo [OK] Local Disk Files   : Preserved on disk for local execution
echo [OK] Ignore Rules       : Configured and active (check-ignore verified)
echo.
echo =====================================================================
echo [SUCCESS] CONGRATULATIONS! Problem 02 is successfully solved!
echo =====================================================================
echo.
pause

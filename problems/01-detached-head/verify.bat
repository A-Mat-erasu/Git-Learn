@echo off
setlocal enabledelayedexpansion

title Verify Problem 01

echo =====================================================================
echo         Verifying Problem 01: The Detached Time Traveler
echo =====================================================================
echo.

set "TARGET_DIR=%~dp0workspace"

if not exist "%TARGET_DIR%\.git" (
    echo [ERROR] No workspace found at: %TARGET_DIR%
    echo Please run setup.bat first!
    pause
    exit /b 1
)

cd /d "%TARGET_DIR%"

:: 1. Check if HEAD is attached to a branch
for /f "tokens=*" %%i in ('git branch --show-current 2^>nul') do set CURRENT_BRANCH=%%i

if "%CURRENT_BRANCH%"=="" (
    echo [X] FAILED: You are still in a 'Detached HEAD' state.
    echo     Hint: Your HEAD reference is pointing to a commit hash instead of a branch.
    echo.
    pause
    exit /b 1
)

:: 2. Check if current branch is main
if /i not "%CURRENT_BRANCH%"=="main" (
    echo [X] FAILED: You are on branch '%CURRENT_BRANCH%', but your target is 'main'.
    echo.
    pause
    exit /b 1
)

:: 3. Check for clean working tree
for /f "tokens=*" %%i in ('git status --porcelain 2^>nul') do (
    echo [X] FAILED: Working tree is not clean. There are uncommitted changes or untracked files.
    echo.
    pause
    exit /b 1
)

:: 4. Check if all files from latest commit are restored
if not exist "usage.txt" (
    echo [X] FAILED: 'usage.txt' is missing. You may not be at the tip of the 'main' branch.
    echo.
    pause
    exit /b 1
)

:: 5. Check commit count
for /f %%c in ('git rev-list --count HEAD 2^>nul') do set COMMIT_COUNT=%%c
if %COMMIT_COUNT% LSS 3 (
    echo [X] FAILED: Found %COMMIT_COUNT% commits, expected at least 3. History might have been lost.
    echo.
    pause
    exit /b 1
)

echo [OK] Active Branch      : main
echo [OK] Working Tree Status: Clean
echo [OK] Commit History     : 3/3 Commits Verified
echo [OK] Project Files      : Complete and Up to Date
echo.
echo =====================================================================
echo [SUCCESS] CONGRATULATIONS! Problem 01 is successfully solved!
echo =====================================================================
echo.
pause

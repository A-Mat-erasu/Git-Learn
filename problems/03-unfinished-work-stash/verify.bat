@echo off
setlocal

title Verify Problem 03

echo =====================================================================
echo          Verifying Problem 03: The Interrupted Feature
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

:: 1. Check current branch
for /f "tokens=*" %%b in ('git branch --show-current 2^>nul') do set CURRENT_BRANCH=%%b

if "%CURRENT_BRANCH%"=="main" (
    echo [X] FAILED: You are currently on branch 'main'.
    echo     Requirement: After visiting main, you must return to 'feature/capitalize'.
    echo.
    pause
    exit /b 1
)

if /i not "%CURRENT_BRANCH%"=="feature/capitalize" (
    echo [X] FAILED: You are on branch '%CURRENT_BRANCH%', expected 'feature/capitalize'.
    echo.
    pause
    exit /b 1
)

:: 2. Check that hotfix from main is present in feature branch history
set "HOTFIX_FOUND=0"
for /f "tokens=*" %%h in ('git log --grep="hotfix: add module documentation on main" -n 1 --oneline 2^>nul') do (
    set "HOTFIX_FOUND=1"
)

if "%HOTFIX_FOUND%"=="0" (
    echo [X] FAILED: The hotfix from 'main' has not been integrated into 'feature/capitalize'.
    echo     Requirement: Bring the hotfix from 'main' into your feature branch.
    echo.
    pause
    exit /b 1
)

:: 3. Check that string_ops.py contains the restored in-progress work
findstr /i "capitalize_words" string_ops.py >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [X] FAILED: Incomplete work was not restored in string_ops.py.
    echo     Requirement: Your shelved modifications must be restored to continue development.
    echo.
    pause
    exit /b 1
)

:: 4. Check that stash stack is clean
set "STASH_EXISTS=0"
for /f "tokens=*" %%s in ('git stash list 2^>nul') do set "STASH_EXISTS=1"

if "%STASH_EXISTS%"=="1" (
    echo [X] FAILED: You still have shelved changes left on your stash stack.
    echo     Requirement: Safely apply and clear the shelved changes from the temporary stack.
    echo.
    pause
    exit /b 1
)

echo [OK] Active Branch      : feature/capitalize
echo [OK] Hotfix Integrated  : Latest changes from main present in branch history
echo [OK] Work-in-Progress   : Restored in string_ops.py
echo [OK] Temporary Stack    : Clean (no orphaned shelved entries)
echo.
echo =====================================================================
echo [SUCCESS] CONGRATULATIONS! Problem 03 is successfully solved!
echo =====================================================================
echo.
pause

@echo off
setlocal

title Verify Problem 05

echo =====================================================================
echo       Verifying Problem 05: Committed to the Wrong Branch
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

:: 1. Check if feature/biometric branch exists
git show-ref --verify --quiet refs/heads/feature/biometric
if %ERRORLEVEL% NEQ 0 (
    echo [X] FAILED: Branch 'feature/biometric' does not exist.
    echo     Requirement: Create branch 'feature/biometric' to preserve the experimental feature.
    echo.
    pause
    exit /b 1
)

:: 2. Check that feature/biometric contains the experimental commit
set "EXP_FOUND=0"
for /f "tokens=*" %%c in ('git log feature/biometric --grep="feat(experimental)" -n 1 --oneline 2^>nul') do (
    set "EXP_FOUND=1"
)

if "%EXP_FOUND%"=="0" (
    echo [X] FAILED: The experimental commit was not found on 'feature/biometric'.
    echo     Requirement: Ensure the experimental commit is preserved on feature/biometric.
    echo.
    pause
    exit /b 1
)

:: 3. Check that auth.py is tracked on feature/biometric
set "AUTH_ON_FEATURE=0"
for /f "tokens=*" %%f in ('git ls-tree feature/biometric --name-only 2^>nul') do (
    if "%%f"=="auth.py" set "AUTH_ON_FEATURE=1"
)

if "%AUTH_ON_FEATURE%"=="0" (
    echo [X] FAILED: 'auth.py' is missing from 'feature/biometric' branch.
    echo.
    pause
    exit /b 1
)

:: 4. Check that main has been rewound to the stable commit
set "MAIN_TIP="
for /f "tokens=*" %%m in ('git log main -n 1 --pretty^=format:%%s 2^>nul') do (
    set "MAIN_TIP=%%m"
)

if "%MAIN_TIP%"=="feat(experimental): add facial recognition biometric auth" (
    echo [X] FAILED: 'main' branch still points to the experimental commit.
    echo     Requirement: Rewind 'main' backwards by 1 commit to restore the stable release.
    echo.
    pause
    exit /b 1
)

if not "%MAIN_TIP%"=="feat: add password authentication flow" (
    echo [X] FAILED: 'main' tip is '%MAIN_TIP%', expected 'feat: add password authentication flow'.
    echo.
    pause
    exit /b 1
)

:: 5. Check that auth.py is NOT present on main
for /f "tokens=*" %%f in ('git ls-tree main --name-only 2^>nul') do (
    if "%%f"=="auth.py" (
        echo [X] FAILED: 'auth.py' is still present on the 'main' branch.
        echo.
        pause
        exit /b 1
    )
)

:: 6. Check clean working tree
for /f "tokens=*" %%s in ('git status --porcelain 2^>nul') do (
    echo [X] FAILED: Working tree is not clean. There are uncommitted changes or untracked files.
    echo.
    pause
    exit /b 1
)

echo [OK] Feature Branch     : 'feature/biometric' created with experimental commit
echo [OK] Experimental Code  : auth.py safely preserved on feature branch
echo [OK] Main Branch        : Rewound to stable release ('feat: add password authentication flow')
echo [OK] Branch Isolation   : auth.py completely removed from main branch tree
echo [OK] Working Tree Status: Clean
echo.
echo =====================================================================
echo [SUCCESS] CONGRATULATIONS! Problem 05 is successfully solved!
echo =====================================================================
echo.
pause

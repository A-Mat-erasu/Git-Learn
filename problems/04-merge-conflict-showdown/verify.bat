@echo off
setlocal

title Verify Problem 04

echo =====================================================================
echo          Verifying Problem 04: Merge Conflict Showdown
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

:: 1. Check for leftover conflict markers at beginning of lines in grades.py
findstr /R /C:"^<<<<<<<" grades.py >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo [X] FAILED: Conflict marker ^<^<^<^<^<^<^< is still present in grades.py.
    echo     Requirement: Remove all Git conflict markers before committing.
    echo.
    pause
    exit /b 1
)

findstr /R /C:"^=======" grades.py >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo [X] FAILED: Conflict marker ======= is still present in grades.py.
    echo     Requirement: Remove all Git conflict markers before committing.
    echo.
    pause
    exit /b 1
)

findstr /R /C:"^>>>>>>>" grades.py >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo [X] FAILED: Conflict marker ^>^>^>^>^>^>^> is still present in grades.py.
    echo     Requirement: Remove all Git conflict markers before committing.
    echo.
    pause
    exit /b 1
)

:: 2. Test running Python script
python grades.py >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [X] FAILED: 'python grades.py' failed with a syntax or runtime error.
    echo     Requirement: Ensure the Python script runs cleanly without errors.
    echo.
    pause
    exit /b 1
)

:: 3. Check if merge is still in progress (MERGE_HEAD exists)
git rev-parse -q --verify MERGE_HEAD >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo [X] FAILED: The merge is still in an unresolved / uncommitted state.
    echo     Requirement: Stage the resolved file and commit to finalize the merge.
    echo.
    pause
    exit /b 1
)

:: 4. Check for clean working tree
for /f "tokens=*" %%s in ('git status --porcelain 2^>nul') do (
    echo [X] FAILED: Working tree is not clean. There are uncommitted changes.
    echo.
    pause
    exit /b 1
)

:: 5. Verify that current commit is a true merge commit (has a 2nd parent HEAD^2)
git rev-parse -q --verify HEAD^^2 >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [X] FAILED: Latest commit is not a merge commit.
    echo     Requirement: The conflict must be resolved by completing the merge, not aborting it.
    echo.
    pause
    exit /b 1
)

echo [OK] Conflict Markers   : Fully removed from grades.py
echo [OK] Code Execution     : python grades.py executed successfully
echo [OK] Merge Finalized    : Merge commit created (2 parent commits verified)
echo [OK] Working Tree Status: Clean
echo.
echo =====================================================================
echo [SUCCESS] CONGRATULATIONS! Problem 04 is successfully solved!
echo =====================================================================
echo.
pause

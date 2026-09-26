@echo off
setlocal

title Setup Problem 04: Merge Conflict Showdown

echo =====================================================================
echo          Setting up Problem 04: Merge Conflict Showdown
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

:: Base code on main
(
echo def calculate_average(scores^):
echo     return sum(scores^) / len(scores^)
echo.
echo scores = [85, 92, 78, 90, 88]
echo avg = calculate_average(scores^)
echo.
echo print("Student Academic Evaluation"^)
echo print(f"Calculated Average: {avg:.2f}"^)
) > grades.py

git add grades.py
git commit -m "feat: initial grades calculation script" >nul

:: Branch Alice: updates header
git switch -c feature-alice >nul 2>&1
(
echo def calculate_average(scores^):
echo     return sum(scores^) / len(scores^)
echo.
echo scores = [85, 92, 78, 90, 88]
echo avg = calculate_average(scores^)
echo.
echo print("========================================"^)
echo print("      Semester 1 Final Grade Report     "^)
echo print("========================================"^)
echo print(f"Calculated Average: {avg:.2f}"^)
) > grades.py
git commit -am "feat: format header as official semester grade report" >nul

:: Switch to main and create Branch Bob: conflicting header update
git switch main >nul 2>&1
git switch -c feature-bob >nul 2>&1
(
echo def calculate_average(scores^):
echo     return sum(scores^) / len(scores^)
echo.
echo scores = [85, 92, 78, 90, 88]
echo avg = calculate_average(scores^)
echo.
echo print("****************************************"^)
echo print("   AIML Department Performance Summary  "^)
echo print("****************************************"^)
echo print(f"Calculated Average: {avg:.2f}"^)
) > grades.py
git commit -am "feat: format header as AIML department summary" >nul

:: Trigger intentional merge conflict
git merge feature-alice >nul 2>&1

echo.
echo =====================================================================
echo [SUCCESS] Problem 04 scenario generated in: workspace/
echo.
echo Next steps:
echo   1. cd workspace
echo   2. Read the instructions in ..\README.md
echo   3. Run 'git status' and open 'grades.py' to observe the conflict
echo   4. Fix the conflict, test the Python code, and commit the merge!
echo   5. Run '..\verify.bat' to verify your solution
echo =====================================================================
echo.
pause

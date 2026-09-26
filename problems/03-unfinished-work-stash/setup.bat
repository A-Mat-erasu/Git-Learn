@echo off
setlocal

title Setup Problem 03: The Interrupted Feature

echo =====================================================================
echo          Setting up Problem 03: The Interrupted Feature
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

:: Initial code on main
(
echo def reverse_text(s^):
echo     return s[::-1]
echo.
echo def is_palindrome(s^):
echo     return s == s[::-1]
) > string_ops.py

(
echo import string_ops
echo print("App initialized successfully"^)
) > app.py

git add .
git commit -m "feat: initial string operations module" >nul

:: Create feature branch
git switch -c feature/capitalize >nul 2>&1

:: Switch to main and simulate instructor hotfix
git switch main >nul 2>&1
(
echo """Production String Operations Module - Hotfix v1.0.1"""
echo def reverse_text(s^):
echo     return s[::-1]
echo.
echo def is_palindrome(s^):
echo     return s == s[::-1]
) > string_ops.py

git commit -am "hotfix: add module documentation on main" >nul

:: Switch back to feature branch
git switch feature/capitalize >nul 2>&1

:: Add incomplete work-in-progress edits to string_ops.py (uncommitted)
(
echo def reverse_text(s^):
echo     return s[::-1]
echo.
echo def is_palindrome(s^):
echo     return s == s[::-1]
echo.
echo # Work in progress - incomplete syntax
echo def capitalize_words(s^):
echo     words = s.split(
) > string_ops.py

echo.
echo =====================================================================
echo [SUCCESS] Problem 03 scenario generated in: workspace/
echo.
echo Next steps:
echo   1. cd workspace
echo   2. Read the instructions in ..\README.md
echo   3. Try 'git switch main' to observe why Git blocks you
echo   4. Fix the issue using Git commands!
echo   5. Run '..\verify.bat' to verify your solution
echo =====================================================================
echo.
pause

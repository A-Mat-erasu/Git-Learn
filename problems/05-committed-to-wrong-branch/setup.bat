@echo off
setlocal

title Setup Problem 05: Committed to Wrong Branch

echo =====================================================================
echo       Setting up Problem 05: Committed to the Wrong Branch
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

:: Commit 1: Initial portal
(
echo def welcome(^):
echo     print("Welcome to Secure Portal v1.0"^)
echo.
echo if __name__ == "__main__":
echo     welcome(^)
) > main.py

git add main.py
git commit -m "feat: initial portal release v1.0" >nul

:: Commit 2: Stable authentication
(
echo def welcome(^):
echo     print("Welcome to Secure Portal v1.0"^)
echo.
echo def authenticate_password(username, password^):
echo     return username == "student" and password == "aiml2026"
echo.
echo if __name__ == "__main__":
echo     welcome(^)
) > main.py

git commit -am "feat: add password authentication flow" >nul

:: Commit 3: Mistakenly committed directly to main
(
echo # Experimental Biometric Facial Recognition Module
echo def verify_biometric(user_face_embedding^):
echo     # Prototype matching logic
echo     return True
) > auth.py

git add auth.py
git commit -m "feat(experimental): add facial recognition biometric auth" >nul

echo.
echo =====================================================================
echo [SUCCESS] Problem 05 scenario generated in: workspace/
echo.
echo Next steps:
echo   1. cd workspace
echo   2. Read the instructions in ..\README.md
echo   3. Run 'git log --oneline' to observe the misplaced commit on main
echo   4. Relocate the commit to feature/biometric and restore main!
echo   5. Run '..\verify.bat' to verify your solution
echo =====================================================================
echo.
pause

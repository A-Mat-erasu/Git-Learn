@echo off
:: ==============================================================================
:: Git & Git Bash Automated Setup Launcher for Windows
:: Designed for 1st Year CSE / AIML Students
:: ==============================================================================

title Git and Git Bash Setup Launcher

echo =====================================================================
echo           Welcome to the Git & Git Bash Automated Setup
echo               First-Year CSE / AIML Students Edition
echo =====================================================================
echo.
echo [1/2] Detecting Windows environment and execution permissions...

:: Check if running with 64-bit PowerShell
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Write-Host '[2/2] Launching PowerShell installer script with elevated execution privileges...' -ForegroundColor Cyan; & '%~dp0setup.ps1'"

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo =====================================================================
    echo [ERROR] The setup script encountered an issue (Exit Code: %ERRORLEVEL%).
    echo If execution was blocked, right-click setup.bat and select "Run as administrator".
    echo =====================================================================
) else (
    echo.
    echo =====================================================================
    echo [SUCCESS] Setup process completed!
    echo =====================================================================
)

echo.
echo Press any key to exit this window...
pause >nul

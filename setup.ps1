<#
.SYNOPSIS
    Automated Git and Git Bash setup & PATH configuration script for Windows.
    Specifically designed for First-Year CSE & AIML students.

.DESCRIPTION
    1. Detects operating system and architecture.
    2. Checks if Git and Git Bash are already installed.
    3. If missing, automatically installs Git for Windows via winget or direct official release download.
    4. Automatically configures and verifies PATH environment variables.
    5. Configures essential student Git settings (user identity, default branch to main, autocrlf).
    6. Verifies Git Bash integration and context menu shortcuts.
#>

[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"

function Write-Step {
    param([string]$Message)
    Write-Host "`n[+] $Message" -ForegroundColor Cyan
}

function Write-Success {
    param([string]$Message)
    Write-Host "[OK] $Message" -ForegroundColor Green
}

function Write-WarningMessage {
    param([string]$Message)
    Write-Host "[!] $Message" -ForegroundColor Yellow
}

function Write-ErrorMessage {
    param([string]$Message)
    Write-Host "[X] $Message" -ForegroundColor Red
}

function Refresh-EnvPath {
    # Combine User and Machine PATH for current process
    $machinePath = [System.Environment]::GetEnvironmentVariable("Path", "Machine")
    $userPath    = [System.Environment]::GetEnvironmentVariable("Path", "User")
    $env:Path    = "$machinePath;$userPath"
}

Write-Host "=====================================================================" -ForegroundColor Magenta
Write-Host "        Automated Git & Git Bash Setup for Windows" -ForegroundColor White
Write-Host "           First-Year CSE / AIML Student Edition" -ForegroundColor White
Write-Host "=====================================================================" -ForegroundColor Magenta

# 1. Detect OS & Architecture
Write-Step "Detecting Operating System environment..."
$os = [System.Environment]::OSVersion
$is64Bit = [System.Environment]::Is64BitOperatingSystem

Write-Host "  Operating System : Windows ($($os.VersionString))" -ForegroundColor Gray
Write-Host "  Architecture     : $(if ($is64Bit) {'64-bit'} else {'32-bit'})" -ForegroundColor Gray

if (-not $is64Bit) {
    Write-ErrorMessage "32-bit Windows detected. This automated installer requires a 64-bit system."
    Write-Host "Please download the 32-bit Git installer manually from https://git-scm.com/download/win" -ForegroundColor Yellow
    exit 1
}

# 2. Check if Git is already installed
Write-Step "Checking for existing Git installation..."
Refresh-EnvPath

$gitInstalled = $false
$gitExePath = $null

$gitCommand = Get-Command "git" -ErrorAction SilentlyContinue
if ($gitCommand) {
    $gitInstalled = $true
    $gitExePath = $gitCommand.Source
    $versionOutput = (& git --version)
    Write-Success "Git is already installed: $versionOutput"
    Write-Host "  Location: $gitExePath" -ForegroundColor Gray
} else {
    # Check default install directory if it exists but wasn't in PATH
    $defaultCmdPath = "C:\Program Files\Git\cmd\git.exe"
    if (Test-Path $defaultCmdPath) {
        $gitInstalled = $true
        $gitExePath = $defaultCmdPath
        Write-Success "Git binaries found in default directory: $defaultCmdPath"
    }
}

# 3. Install Git if not present
if (-not $gitInstalled) {
    Write-Step "Git is not installed. Initiating automated installation..."

    $wingetAvailable = (Get-Command "winget" -ErrorAction SilentlyContinue) -ne $null
    $installSuccess = $false

    if ($wingetAvailable) {
        Write-Host "  Attempting installation via Windows Package Manager (winget)..." -ForegroundColor Yellow
        try {
            $wingetProcess = Start-Process -FilePath "winget" -ArgumentList "install --id Git.Git -e --source winget --accept-source-agreements --accept-package-agreements" -NoNewWindow -PassThru -Wait
            if ($wingetProcess.ExitCode -eq 0) {
                Write-Success "Git installed successfully via winget!"
                $installSuccess = $true
            } else {
                Write-WarningMessage "Winget exited with code $($wingetProcess.ExitCode). Trying direct download fallback..."
            }
        } catch {
            Write-WarningMessage "Winget installation encountered an error: $_. Falling back to direct installer..."
        }
    }

    # Fallback to direct download
    if (-not $installSuccess) {
        Write-Host "  Downloading official 64-bit Git for Windows installer..." -ForegroundColor Yellow
        
        $tempDir = [System.IO.Path]::GetTempPath()
        $installerPath = Join-Path $tempDir "Git-Setup-x64.exe"

        try {
            # Query GitHub API for latest Git for Windows release
            [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
            $releaseApiUrl = "https://api.github.com/repos/git-for-windows/git/releases/latest"
            Write-Host "  Querying latest release from Git for Windows repository..." -ForegroundColor Gray
            
            $downloadUrl = $null
            try {
                $releaseInfo = Invoke-RestMethod -Uri $releaseApiUrl -Headers @{"User-Agent"="PowerShell-SetupScript"} -TimeoutSec 10
                $asset = $releaseInfo.assets | Where-Object { $_.name -match "Git-.*-64-bit\.exe$" } | Select-Object -First 1
                if ($asset) {
                    $downloadUrl = $asset.browser_download_url
                }
            } catch {
                Write-WarningMessage "Could not query GitHub API directly ($($_.Exception.Message)). Using default release URL..."
            }

            if (-not $downloadUrl) {
                # Fallback to direct stable release redirect URL
                $downloadUrl = "https://github.com/git-for-windows/git/releases/download/v2.48.1.windows.1/Git-2.48.1-64-bit.exe"
            }

            Write-Host "  Downloading installer from: $downloadUrl" -ForegroundColor Cyan
            Write-Host "  Saving to: $installerPath (this may take 1-2 minutes depending on your internet connection)..." -ForegroundColor Gray
            
            Invoke-WebRequest -Uri $downloadUrl -OutFile $installerPath -UseBasicParsing

            Write-Success "Download complete. Running silent installer..."
            Write-Host "  Configuring Git Bash, Windows Explorer integration, and PATH..." -ForegroundColor Gray

            # Installer flags:
            # /VERYSILENT: No GUI prompts
            # /NORESTART: Don't reboot
            # /SP-: Skip initial prompt
            # /CLOSEAPPLICATIONS: Close running file locks
            # /COMPONENTS: Include desktop icons, context menu "Git Bash Here", association with .sh files
            $installArgs = "/VERYSILENT /NORESTART /SP- /CLOSEAPPLICATIONS /COMPONENTS=""icons,ext\reg\shellhere,assoc,assoc_sh"""
            
            $proc = Start-Process -FilePath $installerPath -ArgumentList $installArgs -Wait -PassThru
            if ($proc.ExitCode -eq 0 -or $proc.ExitCode -eq 3010) {
                Write-Success "Git for Windows installed successfully!"
                $installSuccess = $true
            } else {
                Write-ErrorMessage "Installer exited with unexpected error code: $($proc.ExitCode)"
            }

            # Cleanup installer file
            if (Test-Path $installerPath) {
                Remove-Item -Path $installerPath -Force -ErrorAction SilentlyContinue
            }
        } catch {
            Write-ErrorMessage "Failed to download and install Git: $_"
            Write-Host "Please download and install Git manually from https://git-scm.com/download/win" -ForegroundColor Yellow
            exit 1
        }
    }
}

# 4. PATH Configuration and Verification
Write-Step "Configuring and verifying PATH environment variables..."

$gitCmdDir  = "C:\Program Files\Git\cmd"
$gitBinDir  = "C:\Program Files\Git\bin"
$gitUsrDir  = "C:\Program Files\Git\usr\bin"

# Refresh process environment
Refresh-EnvPath

# Check if git is recognized in process path
if (-not (Get-Command "git" -ErrorAction SilentlyContinue)) {
    Write-Host "  Adding Git directories to User PATH environment variable..." -ForegroundColor Yellow
    
    $currentUserPath = [System.Environment]::GetEnvironmentVariable("Path", "User")
    if ([string]::IsNullOrWhiteSpace($currentUserPath)) {
        $currentUserPath = ""
    }

    $pathsToAdd = @($gitCmdDir, $gitBinDir)
    $modifiedUserPath = $currentUserPath

    foreach ($pathEntry in $pathsToAdd) {
        if (Test-Path $pathEntry) {
            if ($currentUserPath -notlike "*$pathEntry*") {
                if ($modifiedUserPath.Length -gt 0 -and -not $modifiedUserPath.EndsWith(";")) {
                    $modifiedUserPath += ";"
                }
                $modifiedUserPath += "$pathEntry;"
                Write-Host "  + Added to PATH: $pathEntry" -ForegroundColor Gray
            }
        }
    }

    if ($modifiedUserPath -ne $currentUserPath) {
        [System.Environment]::SetEnvironmentVariable("Path", $modifiedUserPath, "User")
        Write-Success "User PATH updated successfully."
    }

    # Refresh current session PATH
    Refresh-EnvPath
}

# Final verification of Git binary
$finalGit = Get-Command "git" -ErrorAction SilentlyContinue
if ($finalGit) {
    $ver = & git --version
    Write-Success "Git PATH verified! Current version: $ver"
} else {
    Write-WarningMessage "Git was installed, but may require a terminal restart to reflect in PowerShell."
    Write-Host "You can access Git immediately via Git Bash!" -ForegroundColor Yellow
}

# 5. Git Bash Verification
Write-Step "Verifying Git Bash installation..."
$gitBashExe = "C:\Program Files\Git\git-bash.exe"
if (Test-Path $gitBashExe) {
    Write-Success "Git Bash executable verified at: $gitBashExe"
    Write-Host "  Tip: You can launch Git Bash from your Start Menu or right-click any folder -> 'Git Bash Here'" -ForegroundColor Gray
} else {
    Write-WarningMessage "Git Bash executable not found at default path ($gitBashExe)."
}

# 6. First-Time Student Git Configuration Helper
Write-Step "Checking student Git identity and configuration..."

$currentName = & git config --global user.name 2>$null
$currentEmail = & git config --global user.email 2>$null

if (-not [string]::IsNullOrWhiteSpace($currentName)) {
    Write-Success "Git user.name already configured: '$currentName'"
} else {
    Write-Host "  Git user.name is currently NOT configured." -ForegroundColor Yellow
    $studentName = Read-Host "  Enter your Full Name (e.g. Alex Johnson)"
    if (-not [string]::IsNullOrWhiteSpace($studentName)) {
        & git config --global user.name "$studentName"
        Write-Success "Set global user.name to '$studentName'"
    } else {
        Write-WarningMessage "user.name skipped. You can set it later using: git config --global user.name 'Your Name'"
    }
}

if (-not [string]::IsNullOrWhiteSpace($currentEmail)) {
    Write-Success "Git user.email already configured: '$currentEmail'"
} else {
    Write-Host "  Git user.email is currently NOT configured." -ForegroundColor Yellow
    $studentEmail = Read-Host "  Enter your College / GitHub Email (e.g. student@college.edu)"
    if (-not [string]::IsNullOrWhiteSpace($studentEmail)) {
        & git config --global user.email "$studentEmail"
        Write-Success "Set global user.email to '$studentEmail'"
    } else {
        Write-WarningMessage "user.email skipped. You can set it later using: git config --global user.email 'your.email@example.com'"
    }
}

# Recommended settings for Windows developers
Write-Step "Configuring student-friendly default settings..."

# Default branch name to main
& git config --global init.defaultBranch main
Write-Success "Configured default initial branch: 'main'"

# Windows line endings handling (CRLF)
& git config --global core.autocrlf true
Write-Success "Configured line-ending conversion: core.autocrlf = true (standard for Windows)"

# Git credential helper (remembers GitHub credentials securely in Windows Credential Manager)
& git config --global credential.helper manager
Write-Success "Configured credential helper: Windows Credential Manager"

# Summary
Write-Host "`n=====================================================================" -ForegroundColor Green
Write-Host "                     SETUP COMPLETE! 🎉" -ForegroundColor Green
Write-Host "=====================================================================" -ForegroundColor Green
Write-Host "You are all set to start your Git & GitHub journey!" -ForegroundColor White
Write-Host "`nNext steps for 1st-Year CSE/AIML students:" -ForegroundColor Cyan
Write-Host "  1. Read the comprehensive handbook: README.md" -ForegroundColor Gray
Write-Host "  2. Launch Git Bash from the Start Menu or right-click in your project folder" -ForegroundColor Gray
Write-Host "  3. Type 'git --version' to confirm your installation anytime" -ForegroundColor Gray
Write-Host "  4. Complete Lab 1 in README.md to make your first commit!" -ForegroundColor Gray
Write-Host "=====================================================================`n" -ForegroundColor Green

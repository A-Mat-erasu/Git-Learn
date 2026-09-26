#!/usr/bin/env bash
# ==============================================================================
# Automated Git Setup & Verification Script for macOS & Linux
# Designed for 1st Year CSE / AIML Students
# ==============================================================================

set -e

# Terminal colors
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
MAGENTA='\033[0;35m'
BOLD='\033[1m'
RESET='\033[0m'

print_header() {
    echo -e "${MAGENTA}=====================================================================${RESET}"
    echo -e "${BOLD}       Automated Git Setup for macOS & Linux Systems${RESET}"
    echo -e "           First-Year CSE / AIML Student Edition"
    echo -e "${MAGENTA}=====================================================================${RESET}"
}

print_step() {
    echo -e "\n${CYAN}[+] $1${RESET}"
}

print_success() {
    echo -e "${GREEN}[OK] $1${RESET}"
}

print_warning() {
    echo -e "${YELLOW}[!] $1${RESET}"
}

print_error() {
    echo -e "${RED}[X] $1${RESET}"
}

print_header

# 1. Detect Operating System
print_step "Detecting Operating System..."
OS_TYPE="$(uname -s)"
ARCH_TYPE="$(uname -m)"

echo "  OS Kernel   : $OS_TYPE"
echo "  Architecture: $ARCH_TYPE"

# 2. Check existing Git installation
print_step "Checking for existing Git installation..."
if command -v git &> /dev/null; then
    CURRENT_GIT_VER="$(git --version)"
    print_success "Git is already installed: $CURRENT_GIT_VER"
    echo "  Location: $(which git)"
else
    print_warning "Git is not installed on this system."

    # Install based on detected OS
    case "$OS_TYPE" in
        Darwin*)
            print_step "Detected macOS environment..."
            echo -e "${CYAN}Note for macOS students:${RESET} macOS uses the native Terminal app (zsh/bash)."
            echo "You do not need a separate 'Git Bash' app (Git Bash is designed for Windows)."
            echo ""
            
            if command -v brew &> /dev/null; then
                echo "  Found Homebrew package manager. Installing Git..."
                brew install git
                print_success "Git installed successfully via Homebrew!"
            else
                echo "  Homebrew not found. Triggering Apple Xcode Command Line Tools installer..."
                echo "  A system popup window may appear. Click 'Install' to proceed."
                xcode-select --install || true
                echo -e "${YELLOW}Please complete the system dialog installation, then rerun this script.${RESET}"
                exit 0
            fi
            ;;

        Linux*)
            print_step "Detected Linux environment..."
            echo -e "${CYAN}Note for Linux students:${RESET} Your native Linux terminal already runs Bash/Zsh."
            echo "You do not need 'Git Bash' (Git Bash provides a Linux-like shell for Windows)."
            echo ""

            # Check distro
            if [ -f /etc/os-release ]; then
                . /etc/os-release
                DISTRO=$ID
                echo "  Linux Distribution: $NAME ($DISTRO)"

                case "$DISTRO" in
                    ubuntu|debian|linuxmint|pop)
                        echo "  Installing Git using apt package manager (may ask for sudo password)..."
                        sudo apt update && sudo apt install -y git
                        ;;
                    fedora|rhel|centos)
                        echo "  Installing Git using dnf package manager (may ask for sudo password)..."
                        sudo dnf install -y git
                        ;;
                    arch|manjaro)
                        echo "  Installing Git using pacman (may ask for sudo password)..."
                        sudo pacman -Sy --noconfirm git
                        ;;
                    opensuse*|suse)
                        echo "  Installing Git using zypper (may ask for sudo password)..."
                        sudo zypper install -y git
                        ;;
                    *)
                        print_warning "Unrecognized distribution ($DISTRO). Trying standard package managers..."
                        if command -v apt-get &> /dev/null; then
                            sudo apt-get update && sudo apt-get install -y git
                        elif command -v dnf &> /dev/null; then
                            sudo dnf install -y git
                        elif command -v pacman &> /dev/null; then
                            sudo pacman -Sy --noconfirm git
                        else
                            print_error "Could not automatically determine package manager."
                            echo "Please install Git manually using your distribution's package manager."
                            exit 1
                        fi
                        ;;
                esac
                print_success "Git installed successfully!"
            else
                print_error "Cannot detect Linux distribution (/etc/os-release not found)."
                exit 1
            fi
            ;;

        MINGW*|MSYS*|CYGWIN*)
            print_step "Detected Windows (Git Bash / MSYS) environment..."
            print_warning "Git is missing in this environment. On Windows, please run setup.bat or setup.ps1 directly."
            exit 1
            ;;

        *)
            print_error "Unsupported Operating System: $OS_TYPE"
            echo "Please refer to README.md for manual setup instructions."
            exit 1
            ;;
    esac
fi

# 3. Verify PATH and Git command
print_step "Verifying PATH and binary access..."
if command -v git &> /dev/null; then
    GIT_PATH="$(which git)"
    GIT_VER="$(git --version)"
    print_success "Git verified on PATH at: $GIT_PATH"
    print_success "Active Version: $GIT_VER"
else
    print_error "Git was not found in PATH after installation."
    echo "You may need to restart your terminal or check ~/.bashrc or ~/.zshrc"
    exit 1
fi

# 4. Identity & Student Configuration Helper
print_step "Checking student Git identity..."

USER_NAME="$(git config --global user.name || true)"
USER_EMAIL="$(git config --global user.email || true)"

if [ -n "$USER_NAME" ]; then
    print_success "Git user.name configured: '$USER_NAME'"
else
    print_warning "Git user.name is not set."
    read -rp "  Enter your Full Name (e.g. Alex Johnson): " INPUT_NAME
    if [ -n "$INPUT_NAME" ]; then
        git config --global user.name "$INPUT_NAME"
        print_success "Configured global user.name to '$INPUT_NAME'"
    else
        print_warning "Skipped user.name. Set later: git config --global user.name 'Your Name'"
    fi
fi

if [ -n "$USER_EMAIL" ]; then
    print_success "Git user.email configured: '$USER_EMAIL'"
else
    print_warning "Git user.email is not set."
    read -rp "  Enter your College / GitHub Email (e.g. student@college.edu): " INPUT_EMAIL
    if [ -n "$INPUT_EMAIL" ]; then
        git config --global user.email "$INPUT_EMAIL"
        print_success "Configured global user.email to '$INPUT_EMAIL'"
    else
        print_warning "Skipped user.email. Set later: git config --global user.email 'student@college.edu'"
    fi
fi

# 5. Recommended Settings for Unix / Linux / macOS
print_step "Applying recommended student configurations..."

# Default branch to main
git config --global init.defaultBranch main
print_success "Configured default initial branch: 'main'"

# Line endings for Unix / macOS
git config --global core.autocrlf input
print_success "Configured line-ending conversion: core.autocrlf = input (standard for Unix/macOS)"

# Credential helper
if [ "$OS_TYPE" = "Darwin" ]; then
    git config --global credential.helper osxkeychain
    print_success "Configured credential helper: macOS Keychain"
elif [[ "$OS_TYPE" == MINGW* || "$OS_TYPE" == MSYS* || "$OS_TYPE" == CYGWIN* ]]; then
    git config --global credential.helper manager
    print_success "Configured credential helper: Windows Credential Manager"
else
    git config --global credential.helper "cache --timeout=3600"
    print_success "Configured credential helper: memory cache (1 hour timeout)"
fi

echo -e "\n${GREEN}=====================================================================${RESET}"
echo -e "${BOLD}${GREEN}                     SETUP COMPLETE! 🎉${RESET}"
echo -e "${GREEN}=====================================================================${RESET}"
echo "You are ready to learn Git and GitHub!"
echo ""
echo -e "${CYAN}Next steps for 1st-Year CSE/AIML students:${RESET}"
echo "  1. Explore the comprehensive guide in README.md"
echo "  2. Type 'git status' or 'git --version' anytime in your terminal"
echo "  3. Start with Lab 1 in README.md to make your first commit!"
echo -e "${GREEN}=====================================================================${RESET}\n"

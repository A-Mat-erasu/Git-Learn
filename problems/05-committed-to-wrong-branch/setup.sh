#!/usr/bin/env bash
set -e

# Problem 05 Setup Script for macOS & Linux

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "====================================================================="
echo "       Setting up Problem 05: Committed to the Wrong Branch"
echo "====================================================================="

if [ -d "workspace" ]; then
    echo "[*] Cleaning existing workspace folder..."
    rm -rf workspace
fi

mkdir workspace
cd workspace

echo "[*] Initializing challenge repository..."
git init -b main > /dev/null 2>&1 || (git init > /dev/null 2>&1 && git branch -M main > /dev/null 2>&1)

git config user.name "Student Developer"
git config user.email "student@college.edu"

# Commit 1: Initial portal
cat << 'EOF' > main.py
def welcome():
    print("Welcome to Secure Portal v1.0")

if __name__ == "__main__":
    welcome()
EOF

git add main.py
git commit -m "feat: initial portal release v1.0" > /dev/null

# Commit 2: Stable authentication
cat << 'EOF' > main.py
def welcome():
    print("Welcome to Secure Portal v1.0")

def authenticate_password(username, password):
    return username == "student" and password == "aiml2026"

if __name__ == "__main__":
    welcome()
EOF

git commit -am "feat: add password authentication flow" > /dev/null

# Commit 3: Mistakenly committed directly to main
cat << 'EOF' > auth.py
# Experimental Biometric Facial Recognition Module
def verify_biometric(user_face_embedding):
    # Prototype matching logic
    return True
EOF

git add auth.py
git commit -m "feat(experimental): add facial recognition biometric auth" > /dev/null

echo ""
echo "====================================================================="
echo "[SUCCESS] Problem 05 scenario generated in: workspace/"
echo ""
echo "Next steps:"
echo "  1. cd workspace"
echo "  2. Read instructions in ../README.md"
echo "  3. Run 'git log --oneline' to observe misplaced commit on main"
echo "  4. Relocate the commit to feature/biometric and restore main!"
echo "  5. Run '../verify.sh' to verify your solution"
echo "====================================================================="

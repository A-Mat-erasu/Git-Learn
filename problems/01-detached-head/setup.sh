#!/usr/bin/env bash
set -e

# Problem 01 Setup Script for macOS & Linux

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "====================================================================="
echo "       Setting up Problem 01: The Detached Time Traveler"
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

# Commit 1
cat << 'EOF' > calculator.py
def add(a, b):
    return a + b
EOF
git add calculator.py
git commit -m "feat: add addition function" > /dev/null

# Commit 2
cat << 'EOF' >> calculator.py

def multiply(a, b):
    return a * b
EOF
git add calculator.py
git commit -m "feat: add multiplication function" > /dev/null

# Commit 3
cat << 'EOF' > usage.txt
Simple Calculator CLI Application
Usage: run calculator.py in python
EOF
git add usage.txt
git commit -m "docs: add usage guide" > /dev/null

# Detach HEAD by checking out commit 2
TARGET_HASH=$(git rev-parse HEAD~1)
git checkout "$TARGET_HASH" > /dev/null 2>&1

echo ""
echo "====================================================================="
echo "[SUCCESS] Problem 01 scenario generated in: workspace/"
echo ""
echo "Next steps:"
echo "  1. cd workspace"
echo "  2. Read instructions in ../README.md"
echo "  3. Run 'git status' to observe symptoms"
echo "  4. Fix the issue using Git commands!"
echo "  5. Run '../verify.sh' to verify your solution"
echo "====================================================================="

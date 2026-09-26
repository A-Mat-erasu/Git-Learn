#!/usr/bin/env bash
set -e

# Problem 03 Setup Script for macOS & Linux

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "====================================================================="
echo "         Setting up Problem 03: The Interrupted Feature"
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

# Initial code on main
cat << 'EOF' > string_ops.py
def reverse_text(s):
    return s[::-1]

def is_palindrome(s):
    return s == s[::-1]
EOF

cat << 'EOF' > app.py
import string_ops
print("App initialized successfully")
EOF

git add .
git commit -m "feat: initial string operations module" > /dev/null

# Create feature branch
git switch -c feature/capitalize > /dev/null 2>&1

# Switch to main and simulate hotfix
git switch main > /dev/null 2>&1
cat << 'EOF' > string_ops.py
"""Production String Operations Module - Hotfix v1.0.1"""
def reverse_text(s):
    return s[::-1]

def is_palindrome(s):
    return s == s[::-1]
EOF
git commit -am "hotfix: add module documentation on main" > /dev/null

# Switch back to feature branch
git switch feature/capitalize > /dev/null 2>&1

# Add incomplete work-in-progress edits to string_ops.py (uncommitted)
cat << 'EOF' > string_ops.py
def reverse_text(s):
    return s[::-1]

def is_palindrome(s):
    return s == s[::-1]

# Work in progress - incomplete syntax
def capitalize_words(s):
    words = s.split(
EOF

echo ""
echo "====================================================================="
echo "[SUCCESS] Problem 03 scenario generated in: workspace/"
echo ""
echo "Next steps:"
echo "  1. cd workspace"
echo "  2. Read instructions in ../README.md"
echo "  3. Try 'git switch main' to observe why Git blocks you"
echo "  4. Fix the issue using Git commands!"
echo "  5. Run '../verify.sh' to verify your solution"
echo "====================================================================="

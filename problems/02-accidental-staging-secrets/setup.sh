#!/usr/bin/env bash
set -e

# Problem 02 Setup Script for macOS & Linux

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "====================================================================="
echo "      Setting up Problem 02: Accidental Staging of Secrets & Bloat"
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

# Base commit
echo "# AI Lab Project" > README.md
git add README.md
git commit -m "chore: initialize project" > /dev/null

# Create predict.py
cat << 'EOF' > predict.py
import math

def predict(x):
    return 2.5 * x + 1.2

if __name__ == '__main__':
    print(f"Prediction: {predict(4)}")
EOF

# Create simulated secret file
cat << 'EOF' > secret_api_key.env
# CONFIDENTIAL API TOKENS - NEVER COMMIT
OPENAI_API_KEY=sk-proj-99887766554433221100aabbccddeeff
DATABASE_PASSWORD=super_secret_lab_password_2026
EOF

# Create simulated dataset file
cat << 'EOF' > raw_dataset.csv
id,feature_1,feature_2,label
1,0.45,1.23,0
2,0.89,0.12,1
3,0.12,0.98,0
EOF

# Mistakenly stage all 3 files
git add .

echo ""
echo "====================================================================="
echo "[SUCCESS] Problem 02 scenario generated in: workspace/"
echo ""
echo "Next steps:"
echo "  1. cd workspace"
echo "  2. Read instructions in ../README.md"
echo "  3. Run 'git status' to observe staged files"
echo "  4. Fix the issue using Git commands!"
echo "  5. Run '../verify.sh' to verify your solution"
echo "====================================================================="

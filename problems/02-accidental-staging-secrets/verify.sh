#!/usr/bin/env bash
# Verification Script for Problem 02 (macOS / Linux)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="$SCRIPT_DIR/workspace"

if [ ! -d "$TARGET_DIR/.git" ]; then
    echo "[ERROR] No workspace found at: $TARGET_DIR"
    echo "Please run ./setup.sh first!"
    exit 1
fi

cd "$TARGET_DIR"

echo "====================================================================="
echo "      Verifying Problem 02: Accidental Staging of Secrets & Bloat"
echo "====================================================================="
echo ""

# 1. Verify local files still exist on disk
if [ ! -f "secret_api_key.env" ]; then
    echo "[X] FAILED: 'secret_api_key.env' was deleted from disk!"
    echo "    Requirement: The file must be un-staged from Git, but preserved locally."
    exit 1
fi

if [ ! -f "raw_dataset.csv" ]; then
    echo "[X] FAILED: 'raw_dataset.csv' was deleted from disk!"
    echo "    Requirement: The file must be un-staged from Git, but preserved locally."
    exit 1
fi

if [ ! -f "predict.py" ]; then
    echo "[X] FAILED: 'predict.py' is missing from workspace!"
    exit 1
fi

# 2. Check staged files in index
STAGED_FILES=$(git diff --cached --name-only)

if echo "$STAGED_FILES" | grep -qx "secret_api_key.env"; then
    echo "[X] FAILED: 'secret_api_key.env' is still staged for commit!"
    echo "    Hint: Remove it from the staging area without deleting the physical file."
    exit 1
fi

if echo "$STAGED_FILES" | grep -qx "raw_dataset.csv"; then
    echo "[X] FAILED: 'raw_dataset.csv' is still staged for commit!"
    echo "    Hint: Remove it from the staging area without deleting the physical file."
    exit 1
fi

if ! echo "$STAGED_FILES" | grep -qx "predict.py"; then
    echo "[X] FAILED: 'predict.py' is NOT staged for commit."
    echo "    Requirement: Legitimate code ('predict.py') must remain staged and ready to commit."
    exit 1
fi

# 3. Check if files are properly ignored by Git
if ! git check-ignore secret_api_key.env > /dev/null 2>&1; then
    echo "[X] FAILED: 'secret_api_key.env' is not ignored by Git."
    echo "    Requirement: Configure repository ignore rules so .env files are permanently ignored."
    exit 1
fi

if ! git check-ignore raw_dataset.csv > /dev/null 2>&1; then
    echo "[X] FAILED: 'raw_dataset.csv' is not ignored by Git."
    echo "    Requirement: Configure repository ignore rules so .csv files are permanently ignored."
    exit 1
fi

echo "[OK] Code Staged        : predict.py is staged and ready for commit"
echo "[OK] Secrets Unstaged   : secret_api_key.env is safely removed from index"
echo "[OK] Dataset Unstaged   : raw_dataset.csv is safely removed from index"
echo "[OK] Local Disk Files   : Preserved on disk for local execution"
echo "[OK] Ignore Rules       : Configured and active (check-ignore verified)"
echo ""
echo "====================================================================="
echo "[SUCCESS] CONGRATULATIONS! Problem 02 is successfully solved!"
echo "====================================================================="

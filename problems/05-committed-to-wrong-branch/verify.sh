#!/usr/bin/env bash
# Verification Script for Problem 05 (macOS / Linux)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="$SCRIPT_DIR/workspace"

if [ ! -d "$TARGET_DIR/.git" ]; then
    echo "[ERROR] No workspace found at: $TARGET_DIR"
    echo "Please run ./setup.sh first."
    exit 1
fi

cd "$TARGET_DIR"

echo "====================================================================="
echo "       Verifying Problem 05: Committed to the Wrong Branch"
echo "====================================================================="
echo ""

# 1. Check if feature/biometric branch exists
if ! git show-ref --verify --quiet refs/heads/feature/biometric; then
    echo "[X] FAILED: Branch 'feature/biometric' does not exist."
    echo "    Requirement: Create branch 'feature/biometric' to preserve the experimental feature."
    exit 1
fi

# 2. Check that feature/biometric contains the experimental commit
if ! git log feature/biometric --grep="feat(experimental)" -n 1 --oneline 2>/dev/null | grep -q "experimental"; then
    echo "[X] FAILED: The experimental commit was not found on 'feature/biometric'."
    echo "    Requirement: Ensure the experimental commit is preserved on feature/biometric."
    exit 1
fi

# 3. Check that auth.py is tracked on feature/biometric
if ! git ls-tree feature/biometric --name-only 2>/dev/null | grep -qx "auth.py"; then
    echo "[X] FAILED: 'auth.py' is missing from 'feature/biometric' branch."
    exit 1
fi

# 4. Check that main has been rewound to the stable commit
MAIN_TIP=$(git log main -n 1 --pretty=format:%s 2>/dev/null)

if [ "$MAIN_TIP" = "feat(experimental): add facial recognition biometric auth" ]; then
    echo "[X] FAILED: 'main' branch still points to the experimental commit."
    echo "    Requirement: Rewind 'main' backwards by 1 commit to restore the stable release."
    exit 1
fi

if [ "$MAIN_TIP" != "feat: add password authentication flow" ]; then
    echo "[X] FAILED: 'main' tip is '$MAIN_TIP', expected 'feat: add password authentication flow'."
    exit 1
fi

# 5. Check that auth.py is NOT present on main
if git ls-tree main --name-only 2>/dev/null | grep -qx "auth.py"; then
    echo "[X] FAILED: 'auth.py' is still present on the 'main' branch."
    exit 1
fi

# 6. Check clean working tree
if [ -n "$(git status --porcelain 2>/dev/null)" ]; then
    echo "[X] FAILED: Working tree is not clean. There are uncommitted changes or untracked files."
    exit 1
fi

echo "[OK] Feature Branch     : 'feature/biometric' created with experimental commit"
echo "[OK] Experimental Code  : auth.py safely preserved on feature branch"
echo "[OK] Main Branch        : Rewound to stable release ('feat: add password authentication flow')"
echo "[OK] Branch Isolation   : auth.py completely removed from main branch tree"
echo "[OK] Working Tree Status: Clean"
echo ""
echo "====================================================================="
echo "[SUCCESS] CONGRATULATIONS! Problem 05 is successfully solved!"
echo "====================================================================="

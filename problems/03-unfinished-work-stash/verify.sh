#!/usr/bin/env bash
# Verification Script for Problem 03 (macOS / Linux)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="$SCRIPT_DIR/workspace"

if [ ! -d "$TARGET_DIR/.git" ]; then
    echo "[ERROR] No workspace found at: $TARGET_DIR"
    echo "Please run ./setup.sh first."
    exit 1
fi

cd "$TARGET_DIR"

echo "====================================================================="
echo "         Verifying Problem 03: The Interrupted Feature"
echo "====================================================================="
echo ""

# 1. Check current branch
CURRENT_BRANCH="$(git branch --show-current 2>/dev/null || true)"

if [ "$CURRENT_BRANCH" = "main" ]; then
    echo "[X] FAILED: You are currently on branch 'main'."
    echo "    Requirement: After visiting main, you must return to 'feature/capitalize'."
    exit 1
fi

if [ "$CURRENT_BRANCH" != "feature/capitalize" ]; then
    echo "[X] FAILED: You are on branch '$CURRENT_BRANCH', expected 'feature/capitalize'."
    exit 1
fi

# 2. Check hotfix commit integration
if ! git log --grep="hotfix: add module documentation on main" -n 1 --oneline 2>/dev/null | grep -q "hotfix"; then
    echo "[X] FAILED: The hotfix from 'main' has not been integrated into 'feature/capitalize'."
    echo "    Requirement: Bring the hotfix from 'main' into your feature branch."
    exit 1
fi

# 3. Check that string_ops.py contains restored in-progress work
if ! grep -q "capitalize_words" string_ops.py 2>/dev/null; then
    echo "[X] FAILED: Incomplete work was not restored in string_ops.py."
    echo "    Requirement: Your shelved modifications must be restored to continue development."
    exit 1
fi

# 4. Check that stash stack is clean
if [ -n "$(git stash list 2>/dev/null)" ]; then
    echo "[X] FAILED: You still have shelved changes left on your stash stack."
    echo "    Requirement: Safely apply and clear the shelved changes from the temporary stack."
    exit 1
fi

echo "[OK] Active Branch      : feature/capitalize"
echo "[OK] Hotfix Integrated  : Latest changes from main present in branch history"
echo "[OK] Work-in-Progress   : Restored in string_ops.py"
echo "[OK] Temporary Stack    : Clean (no orphaned shelved entries)"
echo ""
echo "====================================================================="
echo "[SUCCESS] CONGRATULATIONS! Problem 03 is successfully solved!"
echo "====================================================================="

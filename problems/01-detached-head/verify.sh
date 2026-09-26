#!/usr/bin/env bash
# Verification Script for Problem 01 (macOS / Linux)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="$SCRIPT_DIR/workspace"

if [ ! -d "$TARGET_DIR/.git" ]; then
    echo "[ERROR] No workspace found at: $TARGET_DIR"
    echo "Please run ./setup.sh first!"
    exit 1
fi

cd "$TARGET_DIR"

echo "====================================================================="
echo "        Verifying Problem 01: The Detached Time Traveler"
echo "====================================================================="
echo ""

# 1. Check if HEAD is attached to a branch
CURRENT_BRANCH="$(git branch --show-current 2>/dev/null || true)"

if [ -z "$CURRENT_BRANCH" ]; then
    echo "[X] FAILED: You are still in a 'Detached HEAD' state."
    echo "    Hint: Your HEAD reference is pointing to a commit hash instead of a branch."
    exit 1
fi

# 2. Check if current branch is main
if [ "$CURRENT_BRANCH" != "main" ]; then
    echo "[X] FAILED: You are on branch '$CURRENT_BRANCH', but your target is 'main'."
    exit 1
fi

# 3. Check for clean working tree
if [ -n "$(git status --porcelain 2>/dev/null)" ]; then
    echo "[X] FAILED: Working tree is not clean. There are uncommitted changes or untracked files."
    exit 1
fi

# 4. Check if usage.txt exists
if [ ! -f "usage.txt" ]; then
    echo "[X] FAILED: 'usage.txt' is missing. You may not be at the tip of the 'main' branch."
    exit 1
fi

# 5. Check commit count
COMMIT_COUNT=$(git rev-list --count HEAD 2>/dev/null || echo 0)
if [ "$COMMIT_COUNT" -lt 3 ]; then
    echo "[X] FAILED: Found $COMMIT_COUNT commits, expected at least 3. History might have been lost."
    exit 1
fi

echo "[OK] Active Branch      : main"
echo "[OK] Working Tree Status: Clean"
echo "[OK] Commit History     : 3/3 Commits Verified"
echo "[OK] Project Files      : Complete and Up to Date"
echo ""
echo "====================================================================="
echo "[SUCCESS] CONGRATULATIONS! Problem 01 is successfully solved!"
echo "====================================================================="

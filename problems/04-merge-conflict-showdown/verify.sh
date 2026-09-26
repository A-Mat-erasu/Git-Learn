#!/usr/bin/env bash
# Verification Script for Problem 04 (macOS / Linux)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="$SCRIPT_DIR/workspace"

if [ ! -d "$TARGET_DIR/.git" ]; then
    echo "[ERROR] No workspace found at: $TARGET_DIR"
    echo "Please run ./setup.sh first."
    exit 1
fi

cd "$TARGET_DIR"

echo "====================================================================="
echo "         Verifying Problem 04: Merge Conflict Showdown"
echo "====================================================================="
echo ""

# 1. Check for leftover conflict markers at line starts in grades.py
if grep -q "^<<<<<<<" grades.py 2>/dev/null; then
    echo "[X] FAILED: Conflict marker <<<<<<< is still present in grades.py."
    echo "    Requirement: Remove all Git conflict markers before committing."
    exit 1
fi

if grep -q "^=======" grades.py 2>/dev/null; then
    echo "[X] FAILED: Conflict marker ======= is still present in grades.py."
    echo "    Requirement: Remove all Git conflict markers before committing."
    exit 1
fi

if grep -q "^>>>>>>>" grades.py 2>/dev/null; then
    echo "[X] FAILED: Conflict marker >>>>>>> is still present in grades.py."
    echo "    Requirement: Remove all Git conflict markers before committing."
    exit 1
fi

# 2. Test running Python script
if ! python3 grades.py > /dev/null 2>&1 && ! python grades.py > /dev/null 2>&1; then
    echo "[X] FAILED: Running 'python grades.py' failed with a syntax or runtime error."
    echo "    Requirement: Ensure the Python script runs cleanly without errors."
    exit 1
fi

# 3. Check if merge is still in progress (MERGE_HEAD exists)
if git rev-parse -q --verify MERGE_HEAD > /dev/null 2>&1; then
    echo "[X] FAILED: The merge is still in an unresolved / uncommitted state."
    echo "    Requirement: Stage the resolved file and commit to finalize the merge."
    exit 1
fi

# 4. Check for clean working tree
if [ -n "$(git status --porcelain 2>/dev/null)" ]; then
    echo "[X] FAILED: Working tree is not clean. There are uncommitted changes."
    exit 1
fi

# 5. Verify that current commit is a true merge commit (has a 2nd parent HEAD^2)
if ! git rev-parse -q --verify HEAD^2 > /dev/null 2>&1; then
    echo "[X] FAILED: Latest commit is not a merge commit."
    echo "    Requirement: The conflict must be resolved by completing the merge, not aborting it."
    exit 1
fi

echo "[OK] Conflict Markers   : Fully removed from grades.py"
echo "[OK] Code Execution     : python grades.py executed successfully"
echo "[OK] Merge Finalized    : Merge commit created (2 parent commits verified)"
echo "[OK] Working Tree Status: Clean"
echo ""
echo "====================================================================="
echo "[SUCCESS] CONGRATULATIONS! Problem 04 is successfully solved!"
echo "====================================================================="

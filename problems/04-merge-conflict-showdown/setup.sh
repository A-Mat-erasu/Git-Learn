#!/usr/bin/env bash
set -e

# Problem 04 Setup Script for macOS & Linux

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "====================================================================="
echo "         Setting up Problem 04: Merge Conflict Showdown"
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

# Base code on main
cat << 'EOF' > grades.py
def calculate_average(scores):
    return sum(scores) / len(scores)

scores = [85, 92, 78, 90, 88]
avg = calculate_average(scores)

print("Student Academic Evaluation")
print(f"Calculated Average: {avg:.2f}")
EOF

git add grades.py
git commit -m "feat: initial grades calculation script" > /dev/null

# Branch Alice: updates header
git switch -c feature-alice > /dev/null 2>&1
cat << 'EOF' > grades.py
def calculate_average(scores):
    return sum(scores) / len(scores)

scores = [85, 92, 78, 90, 88]
avg = calculate_average(scores)

print("========================================")
print("      Semester 1 Final Grade Report     ")
print("========================================")
print(f"Calculated Average: {avg:.2f}")
EOF
git commit -am "feat: format header as official semester grade report" > /dev/null

# Switch to main and create Branch Bob: conflicting header update
git switch main > /dev/null 2>&1
git switch -c feature-bob > /dev/null 2>&1
cat << 'EOF' > grades.py
def calculate_average(scores):
    return sum(scores) / len(scores)

scores = [85, 92, 78, 90, 88]
avg = calculate_average(scores)

print("****************************************")
print("   AIML Department Performance Summary  ")
print("****************************************")
print(f"Calculated Average: {avg:.2f}")
EOF
git commit -am "feat: format header as AIML department summary" > /dev/null

# Trigger intentional merge conflict (ignoring non-zero exit code)
git merge feature-alice > /dev/null 2>&1 || true

echo ""
echo "====================================================================="
echo "[SUCCESS] Problem 04 scenario generated in: workspace/"
echo ""
echo "Next steps:"
echo "  1. cd workspace"
echo "  2. Read instructions in ../README.md"
echo "  3. Run 'git status' and open 'grades.py' to observe the conflict"
echo "  4. Fix the conflict, test the Python code, and commit the merge!"
echo "  5. Run '../verify.sh' to verify your solution"
echo "====================================================================="

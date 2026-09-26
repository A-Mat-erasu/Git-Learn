# 🧩 Problem 01: The Detached Time Traveler

**Focus Area:** Git References, HEAD, and Branch Navigation  
**Estimated Time:** 5 - 10 minutes  

---

## 📖 The Scenario

Late last night, you were reviewing your team's Python calculator project (`calculator.py`). You wanted to inspect how the multiplication feature was implemented before your partner added documentation. 

You ran a command to jump back in time to that specific snapshot. You examined the file, tested it, and everything looked great! 

However, when you returned to your terminal this morning to continue building new features, Git started showing an ominous warning message:

```text
You are in 'detached HEAD' state. You can look around, make experimental
changes and commit them, and you can discard any commits you make in this
state without impacting any branches by switching back to a branch.
```

Your lab partner warns you: *"If you write code or make commits right now, they won't belong to any branch and will be completely lost when you switch away!"*

---

## 🔍 Observed Symptoms

Inside the `workspace/` repository, run:

```bash
git status
```

Notice the output:
- Git warns that `HEAD detached at ...`.
- You are not currently on the `main` branch.
- Some recent files from later commits (like `usage.txt`) appear to be "missing" from your current folder view!

---

## 🎯 Your Mission & Target State

Your goal is to safely restore the repository to normal operation without losing any project history:

1. **Reattach to the primary development line**: Ensure your active branch is `main`.
2. **Restore full project files**: All project files from the latest snapshot (including `usage.txt` and the latest `calculator.py`) must be visible in your working folder.
3. **Clean Working Tree**: `git status` must confirm that you are on branch `main` with nothing left uncommitted.
4. **Preserve All Commits**: All 3 original commits created during project setup must remain present in your commit log (`git log --oneline`).

---

## 🚫 Constraints

- Do **not** delete the `workspace` or `.git` folder.
- Do **not** re-initialize the repository.
- Use Git commands to navigate back to safety.

---

## 🧪 How to Verify Your Solution

Once you believe you have re-attached to `main` and restored the repository:

- **On Windows**:
  ```cmd
  ..\verify.bat
  ```
- **On macOS / Linux**:
  ```bash
  ../verify.sh
  ```

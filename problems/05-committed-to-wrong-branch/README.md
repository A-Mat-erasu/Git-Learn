# 🧩 Problem 05: Committed to the Wrong Branch

**Focus Area:** Branch Pointers, Commit Relocation, and History Reset  
**Estimated Time:** 5 - 10 minutes  

---

## 📖 The Scenario

In modern software development and college team projects, the **`main` branch is protected**: it must only contain stable, release-ready, tested code. All new experiments must be developed on dedicated feature branches before being reviewed and merged.

You and your team built Version 1.0 of a student portal (`main.py`). 

Your teammate was assigned to start an experimental facial recognition feature (`auth.py`). The instructions were clear: *"Create a new branch named `feature/biometric` before writing any code!"*

Unfortunately, in the excitement of writing code, your teammate forgot to branch off. They implemented `auth.py` and committed it **directly onto the `main` branch**!

Now, the production `main` branch is contaminated with unstable, unreviewed prototype code right before the project demo.

---

## 🔍 Observed Symptoms

Inside `workspace/`, run:

```bash
git log --oneline
```

Notice:
- The top commit on `main` is: `feat(experimental): add facial recognition biometric auth`.
- `auth.py` is present in the `main` branch folder.
- No `feature/biometric` branch exists in `git branch`.

---

## 🎯 Your Mission & Target State

Relocate the experimental feature onto its own branch and rewind `main` to safety:

1. **Preserve the Feature**: Ensure a new branch named `feature/biometric` exists, containing the experimental commit and `auth.py`.
2. **Rewind Main**: Rewind the `main` branch backwards by exactly 1 commit so that its tip is once again the stable commit (`feat: add password authentication flow`).
3. **Verify Branch Isolation**:
   - When checked out on `main`, `auth.py` must **not** exist in your folder.
   - When checked out on `feature/biometric`, `auth.py` **must** exist.
4. **Clean Working Tree**: Ensure no uncommitted changes or dirty files remain.

---

## 🚫 Constraints

- Do **not** discard or lose the experimental code in `auth.py`.
- Do **not** delete and re-clone the repository.

---

## 🧪 How to Verify Your Solution

Once you have relocated the commit to `feature/biometric` and restored `main`:

- **On Windows**:
  ```cmd
  ..\verify.bat
  ```
- **On macOS / Linux**:
  ```bash
  ../verify.sh
  ```

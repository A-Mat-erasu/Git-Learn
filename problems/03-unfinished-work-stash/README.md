# 🧩 Problem 03: The Interrupted Feature

**Focus Area:** Workflow Interruption, Temporary Shelving, and Branch Switching  
**Estimated Time:** 5 - 10 minutes  

---

## 📖 The Scenario

You are actively developing a text-processing module for your college assignment on a branch named `feature/capitalize`. 

You are halfway through writing a new function in `string_ops.py`. The code has unclosed parentheses, missing indentation, and syntax errors. It is **not ready to be committed**—project guidelines strictly forbid committing non-working, broken code into the commit history.

Suddenly, your lab instructor makes an urgent announcement: 
> *"A critical hotfix was just committed to the `main` branch. All students must immediately switch to `main` to inspect the updated codebase!"*

You open your terminal and attempt to switch to `main`. To your dismay, Git refuses to let you leave:

```text
error: Your local changes to the following files would be overwritten by checkout:
	string_ops.py
Please commit your changes or stash them before you switch branches.
Aborting
```

You are stuck between two rules:
1. You **cannot commit** because your code is broken and unfinished.
2. You **cannot discard** your changes because you spent 30 minutes writing them.

---

## 🔍 Observed Symptoms

Inside `workspace/`, run:

```bash
git status
```

Notice:
- You are on branch `feature/capitalize`.
- `string_ops.py` has modified, uncommitted changes.
- Attempting to switch branches is blocked by Git to protect your uncommitted work from being overwritten.

---

## 🎯 Your Mission & Target State

Safely navigate the interruption and synchronize the update:

1. **Shelve Incomplete Work**: Safely store your dirty, unfinished edits without making a broken commit.
2. **Synchronize the Hotfix**: Bring the critical hotfix from `main` into your `feature/capitalize` branch (so your branch contains the hotfix commit).
3. **Restore Work-in-Progress**: Retrieve your shelved modifications back into your working directory on `feature/capitalize` so `string_ops.py` once again contains your in-progress work.
4. **Clean Temporary Storage**: Ensure you have not left behind any un-retrieved shelved entries on your temporary storage stack.

---

## 🚫 Constraints

- Do **not** commit broken code to either branch.
- Do **not** discard or delete your work in `string_ops.py`.
- Do **not** delete and re-clone the repository.

---

## 🧪 How to Verify Your Solution

Once you have returned to `feature/capitalize` and restored your in-progress modifications:

- **On Windows**:
  ```cmd
  ..\verify.bat
  ```
- **On macOS / Linux**:
  ```bash
  ../verify.sh
  ```

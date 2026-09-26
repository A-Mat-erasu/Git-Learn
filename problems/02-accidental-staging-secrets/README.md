# 🧩 Problem 02: Accidental Staging of Secrets & Bloat

**Focus Area:** The Staging Area (Index), Unstaging, and `.gitignore`  
**Estimated Time:** 5 - 10 minutes  

---

## 📖 The Scenario

You and your AIML lab partner are building a predictive model (`predict.py`). 

Your partner obtained a simulated dataset (`raw_dataset.csv`) and created an environment file containing confidential API credentials (`secret_api_key.env`). In a rush to save the code before class ended, your partner typed a blanket command that staged **every single file in the directory**.

Before anyone ran the commit command, you glanced at the terminal and gasped:
```text
Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
	new file:   predict.py
	new file:   raw_dataset.csv
	new file:   secret_api_key.env
```

Your partner says: *"Let's just commit it now and we can delete the files later!"*

**You know better.** If sensitive API keys or large dataset files are committed into Git, they become permanently baked into the repository's history—even if deleted in a later commit! Furthermore, your local application still needs both files on disk to run experiments.

---

## 🔍 Observed Symptoms

Inside `workspace/`, run:

```bash
git status
```

Notice:
- `secret_api_key.env` and `raw_dataset.csv` are staged (in green) under "Changes to be committed".
- There is currently no ignore configuration file in the project.

---

## 🎯 Your Mission & Target State

Fix the staging area and protect the repository from accidental leaks:

1. **Keep valid code staged**: `predict.py` must remain staged in the index ready for the next commit.
2. **Unstage secrets & datasets**: `secret_api_key.env` and `raw_dataset.csv` must be removed from the staging area.
3. **Do not delete local files**: Both `secret_api_key.env` and `raw_dataset.csv` must still exist intact on your computer's hard drive.
4. **Permanent Ignore Protection**: Configure the repository so that Git permanently ignores all `.env` files and `.csv` files. Running `git status` should not report them as untracked files (`??`).

---

## 🚫 Constraints

- Do **not** delete `secret_api_key.env` or `raw_dataset.csv` from disk.
- Do **not** commit the secret credentials into history.
- Do **not** destroy `predict.py`.

---

## 🧪 How to Verify Your Solution

Once you have un-staged the sensitive files and configured project ignore rules:

- **On Windows**:
  ```cmd
  ..\verify.bat
  ```
- **On macOS / Linux**:
  ```bash
  ../verify.sh
  ```

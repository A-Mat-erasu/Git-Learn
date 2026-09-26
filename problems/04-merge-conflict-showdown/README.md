# 🧩 Problem 04: The Merge Conflict Showdown

**Focus Area:** Collaborative Conflicts, Marker Anatomy, and Merge Finalization  
**Estimated Time:** 5 - 10 minutes  

---

## 📖 The Scenario

Two engineering teammates, **Alice** and **Bob**, were assigned to improve a student grading utility (`grades.py`). 

They each created separate branches from `main`:
- Alice created branch `feature-alice` and formatted the output header as a formal semester report.
- Bob created branch `feature-bob` and formatted the exact same lines of code as an AIML department summary.

When Bob attempted to merge Alice's branch into `feature-bob` so they could combine their work, Git abruptly halted the operation:

```text
Auto-merging grades.py
CONFLICT (content): Merge conflict in grades.py
Automatic merge failed; fix conflicts and then commit the result.
```

If you try to run the script right now (`python grades.py`), Python crashes with a severe `SyntaxError`. 

The team's presentation to the department faculty is in 10 minutes, and the code is broken!

---

## 🔍 Observed Symptoms

Inside `workspace/`, run:

```bash
git status
```

Notice:
- Git reports: `You have unmerged paths.`
- `grades.py` is listed as `both modified`.
- Opening `grades.py` reveals conflict delimiter markers inserted by Git.
- Running `python grades.py` fails.

---

## 🎯 Your Mission & Target State

Resolve the code collision and complete the merge:

1. **Reconcile the Header**: Open `grades.py` in your editor. Combine or rewrite the header so that it produces a neat, professional title for the grading program.
2. **Remove All Conflict Markers**: Ensure every single conflict marker line (`<<<<<<<`, `=======`, `>>>>>>>`) is deleted.
3. **Validate Code Execution**: Run `python grades.py` from your terminal; it must execute without syntax errors and print the computed average.
4. **Finalize the Merge**: Stage the resolved file and commit the resolution to finish the merge process.
5. **Clean Repository State**: `git status` must report that the working tree is clean and the merge has concluded.

---

## 🚫 Constraints

- Do **not** run `git merge --abort` (you must resolve the conflict, not quit!).
- Do **not** delete `grades.py`.
- Do **not** leave any raw conflict markers in the Python file.

---

## 🧪 How to Verify Your Solution

Once you have resolved the markers, verified that `python grades.py` runs, and committed the merge:

- **On Windows**:
  ```cmd
  ..\verify.bat
  ```
- **On macOS / Linux**:
  ```bash
  ../verify.sh
  ```

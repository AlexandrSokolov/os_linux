# split_files_v5.sh Specification

## Overview
This document describes the behavior, rules, processing flow, and output structure of the script **split_files_v5.sh**.

The script prepares all files in a Java/Maven project for upload into Microsoft 365 Copilot Chat by distributing them into numbered folders containing up to **3 files** each—the current upload limit per message. The script minimizes the total number of folders by packing them efficiently.

All processed files are placed under a unified folder:
```
copilot_sources/
```
with multiple well‑defined subcategories.

---

## 1. Directory Structure Created
Inside `copilot_sources/`, the script generates the following categories:

```
root/                 # Only project‑root files (e.g. pom.xml, README.md)
other/                # Subdirectories not under src/main/* or src/test/*
src_main_java/        # Files under src/main/java
src_main_resources/   # Files under src/main/resources
src_main_webapp/      # Files under src/main/webapp
src_test_java/        # Files under src/test/java
src_test_resources/   # Files under src/test/resources
src_test_webapp/      # Files under src/test/webapp
```

Each category contains numbered folders:
```
01/
02/
03/
...
```
Each folder contains up to **3** files.

---

## 2. Excluded Directories and Files
The script **ignores** the following directories anywhere in the project:

- `.git/`
- `.idea/`
- `target/`
- any directory named `copilot_sources*` (prevents re-indenting artifacts)

It also excludes:
- `.gitignore`
- any script matching `split_files*.sh`

This ensures a clean run every time.

---

## 3. File Classification Rules
The script classifies every file into a category based on its **project-relative path**.

### 3.1 Category Assignments
| Condition | Category | BASE_PREFIX |
|----------|----------|-------------|
| `src/main/java/*` | src_main_java | `src/main/java/` |
| `src/main/resources/*` | src_main_resources | `src/main/resources/` |
| `src/main/webapp/*` | src_main_webapp | `src/main/webapp/` |
| `src/test/java/*` | src_test_java | `src/test/java/` |
| `src/test/resources/*` | src_test_resources | `src/test/resources/` |
| `src/test/webapp/*` | src_test_webapp | `src/test/webapp/` |
| *file in project root* | root | (empty) |
| *file in any other location* | other | (empty) |

---

## 4. File Renaming Rules
### 4.1 root category
Files in the project root retain their original names:
```
pom.xml → pom.xml
README.md → README.md
```

### 4.2 All other categories
File names are transformed:

```
<relative-path-within-category> with '/' replaced by '.'
```

Examples:
```
src/main/java/com/x/A.java
→ com.x.A.java

src/main/resources/config/app.yml
→ config.app.yml

config/log4j.xml (in other/)
→ config.log4j.xml
```

### 4.3 Collision Handling
If a file with the same name already exists inside a numbered folder, the script appends a unique suffix:
```
A.java, A__2.java, A__3.java, ...
```

---

## 5. Numbered Folder Packing Logic
For each category:
- The script creates folder `01/` initially.
- Each numbered folder can contain at most **3 files**.
- When `01/` reaches 3 files, it creates `02/`, and so on.

This ensures **minimal number of folders**.

---

## 6. Processing Algorithm Summary
1. Clean or recreate the `copilot_sources/` directory.
2. Create all category directories.
3. Traverse the project using directory pruning to skip excluded paths.
4. For each file:
   - Determine category.
   - Compute renamed file name if required.
   - Find the current numbered folder with available space.
   - Copy the file under that folder.
5. When processing completes, each category contains compact folders with at most 3 files each.

---

## 7. Example Output
```
copilot_sources/
  root/
    01/
      pom.xml
      README.md
  src_main_java/
    01/
      com.brandmaker.cs.skyhigh.jms.collection.CustomDataCollection.java
      com.brandmaker.cs.skyhigh.jms.config.Globals.java
      com.brandmaker.cs.skyhigh.jms.core.ProcessActiveJobs.java
  other/
    01/
      docs.intro.md
      scripts.deploy.sh
      config.logging.xml
```

---

## 8. Purpose
The script is designed to:
- Prepare large Java projects for incremental upload
- Fit Copilot Chat’s 3‑files‑per‑message limit
- Avoid mixing root files with structured code
- Produce predictable, clean, and navigable upload batches

This ensures efficient, error‑free project analysis in constrained environments.

---

## End of Specification

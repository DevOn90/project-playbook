# Project Scaffolding Guide

## ToC
1. [Purpose](#1-purpose)
2. [Pre-requisites](#2-pre-requisites)
3. [Scaffold new project (for text based files)](#3-scaffold-new-project-for-text-based-files)
4. [Scaffold new project (for binary files)](#4-scaffold-new-project-for-binary-files)
5. [Make executable files executable](#5-make-executable-files-executable)

---

## 1. Purpose
This guide provides the instructions to scaffold:
1. a new project folder structure with `text based files`
2. `binary files` into the new project folder structure

---

## 2. Pre-requisites
1. Bootstrap script executed successfully.
2. Scaffolding templates available in the `templates/scaffold/` directory.
3. Binary scaffolding templates available in the `templates/scaffold/binary` directory.

---

## 3. Scaffold new project (for text based files)

### 3.1 Get project path
Get/remember the full project path e.g. `/home/<user-name>/path-to/my-test-project`

### 3.2 Template selection
- Choose the scaffolding template from the list in `templates/scaffold/` directory as per your need. E.g. `project-root-scaffold-template.txt` for text based files. 
- Remember the full path of the template e.g. `/home/<user-name>/path-to/project-playbook/templates/scaffold/project-root-scaffold-template.txt`

### 3.3 Change directory
Open new terminal and change directory to the project-playbook root.
```bash
cd /home/<user-name>/path-to/project-playbook
```

### 3.4 Run scaffolding script
Run the script with the template and project path as arguments. Use `--dry-run` to see what will be created without actually creating the files and directories.

```bash
bash ./bin/scaffold/scaffold_project.sh --template="$HOME/Desktop/04_Today_Work/project-playbook/templates/scaffold/project-root-scaffold-template.txt" --path="$HOME/Desktop/04_Today_Work/my-test-project" --dry-run
```

### 3.5 Commit and push changes

1. Open new terminal
2. Go to directory of the new project e.g. `cd /home/<user-name>/path-to/my-test-project`  
3. git add . (manually)
4. git commit -m "Initial commit: scaffold project per root template" (manually)
5. git push -u origin development (manually) 

### 3.6 Repeat for other scaffolding templates
Repeat steps 3.2 to 3.5 for other scaffolding templates as needed.

---

## 4. Scaffold new project (for binary files)

### 4.1 Get project path
Get/remember the full project path e.g. `/home/<user-name>/path-to/my-test-project`

### 4.2 Template selection
- Choose the binary template from the list in `templates/scaffold/binary` directory as per your need. E.g. `binary-root-scaffold-template.txt` for binary based files. 
- Remember the full path of the template e.g. `/home/<user-name>/path-to/project-playbook/templates/scaffold/binary/binary-root-scaffold-template.txt`

### 4.3 Change directory
Open new terminal and change directory to the project-playbook root.
```bash
cd /home/<user-name>/path-to/project-playbook
```

### 4.4 Run scaffolding script
Run the script with the template and project path as arguments. Use `--dry-run` to see what will be created without actually creating the files and directories.

```bash
bash ./bin/scaffold/binary_scaffold.sh --template "$HOME/Desktop/04_Today_Work/project-playbook/templates/scaffold/binary/binary-root-scaffold-template.txt" --path "$HOME/Desktop/04_Today_Work/my-test-project" --dry-run
```

### 4.5 Commit and push changes
1. Open new terminal
2. Go to directory of the new project e.g. `cd /home/<user-name>/path-to/my-test-project`  
3. git add . (manually)
4. git commit -m "Initial commit: scaffold project per binary root template" (manually)      
5. git push -u origin development (manually)

### 4.6 Repeat for other scaffolding templates
Repeat steps 4.2 to 4.5 for other scaffolding templates as needed.

---

## 5. Make executable files executable
 
### 5.1 Get project path
Get/remember the full project path e.g. `/home/<user-name>/path-to/my-test-project`

### 5.2 Template selection
- Choose the executables template from the list in `templates/executables/` directory as per your need. E.g. `project-executables-template.txt` for executables based files.

### 5.3 Change directory
Open new terminal and change directory to the project-playbook root.
```bash
cd /home/<user-name>/path-to/project-playbook
```

### 5.4 Run executables script

Run the script with the template and project path as arguments. Use `--dry-run` to see what will be created without actually creating the files and directories.

```bash
bash ./bin/scaffold/executables_init.sh --template "$HOME/Desktop/04_Today_Work/project-playbook/templates/executables/project-executables-template.txt" --path "$HOME/Desktop/04_Today_Work/my-test-project" --dry-run
```

### 5.5 Commit and push changes
1. Open new terminal
2. Go to directory of the new project e.g. `cd /home/<user-name>/path-to/my-test-project`  
3. git add . (manually)
4. git commit -m "Initial commit: make executables executable" (manually)       
5. git push -u origin development (manually)

### 5.6 Repeat for other executables templates
Repeat steps 5.2 to 5.5 for other executables templates as needed.
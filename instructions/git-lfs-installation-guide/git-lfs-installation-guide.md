# Git LFS Installation Guide

## Pre-requisites
**Prerequisites:**
- Git installed on your local machine
- Sudo/admin access on your machine
- Internet connection to download Git LFS

## Scope
This step enables Git LFS on the local machine. Configuration may be applied at system level (/etc/gitconfig) or user global level (~/.gitconfig). 

## Installation Steps

1. Check if Git LFS is already installed:
    ```bash
    git lfs version
    ```
    Expected output if Git LFS is installed:
    ```
    git-lfs/3.0.0 (or similar version)
    ```
    ✅ You can skip steps 2 - 4 of installation.
    Expected output if Git LFS is NOT installed:
    ``` 
    git: 'lfs' is not a git command. See 'git --help'.
    ``` 
    ⚠️ Proceed to step 2 to install Git LFS.

---

2. Download and install Git LFS for your operating system (Linux):
   For details see the [Git LFS installation guide](https://github.com/git-lfs/git-lfs/blob/main/INSTALLING.md)    
    ```bash
    curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash
    
    sudo apt install git-lfs
    ```
3. Initialize Git LFS on your machine (applies to current Git config scope):
    ```bash
    git lfs install
    ```
4. Verify the installation:
    ```bash
    git lfs version
    ```
5. Verify Git LFS integration with Git:
    ```bash
    git config --show-origin --get-regexp ^filter.lfs
    ```
    Expected output:<br>
    ```
    file:/etc/gitconfig (system) or
    file:~/.gitconfig (user global) or
    file:.git/config (local)
    ```
Now you have successfully installed and configured Git LFS on your local machine globally. You can now use Git LFS to manage large files in your Git repositories.


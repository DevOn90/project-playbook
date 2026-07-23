# Project Playbook

## Status
This project is currently in the early stages of development.

---

## Introduction
Welcome to the Project Playbook! This repository serves as a comprehensive guide for:

- project(s) type scaffolding
- project generator 
- engineering templates

---

## Scope
> Note: ⚠️ Only for GH public repositories.

---

## Repo Map

- assets/         --> Static binaries like `.png`, `.ods` 
- bin/            --> Executable scripts
- bootstrap/      --> Bootstrap scripts
- instructions/   --> Instructional guides
- templates/      --> Various templates for project scaffolding
- .gitignore      --> Git ignore file
- .gitarttributes --> Git LFS attributes file

---

## Pre-requisites
1. Decide on project name e.g. `my-test-project`
2. Decide on project path full e.g. `/home/user-name/Desktop/projects/my-test-project`
3. Create new GH repository for the project e.g. `my-test-project`
4.  **Git LFS** installed and configured --> [Git LFS Installation Guide](instructions/git-lfs-installation-guide/git-lfs-installation-guide.md).
  The reason for this is that some of the assets in this repository are large or binary files like (.png, .ods) and Git LFS is designed to handle such files efficiently.

---

## Getting Started
To get started with the Project Playbook, follow these steps:

1. As per the pre-requisetes, ensure you have:
   - a project name
   - a project path
   - a GitHub repository created for the project
   - Git LFS installed and configured
2. Run the bootstrap script to set up the project environment:
   ```bash
   ./bootstrap/bootstrap.sh
   ```
   Script will do:
   - Ask for project name and path
   - Ask for Github username
   - Clone the project GH repository to the specified path
   - Setup Git config username and email



4. Follow the instructions:
   - [instruction A](#instruction-a)
   - [instruction B](#instruction-b)

---

## License
This project is licensed under the MIT License - see the [LICENSE](license.md) file for details.
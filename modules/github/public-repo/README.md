## Official Documentation

- https://docs.github.com/en/rest/repos







---

## Add decision into README.md

1. Dependabot auto-triage default (leave as is)
  - low-impact dev dependencies → default = enabled
  - package malware alerts       → default = disabled
2. Dependabot Grouping
 - Grouped security updates  → default = disabled <br>
   Note: I keep it disabled because `group` is used in `dependabot.yml` file directly.
2. Action Cache and Artifact retention period (leave as is)
  - cache retention → default = 7 days
  - cache size limit → default = 10 GB
3. CodeQL 
  - languages → default = [] <br>
    Note: If you add `python` and repository doesn't have any python code then CodeQL will error out. So only add languages that are used in repository.
4. Secret scanning & Validation
  - secret_scanning_non_provider_patterns → default status = disabled
  - secret_scanning_validity_checks → default status = disabled<br>
  Note: These two features are not available for free plan. So if you want to enable them then you need to upgrade to paid plan.
5. Branch protection strategy
  - main → strict ruleset
  - short-lived branches → no ruleset
6. Administration bypass
  - Set to me as owner. Reason: I want to be able to bypass branch protection rules to act as a maintainer of the repository. This is useful for emergency situations where I need to make changes to the repository that are not allowed by the branch protection rules. 

## Additional CI / Scripts
- `.github/dependabot.yml` - Dependabot configuration file
- `.github/workflows/ci-dependabot-pr-review.yml` - GitHub Actions workflows
   open questions: do i need in public `GH_TOKEN` in `ci-dependabot-pr-review.yml`?


# Github Module - Public Repository

## ToC
1. [Introduction](#1-introduction)
2. [Scope](#2-scope)
3. [Repo Map](#3-repo-map)
4. [Pre-requisites](#4-pre-requisites)
5. [Getting Started](#5-getting-started)
6. [Next Steps](#6-next-steps)

---

## 1. Introduction

---

## 2. Scope

---

## 3. Repo Map

---

## 4. Pre-requisites

---

## 5. Getting Started

### 5.1 Run Angular Module

Navigate to `modules/github/public-repo/bin` directory and run the `main.sh` script.
```bash
cd /full-path-to-project-playbook/modules/github/public-repo/bin
```
Run the script:
```bash
bash ./main.sh
```

### 5.2 Prompt information
- Select a repository from the list
- Enter new repository description (optional)
- Enter the name of new Github project board (e.g. same as repository name)
- Enter the title of new project (or confirm default title)
- Select a repository for the new project board1 

### 5.3 Github Scafflolding
Add the following files to the repository:
- `.github/dependabot.yml` - Dependabot configuration file
- `.github/workflows/ci-dependabot-pr-review.yml` - GitHub Actions workflows

```bash
cd /<full-path-to-playbook-repo>/project-playbook

bash ./bin/scaffold/scaffold_project.sh --template "/<full-path-to-playbook-repo>/project-playbook/modules/github/public-repo/templates/scaffold/github-scaffold-template.txt" --path "<full-path-to-your-project-location>/my-test-project" --dry-run
```

Commit the changes to the repository:
```bash
cd /<full-path-to-your-project-location>/my-test-project

git add .
git commit -m "feat: Add Github scaffolding files"
git push -u origin <branch-name>
```
⚠️ Warning ⚠️ - you cannot commit and push the changes to the repository due to branch protection rules. You need to create a new branch and PR to merge the changes to the main branch.

---

### 5.4 Dependabot Configuration
Revisit the `.github/dependabot.yml` file and update the configuration as per your requirements. Uncomment or add the required configuration. 

---

### 5.1 Setup Script

Run `modules/github/public-repo/bin/main.sh` script to change default generated setting of prublic repository to the desired state. The script will apply the following changes:

- Base
  - ✅ Check if repository is public
  - ✅ Prompt to change description
  - ✅ Prompt to change topics
- Repository settings
  - 🛑 Template repository 
  - 🛑 Repository Wiki
  - ✅ Repository Issues
  - 🛑 Repository Discussions
  - ✅ Repository Projects
  - ✅ Pull request creation policy
  - ✅ Allow squash merge
  - 🛑 Allow merge commit
  - 🛑 Allow rebase merge
  - ✅ Allow update branch
  - 🛑 Allow auto merge
  - ✅ Delete branch on merge
  - 🛑 Require contributors to sign off on web-based commits
- Security settings
  - ✅ Dependency graph
  - ✅ Dependabot alerts
  - ✅ Dependabot security updates
  - ✅ Dependabot malware alerts 🖐️ (***manual step**)
  - ✅ Secret scanning                  
  - ✅ Secret scanning push protection  
  - ✅ Private vulnerability reporting
  - ✅ CodeQL
  - 🛑 Secret scanning generic/non-provider (***Unavailable for free plan**)
  - 🛑 Secret validity checks (***Unavailable for free plan**)
- Actions permissions

Run:
```bash
cd modules/github/public-repo/bin
bash ./main.sh
```

---

## 6. Next Steps


---
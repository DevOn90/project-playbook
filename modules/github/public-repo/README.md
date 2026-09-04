# Github Module - Public Repository

## ToC
1. [Introduction](#1-introduction)
2. [Scope](#2-scope)
3. [Repo Map](#3-repo-map)
4. [Pre-requisites](#4-pre-requisites)
5. [Repo Configuration](#5-repo-configuration)

---

## 1. Introduction

The `github/public-repo` module is responsible for setting up a public repository on GitHub for the public project. 

- Base settings
- Repository settings
- Security settings
- Actions settings
- Project settings

The settings are designed to ensure that the repository is configured for public access, with appropriate security measures in place. 

---

## 2. Scope

- public repository on GitHub `not private` repository

---

## 4. Pre-requisites

- Module `Bootstrap` executed successfully
- Module `Scaffold` executed successfully

---

## 5. Repo Configuration

- **Base**
  - ✅ Check if repository is public
  - ✅ Prompt to change description
  - 🛑 Prompt to change topics
- **Repository settings**
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
- **Advanced Security settings**
  - 🛑 Automatic dependency submission
  - ✅ Dependency graph
  - ✅ Dependabot alerts
  - ✅ Dependabot security updates
  - ✅ Dependabot malware alerts 🖐️ (***manual step** - no api available currently)
  - 🛑 Grouped security updates
  - 🛑 Dependabot version updates
  - ✅ Secret scanning                  
  - ✅ Secret scanning push protection  
  - ✅ Private vulnerability reporting
  - ✅ CodeQL
  - 🛑 Secret scanning generic/non-provider (***Unavailable for free plan**)
  - 🛑 Secret validity checks (***Unavailable for free plan**)
- **Actions permissions**
  - 🛑 Allow all actions and reusable workflows
  - 🛑 Disable actions
  - 🛑 Allow `<user>` actions and reusable workflows
  - ✅ Allow `<user>`, and select non-`<user>`, actions and reusable workflows
     - ✅ Allow actions created by GitHub
     - ✅ Allow actions by Marketplace verified creators
  - ✅ Require actions to be pinned to a full-length commit SHA
  - ✅ Artifact and log retention = 30 days
  - ✅ Cache retention = 7 days
  - ✅ Cache size eviction limit = 10 GB
  - 🛑 Require approval for first-time contributors who are new to GitHub
  - 🛑 Require approval for first-time contributors
  - ✅ Require approval for all external contributors 
  - 🛑 Workflow Read and write permissions
  - ✅ Workflow Read repository contents and packages permissions
  - 🛑 Allow GitHub Actions to create and approve pull requests
- **Project settings**
  - ✅ Project View Table (type `table`) updated
  - ✅ Project View Board (type `board`) created
  - ✅ Project View Backlog (type `table`) created
  - ✅ Project View Epic (type `table`) created
  - ✅ Project View Bugs (type `table`) created
  - ✅ Project View Roadmap (type `roadmap`) created
  - ✅ Project View Reoccurring (type `table`) created
  - ✅ Project Workflow `Auto-add sub-issues to project` (default settings)
  - ✅ Project Workflow `Auto-close issue` (default settings)
  - ✅ Project Workflow `Item Added to project` (default settings)
  - ✅ Project Workflow `Item Closed` (default settings)
  - ✅ Project Workflow `Pull request linked to issue` (default settings)
  - ✅ Project Workflow `Pull request merged` (default settings)
  - ✅ Project Workflow `Auto-add to project` 🖐️ (**manual step**)
  - 🛑 Project Workflow `Auto-archive items` (default settings)
  - 🛑 Project Workflow `Code changes requested` (default settings)
  - 🛑 Project Workflow `Code review approved` (default settings)
  - 🛑 Project Workflow `Item reopened` (default settings)

  ---
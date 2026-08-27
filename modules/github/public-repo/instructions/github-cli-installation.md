# Github CLI Installation

## Pre-requisites:
1. Open your Github user account

## Installation Steps:

Install GitHub CLI if not installed 
```bash
gh --version
```
Install GitHub CLI:
```bash
sudo apt update && sudo apt upgrade -y
sudo apt install gh
```
Validate
```bash
gh --version
```

## Authentication Steps:
Authenticate with GitHub CLI using the following command:
```bash
gh auth login
```
Select the account type you want to log into:
```text
? What account do you want to log into? [ Use arrows to move, type to filter]
> GitHub.com                  # Select this option if you want to log into GitHub.com
> Github Enterprise Server
``` 
Select preferred protocol for Git operations on this host:
```text
? What protocol do you want to use for Git operations? [ Use arrows to move, type to filter]
> HTTPS                      # Select this option if you want to use HTTPS for Git operations
> SSH
```
Select preferred authentication method:
```text
? How would you like to authenticate GitHub CLI? [ Use arrows to move, type to filter]
> Login with a web browser      # Select this option if you want to authenticate using a web browser
> Paste an authentication token
```
Expected output:
```text
! First copy your one-time code: 024B-6E0D
Press Enter to open github.com in your browser... 
```

In your Github user account, you will be prompted to enter the one-time code. Enter the code and `click Continue`.

You will be prompted to authorize GitHub CLI. Click `Authorize github-cli`.

Now you are authenticated with GitHub CLI. You can verify your authentication status by running the following command:
```bash
gh auth status
```
Expected output:
```text
github.com
  ✓ Logged in to github.com account DevOn90 (keyring)
  - Active account: true
  - Git operations protocol: https
  - Token: gho_************************************
  - Token scopes: 'gist', 'read:org', 'repo', 'workflow'     
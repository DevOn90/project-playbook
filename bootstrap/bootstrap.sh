#!/usr/bin/env bash

set -euo pipefail

## This is my pseudo code:
# 1. Prompt the user for a project name. - done
# 2. Prompt the user for a path where they want to create the project directory. - done
# 3. Let user confirm existance of GH repo for the project name. [n/Y] - done
# 4. if yes clone the repo, else ask to create a new repo and ask for repo existence again.
# 5. cd to the project directory.
# 6. Setup project environment.
# 6.1 Setup Git conf user.name and user.email for the new project.

# ---------------------------------------------------------
# Purpose: This script is designed to automate the setup of a new project environment. 
# Logic:
# 1. Prompt the user for a project name.
# 2. Prompt the user for a path where they want to create the project directory.
# 3. Let user confirm existence of GH repo for the project name. [n/Y]
# 4. If yes, clone the repo; else, ask to create a new repo and ask for repo existence again.
# 5. Change directory to the project directory.
# 6. Setup project environment.
# 6.1 Setup Git conf user.name and user.email for the new project.
# 6.2 Validate Git LFS installation and initialization in the repository.
# ---------------------------------------------------------

# ---------------------------------------------------------
# Global Variables
# ---------------------------------------------------------
PROJECT_NAME=""
TS=$(date +"%Y-%m-%d %H:%M:%S")
SCRIPT_NAME=$(basename "$0")
GH_USERNAME=""
GH_CONF_USER_NAME=""
GH_CONF_USER_EMAIL=""

# ---------------------------------------------------------
# 0. Function to log messages with different levels of severity
# ---------------------------------------------------------

log_info() {
  echo "[INFO][$TS][$SCRIPT_NAME] $1"
}

log_error() {
  echo "[ERROR][$TS][$SCRIPT_NAME] $1" >&2
}

log_warning() {
  echo "[WARNING][$TS][$SCRIPT_NAME] $1"
}

log_debug() {
  echo "[DEBUG][$TS][$SCRIPT_NAME] $1"
}

# ---------------------------------------------------------
# 1. Function to prompt the user for a project name
# ---------------------------------------------------------
prompt_project_name() {
  while true; do
    echo ""
    read -p "Enter the project name: " PROJECT_NAME

    # Validate empty input
    if [[ -z "$PROJECT_NAME" ]]; then
      log_error "Project name cannot be empty. Please try again."
      continue
    fi

    break
  done
  echo ""
  log_debug "Project name set to: $PROJECT_NAME"
}

# ---------------------------------------------------------
# 2. Function to prompt the user for a project path
# ---------------------------------------------------------
prompt_project_path() {
  echo ""
  read -p $'Provide the path where you want to create\nthe project directory (e.g. /home/user/Desktop ): ' PROJECT_PATH
  PROJECT_PATH=${PROJECT_PATH:-$(pwd)}
  echo ""
  
  # Validate the provided path
  if [[ ! -d "$PROJECT_PATH" ]]; then
    log_error "The provided path '$PROJECT_PATH' does not exist. Please provide a valid directory path."
    exit 1
  fi
  
  log_debug "Project path set to: $PROJECT_PATH"
}

# ---------------------------------------------------------
# 3. Function to prompt the user for GitHub username
# ---------------------------------------------------------
prompt_github_username() {
  echo ""
  read -p "Enter your GitHub username (default is 'gh-username'): " GH_USERNAME
  GH_USERNAME=${GH_USERNAME:-gh-username}
  echo ""
  log_debug "GitHub username set to: $GH_USERNAME"
} 

# ---------------------------------------------------------
# 4. Function to confirm the existence of a GitHub repository for the project name
# ---------------------------------------------------------
confirm_github_repo_existence() {
  echo ""
  read -p "Does a GitHub repository exist for the project '$PROJECT_NAME'? [n/Y]: " REPO_EXISTS
  echo ""
  REPO_EXISTS=${REPO_EXISTS:-Y}
  log_debug "User response for GitHub repository existence: $REPO_EXISTS"

  if [[ "$REPO_EXISTS" =~ ^[Yy]$ ]]; then
    log_debug "Validating the existence of the GitHub repository starts..."

    # Validate the existence of the GitHub repository using the GitHub API
    response=$(curl -s -o /dev/null -w "%{http_code}" \
    "https://api.github.com/repos/$GH_USERNAME/$PROJECT_NAME")
    
    if [[ "$response" == "200" ]]; then
      log_info "GitHub repository '$GH_USERNAME/$PROJECT_NAME' exists."
    else
      log_error "GitHub repository '$GH_USERNAME/$PROJECT_NAME' does not exist. Please create one and try again."
      exit 1
    fi

  else
    log_info "GitHub repository does not exist for the project '$PROJECT_NAME'. Please create one and try again."
    exit 1
  fi
}

# ---------------------------------------------------------
# 5. Function to clone the GitHub repository
# ---------------------------------------------------------
clone_github_repo() {
  echo ""
  log_info "Cloning the GitHub repository '$GH_USERNAME/$PROJECT_NAME'..."
  git clone "https://github.com/$GH_USERNAME/$PROJECT_NAME.git" "$PROJECT_PATH/$PROJECT_NAME"
}

# ---------------------------------------------------------
# 6. Function to prepare the project environment using the bootstrap script
# ---------------------------------------------------------

# 6.1 Setup Git configuration for the new project

prepare_project_environment() {
  echo ""
  log_info "Preparing the project environment..."
  
  # ---------------------------------------------------------
  # 6.1 Setup Git configuration for the new project
  # ---------------------------------------------------------
  log_info "Setting up Git configuration for the new project..."

  echo ""
  read -p "Enter your Git user.name for this project (default is 'me'): " GH_CONF_USER_NAME
  echo ""
  read -p "Enter your Git user.email for this project (default is 'me@example.com'): " GH_CONF_USER_EMAIL
  echo ""
  GH_CONF_USER_NAME=${GH_CONF_USER_NAME:-me}
  GH_CONF_USER_EMAIL=${GH_CONF_USER_EMAIL:-me@example.com}

  git config user.name "$GH_CONF_USER_NAME"
  git config user.email "$GH_CONF_USER_EMAIL"

  # Validate if the Git configuration was set successfully
  if [[ "$(git config user.name)" == "$GH_CONF_USER_NAME" && "$(git config user.email)" == "$GH_CONF_USER_EMAIL" ]]; then
    log_info "Git configuration set successfully for the project."
  else
    log_warning $'Failed to set Git configuration for the project.\nPlease assign the Git user.name and user.email manually using the following commands:\n\n  git config user.name "Your Name"\n  git config user.email "your.email@example.com"'
  fi

}

# 6.2 Validate Git LFS installation and initialization in the repository

validate_git_lfs() {

   # Check if Git LFS is installed on the local machine system
   if ! command -v git-lfs &> /dev/null; then
      log_warning $'Git LFS is not installed.\n
Please install Git LFS to manage large files in your repository\n
using git-lfs-installation-guide.'
      return 
   fi

   # Validate if Git LFS is initialized in the repository
   if ! git lfs install &> /dev/null; then
      log_warning $'Git LFS is not initialized in the repository.\n
Please run the following command to initialize Git LFS:\n  git lfs install'
      return
   fi
}
 

# ---------------------------------------------------------
# Main script execution
# ---------------------------------------------------------

main() {
    log_info "Bootstrap script started..."

    # Prompt for project name
    log_info "Prompting for project name..."
    prompt_project_name

    # Prompt for project path
    log_info "Prompting for project path..."
    prompt_project_path

    # Prompt for GitHub username
    log_info "Prompting for GitHub username..."
    prompt_github_username

    # Confirm GitHub repository existence
    log_info "Confirming GitHub repository existence..."
    confirm_github_repo_existence

    # Log the final project path
    log_info "Final project path: $PROJECT_PATH/$PROJECT_NAME"

    # Clone the GitHub repository
    log_info "Cloning the GitHub repository..."
    clone_github_repo

    # Validate if the project directory was created successfully
    if [[ -d "$PROJECT_PATH/$PROJECT_NAME" ]]; then
        log_info "Project directory '$PROJECT_PATH/$PROJECT_NAME' created successfully."
    else
        log_error "Failed to create project directory '$PROJECT_PATH/$PROJECT_NAME'."
        exit 1
    fi

    # Change directory to the project directory
    cd "$PROJECT_PATH/$PROJECT_NAME" || { log_error "Failed to change directory to '$PROJECT_PATH/$PROJECT_NAME'."; exit 1; }
    log_info "Changed directory to '$PROJECT_PATH/$PROJECT_NAME'."
    log_debug "Current working directory: $(pwd)"

    # Prepare the project environment
    log_info "Preparing the project environment..."
    prepare_project_environment

    # Validate Git LFS installation and initialization
    log_info "Validating Git LFS installation and initialization..."
    validate_git_lfs

    # Success message
    log_info "Bootstrap script completed successfully."

}

main
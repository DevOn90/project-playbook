#!/usr/bin/env bash

set -euo pipefail

# ---------------------------------------------------------
# Purpose: This script is designed to automate the setup of a new project environment. 
#
# Logic:
#        1. Set Global Variables
#        2. Create logging scripts
#        3. Prompt the user for a project name.
#        4. Prompt the user for a path where they want to create the project directory.
#        5. Let user confirm existence of GH repo for the project name. [n/Y]
#        6. If yes, clone the repo; else, ask to create a new repo and ask for repo existence again.
#        7. Change directory to the project directory.
#        8. Setup project environment.
#        8.1 Setup Git conf user.name and user.email for the new project.
#        8.2 Validate Git LFS installation and initialization in the repository.
#        8.3 Validate local installation of uv (Astral).
#        8.4 Set custom git config hookpath
#        9. Main function
# ---------------------------------------------------------

# ---------------------------------------------------------
# 1. Global Variables
# ---------------------------------------------------------
PROJECT_NAME=""
TS=$(date +%Y-%m-%dT%H:%M:%S)

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd -- "$SCRIPT_DIR/../" && pwd)"
SCRIPT_NAME="$(basename -- "${BASH_SOURCE[0]}")"
GIT_HOOK_PATH=".githooks"

GH_USERNAME=""
GH_CONF_USER_NAME=""
GH_CONF_USER_EMAIL=""

# ---------------------------------------------------------
# 2. Logging Scripts
# ---------------------------------------------------------

log_info() {
    script_name="$(basename "${BASH_SOURCE[1]}")"
    echo -e "\033[1;34m[INFO][$TS][$script_name] \033[0m $1"
}

log_error() {
    script_name="$(basename "${BASH_SOURCE[1]}")"
    echo -e "\033[1;31m[ERROR][$TS][$script_name] \033[0m $1"
} 

log_warning() {
    script_name="$(basename "${BASH_SOURCE[1]}")"
    echo -e "\033[1;33m[WARNING][$TS][$script_name] \033[0m $1"
}

log_debug() {
    script_name="$(basename "${BASH_SOURCE[1]}")"
    echo -e "\033[1;36m[DEBUG][$TS][$script_name] \033[0m $1"
}

# ---------------------------------------------------------
# 3. Function to prompt the user for a project name
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
}

# ---------------------------------------------------------
# 4. Function to prompt the user for a project path
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

  # Store the final project path in temp file
  echo "$PROJECT_PATH" > "$PROJECT_ROOT/temp/.project_dir_path_temp"
  
}

# ---------------------------------------------------------
# 5. Function to prompt the user for GitHub username
# ---------------------------------------------------------
prompt_github_username() {
  echo ""
  read -p "Enter your GitHub username (default is 'gh-username'): " GH_USERNAME
  GH_USERNAME=${GH_USERNAME:-gh-username}
  echo ""
} 

# ---------------------------------------------------------
# 6. Function to confirm the existence of a GitHub repository for the project name
# ---------------------------------------------------------
confirm_github_repo_existence() {
  echo ""
  read -p "Does a GitHub repository exist for the project '$PROJECT_NAME'? [n/Y]: " REPO_EXISTS
  echo ""
  REPO_EXISTS=${REPO_EXISTS:-Y}

  if [[ "$REPO_EXISTS" =~ ^[Yy]$ ]]; then

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
# 7. Function to clone the GitHub repository
# ---------------------------------------------------------
clone_github_repo() {
  echo ""
  log_info "Cloning the GitHub repository '$GH_USERNAME/$PROJECT_NAME'..."
  git clone "https://github.com/$GH_USERNAME/$PROJECT_NAME.git" "$PROJECT_PATH/$PROJECT_NAME"
}

# ---------------------------------------------------------
# 8. Function to prepare the project environment using the bootstrap script
# ---------------------------------------------------------

# 8.1 Setup Git configuration for the new project

prepare_project_environment() {
  echo ""
  log_info "Preparing the project environment..."
  
  # ---------------------------------------------------------
  # 8.2 Setup Git configuration for the new project
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

# 8.2 Validate Git LFS installation and initialization in the repository

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

# 8.3 Validate local installation of uv (Universal Viewer)

validate_uv_installation() {
   
   # Validate if uv (Astral) is installed on the local machine system
   if ! command -v uv &> /dev/null; then
      log_warning $'uv (Astral) is not installed.\n
Please install uv to view various file formats in your repository\n
using uv-installation-guide.'
      return
   fi

   # Validate if uv is installed on user-specific path /home/user/.local/bin/uv
   if [[ ! -f "$HOME/.local/bin/uv" ]]; then
      log_warning $'uv (Astral) is not installed in the user-specific path.\n
Please install uv in the user-specific path /home/user/.local/bin/uv\n
using uv-installation-guide.'
      return
   fi 
}

# 8.4 Set custom git config hookpath
set_custom_git_hookpath() {
    
    # If the current git config hookpath is not equal to the desired GIT_HOOK_PATH, set it to the desired value
    if [[ "$(git config --get core.hooksPath)" != "$GIT_HOOK_PATH" ]]; then
        log_info "Setting custom git config hookpath to '$GIT_HOOK_PATH'..."
        git config core.hooksPath "$GIT_HOOK_PATH"
        log_info "Git config hookpath set to '$GIT_HOOK_PATH' successfully."
    else
        log_info "Git config hookpath is already set to '$GIT_HOOK_PATH'."
        return
    fi
}
 

# ---------------------------------------------------------
# 9. Main function
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

    # Prepare the project environment
    log_info "Preparing the project environment..."
    prepare_project_environment

    # Validate Git LFS installation and initialization
    log_info "Validating Git LFS installation and initialization..."
    validate_git_lfs

    # Validate local installation of uv (Universal Viewer)
    log_info "Validating local installation of uv (Universal Viewer)..."
    validate_uv_installation

    # Set custom git config hookpath
    set_custom_git_hookpath
    
    # Success message
    log_info "Bootstrap script completed successfully."

}

main "$@"
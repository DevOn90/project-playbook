#!/usr/bin/env bash

set -euo pipefail

## This is my pseudo code:
# 1. ask user for project name
# 2. create a new directory with the project name
# 3. Prepare an project environment using the bootstrap script
# 3.1 Git config 

# ---------------------------------------------------------
# Purpose: This script is designed to automate the setup of a new project environment. It will prompt the user for a project name, create a corresponding directory, and prepare the project environment using the bootstrap script.
# ---------------------------------------------------------

# ---------------------------------------------------------
# Global Variables
# ---------------------------------------------------------
PROJECT_NAME=""
TS=$(date +"%Y-%m-%d %H:%M:%S")
SCRIPT_NAME=$(basename "$0")

# ---------------------------------------------------------
# Function to log messages with different levels of severity
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
# Function to prompt the user for a project name
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
# Function to create a new directory with the project name
# ---------------------------------------------------------

create_project_directory() {
  echo ""
  read -p "Provide the path where you want to create the project directory (default is current directory): " PROJECT_PATH
  PROJECT_PATH=${PROJECT_PATH:-$(pwd)}
  mkdir -p "$PROJECT_PATH/$PROJECT_NAME"
  echo ""
  log_info "Project directory '$PROJECT_PATH/$PROJECT_NAME' created successfully."
}

# ---------------------------------------------------------
# Function to prepare the project environment using the bootstrap script
# ---------------------------------------------------------
prepare_project_environment() {
  echo ""
  # Setting up Git configuration for the new project
  log_info "Preparing project environment..."


# ---------------------------------------------------------
# Main script execution
# ---------------------------------------------------------

main() {
    log_info "Bootstrap script started..."
    
    # Prompt for project name
    log_info "Prompting for project name..."
    prompt_project_name
    
    
    # Create project directory
    log_info "Creating project directory..."
    create_project_directory
   
    # Go to the project directory
    log_info "Changing directory to the project directory..."
    cd "$PROJECT_PATH/$PROJECT_NAME" || { log_error "Failed to change directory to '$PROJECT_PATH/$PROJECT_NAME'"; exit 1; }
    log_debug "Changed directory to: $(pwd)"

    # Prepare project environment
    log_info "Preparing project environment..."
    prepare_project_environment
}

main
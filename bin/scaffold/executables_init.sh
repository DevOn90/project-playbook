#!/usr/bin/env bash

set -euo pipefail

# ---------------------------------------------------------
# Purpose: This script is used to make the executable files in the scaffold directory executable
#           as per the template in `./templates/executables`.
# Logic:
# 1. Define global variables
# 2. Set logging functions
# 3. Set helper function for script Usage
# 4. Argument parsing
# 5. Validate arguments
# 6. Template parser to read the template file and execute chmod commands
# 7. Main function to orchestrate the script's execution
# ---------------------------------------------------------

# ---------------------------------------------------------
# Variables
# ---------------------------------------------------------
SCRIPT_NAME=$(basename "$0")
TS=$(date +%Y-%m-%dT%H:%M:%S)

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

TEMPLATE_FILE=""
DRY_RUN=false
TARGET_ROOT=""


# ---------------------------------------------------------
# 2. Logging functions
# ---------------------------------------------------------

log_info() {
    echo "[INFO][$TS][$SCRIPT_NAME] $1"
}

log_error() {
    echo "[ERROR][$TS][$SCRIPT_NAME] $1"
}

log_warning() {
    echo "[WARNING][$TS][$SCRIPT_NAME] $1"
}

log_debug() {
    echo "[DEBUG][$TS][$SCRIPT_NAME] $1"
}

# ---------------------------------------------------------
# 3. Helpers
# ---------------------------------------------------------
 
show_help() {

cat << EOF
Usage: $SCRIPT_NAME --template <template-file> --path <destination-path> [options] 

Required arguments:

    --template <path>
        Full path to executables template file.
    --path <path>
        Full path to the destination directory root where the executables will be made executable.     

Options:
    --help        Show this help message and exit
    --dry-run     Show what would be copied without copying. 
EOF
}

# ---------------------------------------------------------
# 4. Argument parser
# ---------------------------------------------------------

argument_parser() {

    while [[ $# -gt 0 ]]; do
        case "$1" in
            --template)
                TEMPLATE_FILE="$2"
                shift 2
                ;;
            --path)
                TARGET_ROOT="$2"
                shift 2
                ;; 
            --dry-run)
                DRY_RUN=true
                shift 1
                ;;
            --help)
                show_help
                exit 0
                ;;
            *)
                log_error "Unknown argument: $1"
                show_help
                exit 1
                ;;
        esac
    done
}

# ---------------------------------------------------------
# 5. Validate arguments
# ---------------------------------------------------------

validate_template_file() {

    # Validate that the template file exists
    if [[ ! -f "$TEMPLATE_FILE" ]]; then
        log_error "Template file not found: $TEMPLATE_FILE"
        exit 1
    fi

    # Validate that the template file variable is not empty
    if [[ -z "$TEMPLATE_FILE" ]]; then
        log_error "Template file is empty: $TEMPLATE_FILE"
        exit 1
    fi
}

validate_target_root() {

    # Validate that the target root directory exists
    if [[ ! -d "$TARGET_ROOT" ]]; then
        log_error "Target root directory not found: $TARGET_ROOT"
        exit 1
    fi

    # Validate that the target root directory variable is not empty
    if [[ -z "$TARGET_ROOT" ]]; then
        log_error "Target root directory is empty: $TARGET_ROOT"
        exit 1
    fi
}

# ---------------------------------------------------------
# 6. Template parser
# ---------------------------------------------------------

template_parser() {

    # Read the template file line by line and execute chmod commands
    while IFS= read -r line; do
     
        # Skip empty lines
        [[ -z "$line" ]] && continue

        # Skip comments
        [[ "$line" =~ ^# ]] && continue

        # split token and path to handle extra whitespace reliably
        read -r tag exec_path <<< "$line"

        if [[ "$tag" == "@exec" && -n "$exec_path" ]]; then

            # construct full path
            local full_exec_path="$TARGET_ROOT/$exec_path"

            log_debug "Full executable path: $full_exec_path"

            if [[ ! -f "$full_exec_path" ]]; then
                log_error "Executable file not found: $full_exec_path"
                exit 1
            fi

            if [[ "$DRY_RUN" == true ]]; then
                log_info "DRY-RUN: Would make executable: $full_exec_path"
            else
                chmod +x "$full_exec_path"
                log_info "Made executable: $full_exec_path"
                log_debug "Check ownership $(ls -ltr "$full_exec_path")"
            fi

        else
            log_warning "Invalid line in template: $line"
        fi
    
    done < "$TEMPLATE_FILE"

}
  
# ---------------------------------------------------------
# 7. Main
# ---------------------------------------------------------

main() {

    # If no arguments provided, show help and exit
    if [[ $# -eq 0 ]]; then
        show_help
        exit 0
    fi

    log_info "Starting script: $SCRIPT_NAME ..."
    argument_parser "$@"

    log_info "Validating arguments ..."
    validate_template_file
    validate_target_root
    
    log_info "Arguments validated successfully."
    
    log_info "Template file: $TEMPLATE_FILE"
    log_info "Target root directory: $TARGET_ROOT"
    log_info "Dry-run mode: $DRY_RUN"
    
    log_info "Processing template file ..."
    template_parser

    log_info "Script completed successfully."
}
 
main "$@"

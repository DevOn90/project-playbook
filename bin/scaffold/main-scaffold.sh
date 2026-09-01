#!/usr/bin/env bash

# ============================================================
# Purpose: This script is used to scaffold a project structure based on predefined templates. 
#          It ensures that the necessary directories and files are created, and it also stages,
#          commits, and pushes the changes to a Git repository.
#
# Logic: 
#        1. Set Global Variables
#        2. Create logging scripts
#        3. Validate Templates existance
#        4. Scaffold Project
#        5. Main
# ============================================================

set -euo pipefail

# ============================================================
# 1. Set Global Variables
# ============================================================

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd -- "$SCRIPT_DIR/../../" && pwd)"
SCRIPT_NAME="$(basename -- "${BASH_SOURCE[0]}")"

TS=$(date +%Y-%m-%dT%H:%M:%S)

declare -a SCAFFOLD_TEMPLATES=(
    "$PROJECT_ROOT/templates/scaffold/project-root-scaffold-template.txt"
    "$PROJECT_ROOT/templates/scaffold/project-docs-scaffold-template.txt"
    "$PROJECT_ROOT/templates/scaffold/project-infra-scaffold-template.txt"
    "$PROJECT_ROOT/templates/scaffold/project-logs-scaffold-template.txt"
    "$PROJECT_ROOT/templates/scaffold/project-scripts-scaffold-template.txt"
)

declare BINARY_TEMPLATE="$PROJECT_ROOT/templates/scaffold/binary/binary-root-scaffold-template.txt"
declare EXECUTABLE_TEMPLATE="$PROJECT_ROOT/templates/executables/project-executables-template.txt"

# ============================================================
# 2. Create logging scripts
# ============================================================

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

# ============================================================
# 3. Validate Templates existance
# ============================================================

is_templates_exists() {

    local template

    log_info "Validating templates existance"

    # Validate scaffold templates
    for template in "${SCAFFOLD_TEMPLATES[@]}"; do
        if [[ ! -f "$template" ]]; then
            log_error "Template file '$template' does not exist. Please ensure all required templates are present."
            exit 1
        else
            log_info "Template file '$template' exists."
        fi    
    done

    # Validate binary template
    if [[ ! -f "$BINARY_TEMPLATE" ]]; then
        log_error "Binary template file '$BINARY_TEMPLATE' does not exist. Please ensure the binary template is present."
        exit 1
    else
        log_info "Binary template file '$BINARY_TEMPLATE' exists."
    fi

    # Validate executable template
    if [[ ! -f "$EXECUTABLE_TEMPLATE" ]]; then
        log_error "Executable template file '$EXECUTABLE_TEMPLATE' does not exist. Please ensure the executable template is present."
        exit 1
    else
        log_info "Executable template file '$EXECUTABLE_TEMPLATE' exists."
    fi    
}

# ============================================================
# 4. Scaffold Project
# ============================================================

scaffold_project() {

    log_info "Scaffolding project structure..."

    local scaffolding_script="$PROJECT_ROOT/bin/scaffold/scaffold_project.sh"
    local binary_script="$PROJECT_ROOT/bin/scaffold/binary_scaffold.sh"
    local executable_script="$PROJECT_ROOT/bin/scaffold/executables_init.sh"
    local path_to_project="$(cat "$PROJECT_ROOT/temp/.project_dir_path_temp")"
    local template
    
    # Construct repo information for get default branch for git push 
    local github_user="$(gh api user --jq '.login')"
    local repo_name="$(basename "$path_to_project")"
    local full_repo_name="$github_user/$repo_name"  
    local default_branch="$(gh api repos/"$full_repo_name" --jq '.default_branch')"

    # Validate temporary files with existence
    if [[ -n "$path_to_project" ]]; then
       log_info "Scaffolding project at path: $path_to_project"
    else
       log_error "Project path is empty. Please ensure the project path is set correctly."
       log_error "Check temp file at $PROJECT_ROOT/temp/* and/or script $PROJECT_ROOT/bin/bootstrap/main-bootstrap.sh func 04 for issues."
       exit 1
    fi

    # Loop through each template and scaffold the project 
    for template in "${SCAFFOLD_TEMPLATES[@]}"; do
        if [[ -f "$template" ]]; then
            log_info "Scaffolding using template: $template"
            bash "$scaffolding_script" --template "$template" --path "$path_to_project"

            # Git stage after each scaffolding step
            log_info "Staging changes for template: $template"
            git -C "$path_to_project" add .

            # Git commit after each scaffolding step
            log_info "Committing changes for template: $template"
            git -C "$path_to_project" commit -m "Scaffolded project structure using template: $(basename "$template")"

            # Git push after each scaffolding step
            log_info "Pushing changes to remote repository for template: $template"
            git -C "$path_to_project" push -u origin "$default_branch"

        else
            log_error "Template file '$template' does not exist. Please ensure all required templates are present."
            exit 1
        fi
    done

    # Scaffold binary structure
    if [[ -f "$BINARY_TEMPLATE" ]]; then
        log_info "Scaffolding binary structure using template: $BINARY_TEMPLATE"
        bash "$binary_script" --template "$BINARY_TEMPLATE" --path "$path_to_project"

        # Git stage after scaffolding binary structure
        git -C "$path_to_project" add .

        # Git commit after scaffolding binary structure
        git -C "$path_to_project" commit -m "Scaffolded binary structure using template: $(basename "$BINARY_TEMPLATE")"

        # Git push after scaffolding binary structure
        git -C "$path_to_project" push -u origin "$default_branch"

    else
        log_error "Binary template file '$BINARY_TEMPLATE' does not exist. Please ensure the binary template is present."
        exit 1
    fi

    # Scaffold executable structure
    if [[ -f "$EXECUTABLE_TEMPLATE" ]]; then
        log_info "Scaffolding executable structure using template: $EXECUTABLE_TEMPLATE"
        bash "$executable_script" --template "$EXECUTABLE_TEMPLATE" --path "$path_to_project"

        # Git stage after scaffolding executable structure
        git -C "$path_to_project" add .

        # Git commit after scaffolding executable structure
        git -C "$path_to_project" commit -m "Scaffolded executable structure using template: $(basename "$EXECUTABLE_TEMPLATE")"

        # Git push after scaffolding executable structure
        git -C "$path_to_project" push -u origin "$default_branch"

    else
        log_error "Executable template file '$EXECUTABLE_TEMPLATE' does not exist. Please ensure the executable template is present."
        exit 1
    fi
}
 
# ============================================================
# X. Main
# ============================================================

main() {
   
   log_info "Starting project scaffolding process..."
   
   is_templates_exists
   scaffold_project

    log_info "Project scaffolding process completed successfully..."
}

main "$@"


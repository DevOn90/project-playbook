#!/usr/bin/env bash

# ============================================================
# Purpose: This script is designed to automate the process of creating a new
#          Angular project, scaffolding its structure, and committing 
#          the changes to a Git repository. It also includes validation 
#          for Google Chrome installation, which is required for running 
#          Angular tests.
# Logic:
#        1. Set Global Variables
#        2. Create logging scripts
#        3. Validate Google Chrome installation
#        4. Remove 'front-end' provisioning directory
#        5. Create new Angular project
#        6. Scaffold Angular project structure
#        7. Update package.json
#        8. Set up project code quality tools
#        9. Test tools
#        X. Main function to orchestrate the above steps
# ============================================================

set -euo pipefail

# ============================================================
# 1. Set Global Variables
# ============================================================

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
MODULE_ROOT="$(cd -- "${SCRIPT_DIR}/../" && pwd)"
PROJECT_ROOT="$(cd -- "${SCRIPT_DIR}/../../../" && pwd)"
SCRIPT_NAME="$(basename -- "${BASH_SOURCE[0]}")"

FRONT_END_NAME="apps/front-end"

TS=$(date +%Y-%m-%dT%H:%M:%S)

# Construct repo information for get default branch for git push 
PATH_TO_PROJECT="$(cat "${PROJECT_ROOT}/temp/.project_dir_path_temp")"
GITHUB_USER="$(gh api user --jq '.login')"
REPO_NAME="$(basename "$PATH_TO_PROJECT")"
FULL_REPO_NAME="${GITHUB_USER}/${REPO_NAME}"  
DEFAULT_BRANCH="$(gh api repos/"${FULL_REPO_NAME}" --jq '.default_branch')"

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
# 3. Validate Google Chrome installation
# ============================================================

is_chrome_installed() {
    if command -v google-chrome >/dev/null 2>&1; then
        return 0
    else
        return 1
    fi
}

# ============================================================
# 4. Remove 'front-end' provisioning directory
# ============================================================

remove_front_end_provisioning() {

    log_info "Removing 'front-end' provisioning directory..."
     
    local project_directory="$(cat "${PROJECT_ROOT}/temp/.project_dir_path_temp")"
    local front_end_directory="${project_directory}/${FRONT_END_NAME}"

    # Check if the front-end directory exists
    if [ -d "$front_end_directory" ]; then
        log_info "Found 'front-end' directory at $front_end_directory."
    else
        log_error "'front-end' directory does not exist. Check manually at $front_end_directory."
        return 1
    fi

    # Change directory to the front-end directory, validate the change & remove the directory
    if cd "$front_end_directory"; then
   
        # Log the current directory after changing to the front-end directory
        log_info "Successfully changed directory to $front_end_directory."
        local current_directory="$(pwd)"
        log_info "Current directory (PWD): $current_directory"
   
        # Remove the front-end directory
        rm -rf "$front_end_directory"
        log_info "Successfully removed 'front-end' provisioning directory."

        # Check if the front-end directory still exists after removal
        if [ ! -d "$front_end_directory" ]; then
            log_info "'front-end' directory has been successfully removed."
        else
            log_error "Failed to remove 'front-end' directory. Check manually at $front_end_directory."
            return 1
        fi
    else
        log_error "Failed to change directory to $front_end_directory. Check manually."
        return 1
    fi
}

# ============================================================
# 5. Create new Angular project
# ============================================================

create_new_angular_project() {

    log_info "Creating new Angular project..."

    # Navigate to the 'apps' directory & create a new Angular project named 'front-end'
    local apps_directory="${PATH_TO_PROJECT}/apps"
    if cd "$apps_directory"; then
        log_info "Successfully changed directory to $apps_directory."

        local current_directory="$(pwd)"
        log_info "Current directory (PWD): $current_directory"

        # Check if angular CLI is installed
        if ! command -v ng &> /dev/null; then
            log_error "Angular CLI is not installed. Please install it using 'npm install -g @angular/cli' and try again."
            return 1
        fi

        # Create a new Angular project named 'front-end'
        if ng new "$(basename "$FRONT_END_NAME")" \
            --style=scss \
            --ssr=false \
            --zoneless=false ; then
            log_info "Successfully created new Angular project 'front-end'."
        
            # Commit & push the changes to the repository
            git add .
            git commit -m "feat: Create new Angular project 'front-end'"
            git push -u origin "$DEFAULT_BRANCH"
            log_info "Changes committed and pushed to the repository."
        
        else
            log_error "Failed to create new Angular project 'front-end'. Check manually."
            return 1
        fi           
    
    else
        log_error "Failed to change directory to $apps_directory. Check manually."
        return 1
    fi

}

# ============================================================
# 6. Scaffold Angular project structure 
# ============================================================

scaffold_angular_project_structure() {

    log_info "Scaffolding Angular project structure..."

    local front_end_directory="${PATH_TO_PROJECT}/${FRONT_END_NAME}"
    local scaffold_script="${PROJECT_ROOT}/bin/scaffold/scaffold_project.sh"
    local scaffold_template="${PROJECT_ROOT}/modules/angular/templates/ng-custom-folder-structure.txt"
    
    bash "$scaffold_script" --template "$scaffold_template" --path "$front_end_directory"

    log_info "Successfully scaffolded Angular project structure."

    log_info "Committing and pushing scaffolded structure to the repository..."

    
    # Change directory to the front-end directory before committing
    if cd "$front_end_directory"; then
        log_info "Successfully changed directory to $front_end_directory."
    
        # Log the current directory after changing to the front-end directory
        local current_directory="$(pwd)"
        log_info "Current directory (PWD): $current_directory"

        # Commit & push the changes to the repository 
        git add .
        git commit -m "chore: Scaffold Angular project structure"   
        git push -u origin "$DEFAULT_BRANCH"
    
    else
        log_error "Failed to change directory to $front_end_directory. Check manually."
        return 1
    fi
}

# ============================================================
# 7. Update package.json
# ============================================================

# Update package.json with scripts and metadata for Angular project

update_package_json() {

    log_info "Updating package.json with scripts and metadata for Angular project..."    

    # Navigate to the front-end directory
    local front_end_directory="${PATH_TO_PROJECT}/${FRONT_END_NAME}"
    if cd "$front_end_directory"; then
        log_info "Successfully changed directory to $front_end_directory."
    
        # Prompt for angular project description
        echo ""
        echo "Description example: A front-end application built with Angular."
        read -r -p "Enter a description for the Angular project: " description 
        echo ""

        # Prompt for angular project license
        echo ""
        echo "License example: MIT, Apache-2.0, GPL-3.0, etc."
        read -r -p "Enter a license for the Angular project: " license
        echo ""

        # Prompt for angular project version
        echo ""
        echo "Version example: 1.0.0, 0.1.0, 2.0.0, etc."
        read -r -p "Enter a version for the Angular project: " version
        echo ""
        
        # Declare local variables to hold values for package.json updates 
        ## Metadata
        local version="$version"
        local description="$description"
        local private="true"     # Prevents accidental publication to npm registry
        local author_name="$(git config user.name)"
        local author_email="$(git config user.email)"
        local license="$license"
        local engines_node="^$(node --version)"
        local engines_vscode="^$(code --version | head -n 1)"
        local repository_type="git"
        local repository_url="$(git config --get remote.origin.url)"
        ## Scripts
        local script_format="prettier --write ."
        local script_format_check="prettier --check ."
        local script_lint="ng lint"
        local lint_fix="ng lint --fix"
        local script_test="ng test"
        local script_test_watch="ng test --watch"
        local script_test_ci="ng test --watch=false --browsers=ChromeHeadless"
        local script_test_coverage="ng test --watch=false --code-coverage --browsers=ChromeHeadless"
        local script_build="ng build"
        local script_build_prod="ng build --configuration production"

        # Update package.json using jq to add scripts and metadata 
        jq \
        --arg script_format "$script_format" \
        --arg script_format_check "$script_format_check" \
        --arg script_lint "$script_lint" \
        --arg lint_fix "$lint_fix" \
        --arg script_test "$script_test" \
        --arg script_test_watch "$script_test_watch" \
        --arg script_test_ci "$script_test_ci" \
        --arg script_test_coverage "$script_test_coverage" \
        --arg script_build "$script_build" \
        --arg script_build_prod "$script_build_prod" \
        --arg version "$version" \
        --arg description "$description" \
        --argjson private "$private" \
        --arg author_name "$author_name" \
        --arg author_email "$author_email" \
        --arg license "$license" \
        --arg engines_node "$engines_node" \
        --arg engines_vscode "$engines_vscode" \
        --arg repository_type "$repository_type" \
        --arg repository_url "$repository_url" \
        ".scripts.format=\"$script_format\" \
        | .scripts.\"format:check\"=\"$script_format_check\" \
        | .scripts.lint=\"$script_lint\" \
        | .scripts.\"lint:fix\"=\"$lint_fix\" \
        | .scripts.test=\"$script_test\" \
        | .scripts.\"test:watch\"=\"$script_test_watch\" \
        | .scripts.\"test:ci\"=\"$script_test_ci\" \
        | .scripts.\"test:coverage\"=\"$script_test_coverage\" \
        | .scripts.build=\"$script_build\" \
        | .scripts.\"build:prod\"=\"$script_build_prod\" \
        | .version=\"$version\" \
        | .description=\"$description\" \
        | .private=$private \
        | .author.name=\"$author_name\" \
        | .author.email=\"$author_email\" \
        | .license=\"$license\" \
        | .engines.node=\"$engines_node\" \
        | .engines.vscode=\"$engines_vscode\" \
        | .repository.type=\"$repository_type\" \
        | .repository.url=\"$repository_url\"
        " \
        package.json > package.json.temp
        mv package.json.temp package.json
        rm -f package.json.temp
    else
        log_error "Failed to change directory to $front_end_directory. Check manually."
        return 1
    fi

    # Commit & push the changes to the repository
    git add package.json
    git commit -m "chore: Update package.json with scripts and metadata"
    git push -u origin "$DEFAULT_BRANCH"   
}

# ============================================================
# 8. Set up project code quality tools
# ============================================================

setup_code_quality_tools() {

    log_info "Setting up project code quality tools..."

    # Navigate to the front-end directory
    local front_end_directory="${PATH_TO_PROJECT}/${FRONT_END_NAME}"
    if cd "$front_end_directory"; then
        log_info "Successfully changed directory to $front_end_directory." 
    
        # Install Prettier
        npm install --save-dev prettier
        log_info "Prettier installed successfully."

        # Install ESLint
        ng add angular-eslint --skip-confirmation
        log_info "ESLint installed successfully."

        # Commit & push the changes to the repository
        git add \
            angular.json \
            package.json \
            eslint.config.js \
            package-lock.json

        git commit -m "chore: Set up project code quality tools (Prettier & ESLint)"
        git push -u origin "$DEFAULT_BRANCH"
    
    else
        log_error "Failed to change directory to $front_end_directory. Check manually."
        return 1
    fi 
}

# ============================================================
# 9. Test tools
# ============================================================

test_tools() {

    log_info "Testing code quality tools..."

    # Navigate to the front-end directory
    local front_end_directory="${PATH_TO_PROJECT}/${FRONT_END_NAME}"
    if cd "$front_end_directory"; then
        log_info "Successfully changed directory to $front_end_directory."
    
        # Test Prettier, ESLint, Angular tests, and build process
        log_info "Running Prettier check..."
        if ! npm run format:check; then
           # I need results to stdout, but not to fail the script,
           # so just log the error and continue
           log_warning "Prettier check failed. Please fix formatting issues."  
        fi 

        log_info "Running ESLint check..."
        npm run lint

        log_info "Running Angular tests ci..."
        npm run test:ci

        log_info "Running Angular tests coverage..."
        npm run test:coverage

        log_info "Running Angular build..."
        if npm run build; then
            log_info "Angular build completed successfully."

            # Remove the 'dist' directory after successful build
            local dist_directory="${front_end_directory}/dist"
            if [ -d "$dist_directory" ]; then
                rm -rf "$dist_directory"
                log_info "'dist' directory removed successfully after build."
            fi
        else
            log_error "Angular build failed. Check the logs for details."
            return 1
        fi
    
    else
        log_error "Failed to change directory to $front_end_directory. Check manually."
        return 1
    fi
}
  
# ============================================================
# X. Main
# ============================================================

main() {

    log_info "Starting Angular build process..."
    
    # 3. Validate Google Chrome installation
    log_info "Checking if Google Chrome is installed..."   
    if is_chrome_installed; then
        log_info "Google Chrome is installed."
    else
        log_warning "Google Chrome is not installed. It is default browser for running Angular tests. Please install Google Chrome to run tests."
    fi

    # 4. Remove 'front-end' provisioning directory
    remove_front_end_provisioning

    # 5. Create new Angular project
    create_new_angular_project
    
    # 6. Scaffold Angular project structure
    scaffold_angular_project_structure

    # 7. Update package.json
    update_package_json

    # 8. Set up project code quality tools
    setup_code_quality_tools

    # 9. Test tools
    test_tools

    log_info "Angular build process completed successfully."
}

main "$@"
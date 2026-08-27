#!/usr/bin/env bash

# ============================================================
# Purpose: This script is the main orchestrator for project-playbook.
#          It allows users to select and execute specific modules based on their needs.
# Components:
#       1. Set Global Variables
#       2. Create logging scripts
#       3. Usage function (--help)
#       4. Module selection function
#       5. Parse arguments
#       6. Run module function
#       7. Main function
# ============================================================

set -euo pipefail

# ============================================================
# 1. Set Global Variables
# ============================================================

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd -- "$SCRIPT_DIR/../" && pwd)"
SCRIPT_NAME="$(basename -- "${BASH_SOURCE[0]}")"

SELECTED_MODULES=()

TS=$(date +%Y-%m-%dT%H:%M:%S)

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
# 3. Usage function  (--help)   
# ============================================================

usage() {

    cat <<EOF

Usage:
  $(basename "$0") [options]

Options:
  --module <name>    Select a module to execute.
  --help             Show this help.

Available modules:
  bootstrap       (Local project environment setup)
  scaffold        (Project scaffolding)
  angular
  github/public-repo
  graphql     --> Unlock it once available 
  spring-boot --> Unlock it once available
  storybook   --> Unlock it once available
  wiremock    --> Unlock it once available

Examples:
  $(basename "$0") --module angular
  $(basename "$0") --module angular --module wiremock
  $(basename "$0") --module github/public-repo

For more information, visit the project-playbook documentation at README.md.

EOF
}

# ============================================================
# 4. Module selection function
# ============================================================
 
select_module() {

    local module="$1"

    case "$module" in
        bootstrap)
            SELECTED_MODULES+=("bootstrap")
            ;;

        scaffold)
            SELECTED_MODULES+=("scaffold")
            ;;
        
        angular)
            SELECTED_MODULES+=("angular")
            ;;
        
        github/public-repo)
            SELECTED_MODULES+=("github/public-repo")
            ;;
        graphql)
            SELECTED_MODULES+=("graphql")
            ;;
        spring-boot)
            SELECTED_MODULES+=("spring-boot")
            ;;
        storybook)
            SELECTED_MODULES+=("storybook")
            ;;
        wiremock)
            SELECTED_MODULES+=("wiremock")
            ;;
        *)
            log_error "Unknown module: $module"
            log_error "Use --help to see available modules"
            exit 1
            ;;
    esac
}

# ============================================================
# 5. Parse arguments   
# ============================================================

parse_arguments() {

    log_info "Parsing arguments in $SCRIPT_NAME"
       
    while [[ $# -gt 0 ]];do
        case "$1" in

           --module)
              if [[ $# -lt 2 ]];then
                 log_error "Module name is missing after --module"
                 exit 1
              fi

              select_module "$2"
              shift 2
              ;;

            --help)
              usage
              exit 0
              ;;

            *)
              log_error "Unknown option: $1"
              log_error "Use --help to see available options"
              exit 1
              ;;

        esac
    done
}

# ============================================================
# 6. Run Module Function
# ============================================================

run_module() {

    local module="$1"
    local module_entrypoint

    case "$module" in
        bootstrap)
            module_entrypoint="$PROJECT_ROOT/bootstrap/main-bootstrap.sh"
            ;;

        scaffold)
            module_entrypoint="$PROJECT_ROOT/bin/scaffold/main-scaffold.sh"
            ;;
        
        angular)
            module_entrypoint="$PROJECT_ROOT/modules/angular/bin/main-angular.sh"
            ;;
        
        github/public-repo)
            module_entrypoint="$PROJECT_ROOT/modules/github/public-repo/bin/main-gh-public.sh"
            ;;
        
        graphql)
            module_entrypoint="$PROJECT_ROOT/modules/graphql/bin/main-graphql.sh"
            ;;
        
        spring-boot)
            module_entrypoint="$PROJECT_ROOT/modules/spring-boot/bin/main-spring-boot.sh"
            ;;
        
        storybook)
            module_entrypoint="$PROJECT_ROOT/modules/storybook/bin/main-storybook.sh"
            ;;
        
        wiremock)
            module_entrypoint="$PROJECT_ROOT/modules/wiremock/bin/main-wiremock.sh"
            ;;
        
        *)
            log_error "Cannot execute unknown module: $module"
            log_error "Use --help to see available modules"
            return 1
            ;;    
    esac

    if [[ ! -f "$module_entrypoint" ]]; then
        log_error "Module entrypoint script not found: $module_entrypoint"
        return 1
    fi

    log_info "Executing module: $module"
    
    bash "$module_entrypoint"

    log_info "Module $module executed successfully" 
}

# ============================================================
# 7. Execute main function
# ============================================================

main() {
    
    log_info "Executing main function in $SCRIPT_NAME"
    
    parse_arguments "$@"
    
    if [[ ${#SELECTED_MODULES[@]} -eq 0 ]]; then
        log_error "No modules selected."
        log_error "Use --module <name> or --help."
        exit 1
    fi

    log_info "Selected modules: ${SELECTED_MODULES[*]}"

    for module in "${SELECTED_MODULES[@]}"; do
        run_module "$module"
    done

    log_info "All selected modules completed successfully."

}

main "$@"




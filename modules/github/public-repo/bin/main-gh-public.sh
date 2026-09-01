#!/usr/bin/env bash

# ============================================================
# Purpose: This script is the main entry point for github public repo module.
#          It orchestrates the execution of various step scripts to configure 
#          and validate a public repository on GitHub.
# Logic:
#          1. Set Global Variables
#          2. Create logging scripts
#          3. Pre-requisites Validation
#          4. Source the step scripts
#          5. Execute the main function which calls the step scripts in order
# ============================================================

set -euo pipefail

# ============================================================
# 1. Set Global Variables
# ============================================================

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
MODULE_ROOT="$(cd -- "$SCRIPT_DIR/../../" && pwd)"
PROJECT_ROOT="$(cd -- "$SCRIPT_DIR/../../../../" && pwd)"
SCRIPT_NAME="$(basename -- "${BASH_SOURCE[0]}")"

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

log_info "I am child process at $MODULE_ROOT/bin/main-gh-public.sh"

# ============================================================
# 3. Pre-requisites Validation
# ============================================================

log_info "Validating pre-requisites..."

# Validate if the 'gh' command is available
if command -v gh > /dev/null 2>&1; then
    log_info "Github cli command 'gh' found"
else
    log_error "Github cli command 'gh' not found"
    log_error "Use instruction 'modules/github/public-repo/instructions/github-cli-installation.md' to install the Github cli command"
    exit 1
fi

# Validate your git authentication with Github cli
if gh auth status > /dev/null 2>&1; then
    log_info "Github cli authentication is valid"
else
    log_error "Github cli authentication is invalid"
    log_error "Use instruction 'modules/github/public-repo/instructions/github-cli-authentication.md' to authenticate the Github cli command"
    exit 1
fi

# Validate if the 'jq' command is available
if command -v jq > /dev/null 2>&1; then
    log_info "JSON query command 'jq' found"
else
    log_error "JSON query command 'jq' not found"
    log_error "Use instruction 'modules/github/public-repo/instructions/jq-installation.md' to install the JSON query command"
    exit 1
fi

log_info "Pre-requisites validation completed successfully"

# ============================================================
# 4. Source the step scripts
# ============================================================

log_info "Sourcing the step scripts..."

# 4.1 Script 01_user_prompts
source "${SCRIPT_DIR}/steps/01_user_prompts"

# 4.2 Script 02_repository_settings
source "${SCRIPT_DIR}/steps/02_repository_settings"

# 4.3 Script 03_branch_protection
source "${SCRIPT_DIR}/steps/03_branch_protection"

# 4.4 Script 04_security
source "${SCRIPT_DIR}/steps/04_security"

# 4.5 Script 05_actions_permissions
source "${SCRIPT_DIR}/steps/05_actions_permissions"

# 4.6 Script 06_access_control
source "${SCRIPT_DIR}/steps/06_access_control"

# 4.7 Script 07_labels
source "${SCRIPT_DIR}/steps/07_labels"

# 4.8 Script 08_project
source "${SCRIPT_DIR}/steps/08_project/graphql/08_project"

log_info "Step scripts sourced successfully"

# ============================================================
# 5. Main Execution
# ============================================================

main() {
    
    log_info "Starting the main execution..."

    # Script 01: User Prompts
    log_info "01_user_prompts: Starting user prompts..."
    get_github_username
    select_github_repositories
    validate_selected_repository
    determine_private_or_public
    log_info "01_user_prompts: User prompts completed successfully"

    # Script 02: Repository Settings
    log_info "02_repository_settings: Starting repository settings configuration..."
    update_repository_description
    configure_repository_settings
    enable_release_immutability
    log_info "02_repository_settings: Repository settings configuration completed successfully"

    # Script 03: Branch Protection
    log_info "03_branch_protection: Starting branch protection rules configuration and validation..."
    configure_main_branch_protection_rules
    validate_enforcement_status
    validate_bypass_actor
    is_main_only_target_branch
    validate_rule_restrict_creations
    validate_rule_restrict_updates
    validate_rule_restrict_deletions
    validate_rule_require_linear_history
    validate_rule_require_deployments_to_succeed
    validate_rule_require_signed_commits
    validate_rule_pull_request
    validate_rule_checks_to_pass
    validate_rule_block_force_pushes
    validate_rule_require_code_scanning_results
    validate_rule_require_code_quality_results
    validate_rule_restrict_code_coverage
    validate_rule_automatically_request_copilot_code_review
    log_info "03_branch_protection: Branch protection rules configuration and validation completed successfully"
    
    # Script 04: Security
    log_info "04_security: Starting security configuration..."  
    enable_vulnerability_alerts
    enable_dependabot_security_updates
    enable_private_vulnerability_reporting
    enable_codeql_scanning
    log_info "04_security: Security configuration completed successfully"

    # Script 05: Actions Permissions
    log_info "05_actions_permissions: Starting actions permissions configuration..."
    enable_permission_allow_user_and_select_non_user_actions
    enable_permission_require_approval_for_all_external_contributors
    enable_permission_workflow_permissions
    enable_permission_artifact_and_log_retention
    log_info "05_actions_permissions: Actions permissions configuration completed successfully"
    
    # Script 06: Access Control
    log_info "06_access_control: Starting access control validation..."
    validate_only_admin_in_collaborators_list
    validate_no_teams_in_teams_list
    log_info "06_access_controll: Access control validation completed successfully" 

    # Script 07: Labels
    log_info "07_labels: Starting labels configuration..."
    remove_existing_labels
    create_priority_labels
    create_type_labels
    create_area_labels
    create_dependabot_labels
    log_info "07_labels: Labels configuration completed successfully"

    # Script 08: Project
    log_info "08_project: Starting project creation and configuration..."
    create_new_project
    link_project_to_repository "$PROJECT_NUMBER"
    set_project_default_repository
    create_custom_field_start_date "$(get_project_id $PROJECT_NUMBER)"
    create_custom_field_target_date "$(get_project_id $PROJECT_NUMBER)"
    create_custom_field_point_estimate "$(get_project_id $PROJECT_NUMBER)"
    create_custom_field_sprint "$(get_project_id $PROJECT_NUMBER)"
    log_warning "Think to add / adjust Sprint field in term of start date sprints ,etc manually after project creation"
    update_view_fields_in_project_view "$PROJECT_NUMBER" \
                                       "Table" \
                                       "TABLE_LAYOUT" \
                                       "Title" "Assignees" "Status" "Linked pull requests" "Sub-issues progress"
    create_new_view_in_project "$PROJECT_NUMBER"
    create_new_roadmap_view_in_project "$PROJECT_NUMBER"
    log_info "08_project: Project creation and configuration completed successfully"
    log_info "Main execution completed successfully"
    log_warning "Ensure that all third-party packages (e.g. jq, gh) are checked if installed as part of the pre-requisites validation. If not, install them before running the script again."
    log_warning "Consider change manually repo name from default 'development' to 'main' after script execution if needed"
}

main "$@"
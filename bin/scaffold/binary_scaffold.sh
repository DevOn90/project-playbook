#!/usr/bin/env bash

set -euo pipefail

# --------------------------------------------------------------
# Purpose: The script copies files and directories from a template
#          to a target destination based on a specified template file.
# Logic:
#          1. Set up local variables.
#          2. Set up logging functions.
#          3. Create a helper function to display usage information.
#          4. Parse command-line arguments.
#          5. Copy function to handle the copying of files and directories.
#          6. Template parser to read the template file and execute copy commands.
#          7. Main function to orchestrate the script's execution.
# --------------------------------------------------------------

# --------------------------------------------------------------
# 1. Variables
# --------------------------------------------------------------

TS=$(date +%Y-%m-%dT%H:%M:%S)
SCRIPT_NAME=$(basename "$0")

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

TEMPLATE_FILE=""
TARGET_ROOT=""
DRY_RUN=false

# --------------------------------------------------------------
# 2. Logging functions
# --------------------------------------------------------------

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

# --------------------------------------------------------------
# 3. Help
# --------------------------------------------------------------

show_help() {

cat <<EOF

Usage:
    $SCRIPT_NAME --template <template-file> --path <destination-path> [options]

Required arguments:

    --template <path>
        Full path to binary scaffold template file.

    --path <path>
        Destination project root.

Options:

    --dry-run
        Show what would be copied without copying.

    --help
        Show this help message.

Example:

    $SCRIPT_NAME \
        --template /opt/templates/binary-root-scaffold-template.txt \
        --path /home/user/my-project

    $SCRIPT_NAME \
        --template ./templates/binary-root-scaffold-template.txt \
        --path ./my-project \
        --dry-run

EOF

}

# --------------------------------------------------------------
# 4. Argument parser
# --------------------------------------------------------------

parse_arguments() {

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
                shift
                ;;

            --help|-h)
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

    # Validate required arguments
    if [[ -z "$TEMPLATE_FILE" ]]; then
        log_error "Missing required argument: --template"
        exit 1
    fi

    # Validate required arguments
    if [[ -z "$TARGET_ROOT" ]]; then
        log_error "Missing required argument: --path"
        exit 1
    fi

    # Validate that the template file exists
    if [[ ! -f "$TEMPLATE_FILE" ]]; then
        log_error "Template file does not exist: $TEMPLATE_FILE"
        exit 1
    fi

    # Normalize Target root path to remove trailing slashes
    TARGET_ROOT="${TARGET_ROOT%/}"

}

# --------------------------------------------------------------
# 5. Copy function
# --------------------------------------------------------------

copy_items() {
     
    local source="$1"
    local destination="$2"

    # Validate that the source exists
    if [[ ! -e "$source" ]]; then
        log_error "Source path does not exist:"
        log_error "$source"
        exit 1
    fi

    # If Dry-run mode is enabled, log the copy operation and return without performing the copy 
    if [[ "$DRY_RUN" == true ]]; then

        log_info "[DRY-RUN] Copy:"
        log_info "  $source"
        log_info "  -> $destination"

        return

    fi
    
    # Log the copy operation
    log_info "Copying:"
    log_info "  $source"
    log_info "  -> $destination"
    
    # Perform the copy operation using cp -a to preserve attributes and copy directories recursively
    cp -a "$source/." "$destination"

}

# --------------------------------------------------------------
# 6. Template parser
# --------------------------------------------------------------

process_template() {

    local line
    local source
    local destination

    # Read the template file line by line
    while IFS= read -r line || [[ -n "$line" ]]; do


        # Skip empty lines
        [[ -z "$line" ]] && continue


        # Skip comments
        [[ "$line" =~ ^# ]] && continue

        # Match lines that start with @copy followed by source and destination paths 
        if [[ "$line" =~ ^@copy[[:space:]]+([^[:space:]]+)[[:space:]]+([^[:space:]]+)$ ]]; then

            source="${BASH_REMATCH[1]}"
            destination="${BASH_REMATCH[2]}"

            # Call the copy_items function to perform the copy operation
            copy_items "$ROOT_DIR/$source" "$TARGET_ROOT/$destination"

        else

            log_warning "Invalid line in template: $line"

        fi

    # Read from the specified template file 
    done < "$TEMPLATE_FILE"

}

# --------------------------------------------------------------
# 7. Main
# --------------------------------------------------------------

main() {
    
    log_info "Starting binary scaffold script."
    
    # Parse command-line arguments
    parse_arguments "$@"

    log_info "Template:"
    log_info "  $TEMPLATE_FILE"

    log_info "Destination:"
    log_info "  $TARGET_ROOT"

    # Check if Dry-run mode is enabled and log the information
    if [[ "$DRY_RUN" == true ]]; then
        log_info "Dry-run mode enabled."
    fi

    # Process the template file to perform copy operations
    process_template

    log_info "Binary scaffold completed."

}


main "$@"
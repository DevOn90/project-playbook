#!/usr/bin/env bash

set -eou pipefail

# --------------------------------------------------------------
# Purpose:
#   Generate filesystem structure and file content from a
#   tree-style template containing <<<EOF ... EOF>>> blocks.
#
# Logic:
#   1. Define configuration variables.
#   2. Define logging and help functions.
#   3. Parse command-line arguments.
#   4. Validate input files and parameters.
#   5. Parse template tree structure.
#   6. Extract embedded file contents.
#   7. Create directories/files.
#   8. Execute generation from main().
# --------------------------------------------------------------


# --------------------------------------------------------------
# 1. Variables
# --------------------------------------------------------------

SCRIPT_NAME=$(basename "$0")
TS=$(date +%Y-%m-%dT%H:%M:%S)

TEMPLATE_FILE=""
TARGET_PATH=""
DRY_RUN=false

declare -A VARS=()

declare -a RAW_LINES=()
declare -A RAW_CONTENT=()

declare -a STACK=()

# --------------------------------------------------------------
# 2. Logging functions
# --------------------------------------------------------------

log_info() {
    echo "[INFO][$TS][$SCRIPT_NAME] $1"
}


log_warning() {
    echo "[WARNING][$TS][$SCRIPT_NAME] $1"
}


log_error() {
    echo "[ERROR][$TS][$SCRIPT_NAME] $1" >&2
}

log_debug() {
    echo "[DEBUG][$TS][$SCRIPT_NAME] $1"
}

# --------------------------------------------------------------
# 3. Help
# --------------------------------------------------------------

show_help() {

cat <<EOF

Usage:

    $SCRIPT_NAME --template <template-file> --path <target-directory> [options]

    $SCRIPT_NAME <template-file>


Required arguments:

    --template <path>
        Template file containing filesystem structure.

    --path <path>
        Target root directory where generated files will be created.


Options:

    --var KEY=VALUE
        Replace {{KEY}} placeholders inside generated file content.

    --dry-run
        Show what would be created without writing files.

    --help
        Show this help message.


Allowed template format:

    - Tree-style text with one node per line.
    - Supports:
          ├──
          └──

    - Optional root line:
          .
          ./

    - Directories normally end with "/".
    - Nodes with children are treated as directories.
    - File content can be embedded:

          <<<EOF
          file content
          EOF>>>


Example:

    .
    ├── src/
    │   └── main.py
    <<<EOF
    print("hello {{PROJECT_NAME}}")
    EOF>>>

EOF

}

# --------------------------------------------------------------
# 4. Argument parser
# --------------------------------------------------------------

# Parse command-line arguments and populate variables.
parse_arguments() {

    while [[ $# -gt 0 ]]; do
        case "$1" in
            --template=*)

                TEMPLATE_FILE="${1#*=}"
                shift

                ;;

            --template)

                [[ $# -lt 2 ]] && {
                    show_help
                    exit 1
                }

                TEMPLATE_FILE="$2"
                shift 2

                ;;

            --path=*)
                TARGET_PATH="${1#*=}"
                shift
                ;;

            --path)

                [[ $# -lt 2 ]] && {
                    show_help
                    exit 1
                }

                TARGET_PATH="$2"
                shift 2

                ;;


            --var=*)

                local var_kv="${1#*=}"

                VARS["${var_kv%%=*}"]="${var_kv#*=}"

                shift

                ;;


            --var)

                [[ $# -lt 2 ]] && {
                    show_help
                    exit 1
                }

                VARS["${2%%=*}"]="${2#*=}"

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

                if [[ -z "$TEMPLATE_FILE" && "$1" != --* ]]; then

                    TEMPLATE_FILE="$1"
                    shift

                else

                    log_error "Unknown argument: $1"
                    show_help
                    exit 1

                fi

                ;;

        esac


    done


}
# --------------------------------------------------------------
# 5. Validation
# --------------------------------------------------------------

validate_inputs() {

    # Validate that the template file exists 
    if [[ -z "$TEMPLATE_FILE" ]]; then

        log_error "Missing required template file."

        exit 1

    fi

    # Validate that the template file exists
    if [[ ! -f "$TEMPLATE_FILE" ]]; then

        log_error "Template file not found: $TEMPLATE_FILE"

        exit 1

    fi

    # Validate that the target path is provided
    if [[ -n "$TARGET_PATH" && "$DRY_RUN" == false ]]; then

        mkdir -p "$TARGET_PATH"

    fi


}

# --------------------------------------------------------------
# 6. Helper functions
# --------------------------------------------------------------

# Trim leading and trailing whitespace from a string 
trim() {
    sed 's/^[[:space:]]*//;s/[[:space:]]*$//'
}

# Validate that required arguments are provided and that the template file exists.
extract_depth() {

    local line="$1"
    local prefix

    if [[ "$line" =~ ^(.*)(├──|└──)[[:space:]] ]]; then
        prefix="${BASH_REMATCH[1]}"
        echo $(( ${#prefix} / 4 + 1 ))
    else
        echo 0
    fi
}

# Validate that required arguments are provided and that the template file exists.
extract_name() {
    local line="$1"

    # Extract the name of the node from a line in the template.
    if [[ "$line" =~ ^.*(├──|└──)[[:space:]](.*)$ ]]; then
        printf '%s\n' "${BASH_REMATCH[2]}" | trim
    else
        printf '%s\n' "$line" | trim
    fi
}

# Check if a node is a directory based on its name and depth.
is_directory_node() {

    local name="$1"
    local current_depth="$2"
    local next_depth="$3"

    # If the name ends with a slash, it's a directory. 
    if [[ "$name" == */ ]]; then
        return 0
    fi

    # If the next depth is greater than the current depth, it's a directory. 
    [[ "$next_depth" -gt "$current_depth" ]]

}

# Render the content of a file node, replacing template variables with their values.
render_content() {


    local content="$1"
    local key


    for key in "${!VARS[@]}"; do

        content="${content//\{\{$key\}\}/${VARS[$key]}}"

    done


    printf '%s\n' "$content"


}

# --------------------------------------------------------------
# 7. Template preprocessing
# --------------------------------------------------------------

prepare_template() {


    local line
    local trimmed_line
    local clean_name

    local state="normal"
    local content_buffer=""

    local last_idx=-1
    local root_checked=false


    mapfile -t all_lines < "$TEMPLATE_FILE"


    for line in "${all_lines[@]}"; do


        trimmed_line="$(printf '%s' "$line" | trim)"


        # Handle embedded content blocks

        if [[ "$state" == "content" ]]; then


            if [[ "$trimmed_line" == "EOF>>>" ]]; then


                RAW_CONTENT["$last_idx"]="$content_buffer"

                state="normal"

                content_buffer=""


            else


                content_buffer+="${content_buffer:+$'\n'}$line"


            fi


            continue


        fi



        if [[ "$trimmed_line" == "<<<EOF" ]]; then


            if (( last_idx < 0 )); then


                log_error "Content block found before any file node."

                exit 1


            fi


            state="content"

            content_buffer=""

            continue


        fi



        clean_name="$(extract_name "$line")"


        [[ -z "$clean_name" ]] && continue



        # Ignore virtual root

        if [[ "$root_checked" == false ]]; then


            root_checked=true


            if (( $(extract_depth "$line") == 0 )) &&
               [[ "$clean_name" == "." || "$clean_name" == "./" ]]; then


                continue


            fi


        fi



        RAW_LINES+=("$line")

        last_idx=$(( ${#RAW_LINES[@]} - 1 ))


    done



    if [[ "$state" == "content" ]]; then


        log_error "Unterminated content block. Missing EOF>>>."

        exit 1


    fi


}

# --------------------------------------------------------------
# 8. Filesystem generation
# --------------------------------------------------------------

generate_filesystem() {


    local depth_base=0


    if (( ${#RAW_LINES[@]} > 0 )); then

        depth_base="$(extract_depth "${RAW_LINES[0]}")"

    fi



    local i

    for ((i = 0; i < ${#RAW_LINES[@]}; i++)); do


        local line="${RAW_LINES[i]}"

        local name

        local depth

        local next_depth


        name="$(extract_name "$line")"


        depth="$(( $(extract_depth "$line") - depth_base ))"



        if (( i + 1 < ${#RAW_LINES[@]} )); then


            next_depth="$(( $(extract_depth "${RAW_LINES[i + 1]}") - depth_base ))"


        else


            next_depth=-1


        fi



        local parent=""


        if (( depth > 0 )); then


            parent="${STACK[depth - 1]-}"


        fi



        local base_name="${name%/}"

        local relative_path



        if [[ -n "$parent" ]]; then


            relative_path="$parent/$base_name"


        else


            relative_path="$base_name"


        fi



        local node_path



        if [[ -n "$TARGET_PATH" ]]; then


            node_path="$TARGET_PATH/$relative_path"


        else


            node_path="$relative_path"


        fi



        # Directory creation


        if is_directory_node "$name" "$depth" "$next_depth"; then



            if [[ "$DRY_RUN" == true ]]; then


                log_info "[DRY-RUN] Would create directory: $node_path"


            else


                mkdir -p "$node_path"

                log_info "Created directory: $node_path"


            fi



            STACK[depth]="$relative_path"



        else



            local has_content=false


            if [[ -n "${RAW_CONTENT[$i]-}" ]]; then

                has_content=true

            fi



            if [[ "$DRY_RUN" == true ]]; then



                if [[ "$has_content" == true ]]; then


                    log_info "[DRY-RUN] Would create file with content: $node_path"


                else


                    log_info "[DRY-RUN] Would create file: $node_path"


                fi



            else



                mkdir -p "$(dirname "$node_path")"



                if [[ "$has_content" == true ]]; then


                    render_content "${RAW_CONTENT[$i]}" > "$node_path"


                else


                    touch "$node_path"


                fi



                log_info "Created file: $node_path"



            fi



            STACK[depth]="$relative_path"



        fi



    done


}

# --------------------------------------------------------------
# 9. Main
# --------------------------------------------------------------

main() {


    log_info "Starting filesystem generation script."

    # Parse command-line arguments
    parse_arguments "$@"

    # Validate inputs and ensure required files and parameters are present 
    validate_inputs



    log_info "Template:"
    log_info "  $TEMPLATE_FILE"


    
    if [[ -n "$TARGET_PATH" ]]; then

        log_info "Destination:"
        log_info "  $TARGET_PATH"

    fi



    if [[ "$DRY_RUN" == true ]]; then

        log_info "Dry-run mode enabled."

    fi


    # Prepare the template by reading it and extracting the structure and content blocks 
    prepare_template

    # Generate the filesystem structure and files based on the prepared template
    generate_filesystem



    log_info "Filesystem generation completed."

}

main "$@"
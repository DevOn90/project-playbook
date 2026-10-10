#!/usr/bin/env bash

# ============================================================
# Purpose: TBD
# Components:
#       1. Set Global Variables
#       2. Create logging scripts
#       3. TBD
# ============================================================

set -euo pipefail

# ============================================================
# 1. Set Global Variables
# ============================================================

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
MODULE_ROOT="$(cd -- "${SCRIPT_DIR}/../" && pwd)"
PROJECT_ROOT="$(cd -- "${SCRIPT_DIR}/../../../" && pwd)"
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

# ============================================================
# X. Main
# ============================================================

main() {
    
    
    log_info "Starting Spring Boot module setup..."

       
    # local output="${PROJECT_ROOT}/temp/backend.zip"
    
    # curl \
    #    --fail \
    #    --silent \
    #    --show-error \
    #    --location \
    #    --output "${output}" \
    #    --get \
    #    --data-urlencode "type=maven-project" \
    #    --data-urlencode "language=java" \
    #    --data-urlencode "bootVersion=4.1.1" \
    #    --data-urlencode "javaVersion=17" \
    #    --data-urlencode "packaging=jar" \
    #    --data-urlencode "groupId=com.example" \
    #    --data-urlencode "artifactId=back-end" \
    #    --data-urlencode "name=back-end" \
    #    --data-urlencode "packageName=com.example.backend" \
    #    --data-urlencode "dependencies=web,actuator" \
    #    "https://start.spring.io/starter.zip"

    # unzip -o "${output}" -d "${PROJECT_ROOT}/temp"
    
    
    echo "Run command: ./mvnw clean test 'Important for .mvnw directory'"

    log_info "Spring Boot module setup completed."
}

main "$@"
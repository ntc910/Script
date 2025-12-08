#!/bin/bash

set -euo pipefail

#==============================================================================
# CONFIGURATION
#==============================================================================

readonly CPP_STANDARD="-std=c++14"
readonly TEMP_DIR="$HOME/.tmp"
readonly EXECUTABLE_PATH="$TEMP_DIR/run"
readonly SCRIPT_NAME="$(basename "$0")"

#==============================================================================
# COLORS
#==============================================================================

readonly COLOR_OFF='\033[0m'
readonly COLOR_BLACK='\033[0;30m'
readonly COLOR_RED='\033[0;31m'
readonly COLOR_GREEN='\033[0;32m'
readonly COLOR_YELLOW='\033[0;33m'
readonly COLOR_BLUE='\033[0;34m'
readonly COLOR_PURPLE='\033[0;35m'
readonly COLOR_CYAN='\033[0;36m'
readonly COLOR_WHITE='\033[0;37m'

#==============================================================================
# MESSAGES
#==============================================================================

readonly MSG_ERROR_NO_CPP_FILE="${COLOR_RED}Error: At least one .cpp file is required${COLOR_OFF}"
readonly MSG_ERROR_FILE_NOT_FOUND="${COLOR_RED}Error: File '%s' not found${COLOR_OFF}"
readonly MSG_ERROR_EXECUTABLE_NOT_FOUND="${COLOR_RED}Error: Executable not found${COLOR_OFF}"
readonly MSG_ERROR_BUILD_FAILED="${COLOR_RED}Build failed!${COLOR_OFF}"
readonly MSG_WARNING_FILE_NOT_FOUND="${COLOR_YELLOW}Warning: File '%s' not found, skipping${COLOR_OFF}"
readonly MSG_USAGE="${COLOR_YELLOW}Usage: $SCRIPT_NAME <cpp_file1.cpp> [cpp_file2.cpp] ... [other_files] [compiler_options]${COLOR_OFF}"
readonly MSG_EXAMPLE="${COLOR_YELLOW}Example: $SCRIPT_NAME test.cpp helper.cpp input.txt -Ofast -static${COLOR_OFF}"

#==============================================================================
# FUNCTIONS
#==============================================================================

print_usage() {
    echo "$MSG_USAGE"
    echo "$MSG_EXAMPLE"
}

log_info() {
    local message="$1"
    echo -e "${COLOR_GREEN}$message${COLOR_OFF}"
}

log_warning() {
    local message="$1"
    # shellcheck disable=SC2059
    printf "$message\n"
}

log_error() {
    local message="$1"
    # shellcheck disable=SC2059
    printf "$message\n"
}

log_command() {
    local command="$1"
    echo -e "${COLOR_BLUE}Command: $command${COLOR_OFF}"
}

log_build_success() {
    log_info "Build successful!"
}

log_build_files() {
    local -a files=("$@")
    log_info "Building C++ files: ${files[*]}"
}

log_copying_file() {
    local file="$1"
    log_info "Copying $file to $TEMP_DIR/"
}

log_running_program() {
    echo -e "${COLOR_RED}Running program...${COLOR_WHITE}"
}

log_execution_stats() {
    local time_ms="$1"
    local exit_code="$2"
    echo ""
    echo -e "${COLOR_RED}Time: ${time_ms}ms${COLOR_OFF}"
    echo -e "${COLOR_RED}Exit code: $exit_code${COLOR_OFF}"
}

log_done() {
    log_info "Done!"
}

setup_environment() {
    mkdir -p "$TEMP_DIR"
}

validate_arguments() {
    if [[ $# -eq 0 ]]; then
        log_error "$MSG_ERROR_NO_CPP_FILE"
        print_usage
        exit 1
    fi
}


validate_cpp_files() {
    local -a cpp_files=("$@")
    
    if [[ ${#cpp_files[@]} -eq 0 ]]; then
        log_error "$MSG_ERROR_NO_CPP_FILE"
        exit 1
    fi
    
    for cpp_file in "${cpp_files[@]}"; do
        if [[ ! -f "$cpp_file" ]]; then
            # shellcheck disable=SC2059
            log_error "$(printf "$MSG_ERROR_FILE_NOT_FOUND" "$cpp_file")"
            exit 1
        fi
    done
}

copy_non_cpp_files() {
    local -a other_files=("$@")
    
    for other_file in "${other_files[@]}"; do
        if [[ -f "$other_file" ]]; then
            log_copying_file "$other_file"
            cp "$other_file" "$TEMP_DIR/"
        else
            # shellcheck disable=SC2059
            log_warning "$(printf "$MSG_WARNING_FILE_NOT_FOUND" "$other_file")"
        fi
    done
}

build_program() {
    local -a cpp_files=("$@")
    local -a compiler_options=("${@:${#cpp_files[@]}+1}")
    
    log_build_files "${cpp_files[@]}"
    
    local gpp_command="g++ $CPP_STANDARD"
    if [[ ${#compiler_options[@]} -gt 0 ]]; then
        gpp_command+=" ${compiler_options[*]}"
    fi
    gpp_command+=" ${cpp_files[*]} -o $EXECUTABLE_PATH"
    
    log_command "$gpp_command"
    
    if [[ ${#compiler_options[@]} -gt 0 ]]; then
        if g++ $CPP_STANDARD "${compiler_options[@]}" "${cpp_files[@]}" -o "$EXECUTABLE_PATH"; then
            log_build_success
        else
            log_error "$MSG_ERROR_BUILD_FAILED"
            exit 1
        fi
    else
        if g++ $CPP_STANDARD "${cpp_files[@]}" -o "$EXECUTABLE_PATH"; then
            log_build_success
        else
            log_error "$MSG_ERROR_BUILD_FAILED"
            exit 1
        fi
    fi
}

run_program() {
    if [[ ! -f "$EXECUTABLE_PATH" ]]; then
        log_error "$MSG_ERROR_EXECUTABLE_NOT_FOUND"
        exit 1
    fi
    
    log_running_program
    
    local start_time
    start_time=$(date +%s%N)
    
    "$EXECUTABLE_PATH"
    local exit_code=$?
    
    local end_time
    end_time=$(date +%s%N)
    
    local execution_time
    execution_time=$(((end_time - start_time) / 1000000))
    
    log_execution_stats "$execution_time" "$exit_code"
}

cleanup_temp_files() {
    local -a other_files=("$@")
    
    for other_file in "${other_files[@]}"; do
        local basename_file
        basename_file=$(basename "$other_file")
        if [[ -f "$TEMP_DIR/$basename_file" ]]; then
            rm -f "$TEMP_DIR/$basename_file"
        fi
    done
}


main() {
    setup_environment
    validate_arguments "$@"
    
    # Categorize arguments into arrays
    local -a cpp_files=()
    local -a other_files=()
    local -a compiler_options=()
    
    for arg in "$@"; do
        if [[ "$arg" == *.cpp ]]; then
            cpp_files+=("$arg")
        elif [[ "$arg" == -* ]]; then
            compiler_options+=("$arg")
        else
            other_files+=("$arg")
        fi
    done
    
    validate_cpp_files "${cpp_files[@]}"
    copy_non_cpp_files "${other_files[@]}"
    build_program "${cpp_files[@]}" "${compiler_options[@]}"
    run_program
    cleanup_temp_files "${other_files[@]}"
    log_done
}

#==============================================================================
# ENTRY POINT
#==============================================================================

main "$@"

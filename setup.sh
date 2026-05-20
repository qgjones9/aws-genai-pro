#!/bin/bash

# Setup script for kb-mathematics project
# This script creates a virtual environment, activates it, and installs dependencies
#
# Usage:
#   source setup.sh    # Recommended - activates venv in current shell
#   . setup.sh         # Alternative syntax (same as source)

PROJECT_ROOT=""

is_sourced() {
    [[ "${BASH_SOURCE[0]}" != "${0}" ]]
}

fail() {
    echo "Error: $1"
    return 1
}

ensure_sourced() {
    if ! is_sourced; then
        echo "Error: This script must be sourced, not executed directly."
        echo ""
        echo "Usage:"
        echo "  source setup.sh"
        echo "or"
        echo "  . setup.sh"
        echo ""
        return 1
    fi
    return 0
}

ensure_git_available() {
    if ! command -v git >/dev/null 2>&1; then
        fail "git is not installed or not in PATH." || return 1
    fi
    return 0
}

ensure_python3_available() {
    if ! command -v python3 >/dev/null 2>&1; then
        fail "python3 is not installed or not in PATH." || return 1
    fi
    return 0
}

ensure_in_git_repo() {
    if ! git rev-parse --git-dir >/dev/null 2>&1; then
        fail "This project is not controlled by git. Please initialize git first." || return 1
    fi
    return 0
}

set_project_root() {
    PROJECT_ROOT="$(git rev-parse --show-toplevel)"
    if [[ -z "${PROJECT_ROOT}" ]]; then
        fail "Could not determine project root from git repository." || return 1
    fi
    return 0
}

ensure_venv() {
    if [[ ! -d "${PROJECT_ROOT}/.venv" ]]; then
        echo "Creating virtual environment..."
        python3 -m venv "${PROJECT_ROOT}/.venv" || return 1
        echo "Virtual environment created successfully!"
    fi
    return 0
}

activate_venv() {
    # shellcheck disable=SC1091
    source "${PROJECT_ROOT}/.venv/bin/activate"
    return $?
}

install_dependencies() {
    if [[ -f "${PROJECT_ROOT}/requirements.txt" ]]; then
        echo "Installing dependencies..."
        pip install -r "${PROJECT_ROOT}/requirements.txt" || return 1
        return 0
    fi

    echo "Warning: requirements.txt not found. Skipping dependency installation."
    return 0
}

# Runs mkdocs serve from venv with a random port (8000-8999).
# See mkrun in dotfiles/functions.zsh for the zsh equivalent.
maybe_run_mkrun() {
    local port
    port=$(shuf -i 8000-8999 -n 1 2>/dev/null)
    if [[ -z "${port}" ]]; then
        port=8000
    fi
    echo "Starting mkdocs server with dev_addr: http://127.0.0.1:${port}"
    (cd "${PROJECT_ROOT}" && "${PROJECT_ROOT}/.venv/bin/mkdocs" serve --livereload --dev-addr "127.0.0.1:${port}")
    return $?
}

main() {
    ensure_sourced \
        && ensure_git_available \
        && ensure_python3_available \
        && ensure_in_git_repo \
        && set_project_root \
        && ensure_venv \
        && activate_venv \
        && install_dependencies \
        && echo "Setup complete! Virtual environment is activated." \
        && maybe_run_mkrun
    return $?
}

main "$@"

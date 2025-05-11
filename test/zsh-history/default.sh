#!/bin/bash

# This script contains common tests that can be sourced by other test scripts
# It can also run independently for the "default" scenario

# Import test library bundled with the devcontainer CLI if not already sourced
if ! command -v check &> /dev/null; then
    source dev-container-features-test-lib
fi

# Flag to track if this is being sourced or run directly
DEFAULT_TEST_SOURCED=${DEFAULT_TEST_SOURCED:-false}

# Function for common basic checks
run_basic_checks() {
    # Basic checks
    check "command history directory exists" test -d /commandhistory
    check "zsh history file exists" test -f /commandhistory/.zsh_history
}

# Function for common zshrc configuration checks
run_zshrc_checks() {
    # Configuration checks
    check "zshrc file exists" test -f ~/.zshrc
    check "zshrc contains history config" grep -q "HISTFILE=/commandhistory/.zsh_history" ~/.zshrc
}

# When script is run directly (not sourced)
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    set -e

    # Run all common tests
    run_basic_checks
    run_zshrc_checks
    
    # Report results
    reportResults
fi
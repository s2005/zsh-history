#!/bin/bash

# This script contains common tests for the zsh-history-volume feature
# It can be sourced by other test scripts or run independently for the "default" scenario

# Import test library bundled with the devcontainer CLI if not already sourced
if ! command -v check &> /dev/null; then
    source dev-container-features-test-lib
fi

# Flag to track if this is being sourced or run directly
DEFAULT_TEST_SOURCED=${DEFAULT_TEST_SOURCED:-false}

# Default history path (fixed to /zshhistory as per implementation)
HISTORY_PATH="/zshhistory"

# Function for common basic checks
run_basic_checks() {
    # Check that the history directory exists
    check "Command history directory exists" test -d ${HISTORY_PATH}
    
    # Check that the history file exists
    check "Zsh history file exists" test -f ${HISTORY_PATH}/.zsh_history
    
    # Check that the history directory has readable permissions
    check "History directory has readable permissions" test -r ${HISTORY_PATH}
    
    # Ensure the Docker volume is correctly mounted
    check "Directory is a mount point" mountpoint -q ${HISTORY_PATH}
}

# Function for common zshrc configuration checks
run_zshrc_checks() {
    # Configuration checks
    check "zshrc file exists" test -f ~/.zshrc
    
    # Check that .zshrc contains the correct history file configuration
    check "zshrc contains history file config" grep -q "HISTFILE=${HISTORY_PATH}/.zsh_history" ~/.zshrc
    
    # Check for other required zsh settings
    check "zshrc has INC_APPEND_HISTORY option" grep -q "setopt INC_APPEND_HISTORY" ~/.zshrc
    check "zshrc has SHARE_HISTORY option" grep -q "setopt SHARE_HISTORY" ~/.zshrc
}

# Function to test writing to history and persistence
run_history_functionality_test() {
    # Add a test command to history
    echo "test_command_$(date +%s)" > ${HISTORY_PATH}/.zsh_history
    
    # Verify the command was written
    check "Can write to history file" grep -q "test_command_" ${HISTORY_PATH}/.zsh_history
}

# When script is run directly (not sourced)
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    set -e

    # Run all common tests
    run_basic_checks
    run_zshrc_checks
    run_history_functionality_test
    
    # Report results
    reportResults
fi
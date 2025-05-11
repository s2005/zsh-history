#!/bin/bash

# This test file runs for the "with-oh-my-zsh-non-root" scenario

set -e

# Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

# Source common tests from default.sh
DEFAULT_TEST_SOURCED=true
source "$(dirname "$0")/default.sh"

# Run common tests
run_basic_checks
run_zshrc_checks

# Oh-My-Zsh with non-root user specific tests
check "oh-my-zsh is installed" test -d ~/.oh-my-zsh
check "zsh plugins directory has correct permissions" [ "$(stat -c '%U' ~/.oh-my-zsh/custom/plugins)" = "$(whoami)" ]
check "user is vscode" [ "$(whoami)" = "vscode" ]

# Test actual zsh history functionality with better debugging
echo "Checking permissions before running zsh commands"
ls -la /commandhistory
ls -la ~ | grep zsh_history
# Use zsh with verbose error reporting
zsh -x -c 'echo "test command non-root" > /tmp/test_command.txt' || { echo "Failed to write test command"; exit 1; }
zsh -x -c 'cat /tmp/test_command.txt >> $HISTFILE' || { echo "Failed to append to history file"; exit 1; }
check "zsh history configuration works" grep -q "test command non-root" /commandhistory/.zsh_history

# Report test results
reportResults

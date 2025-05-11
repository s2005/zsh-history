#!/bin/bash

# This test file runs for the "with-oh-my-zsh" scenario

set -e

# Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

# Source common tests from default.sh
DEFAULT_TEST_SOURCED=true
source "$(dirname "$0")/default.sh"

# Run common tests
run_basic_checks
run_zshrc_checks

# Oh-My-Zsh specific tests
check "oh-my-zsh is installed" test -d ~/.oh-my-zsh
check "zsh plugins directory has correct permissions" [ "$(stat -c '%U' ~/.oh-my-zsh/custom/plugins)" = "$(whoami)" ]

# Test actual zsh history functionality
zsh -c 'echo "test command" > /tmp/test_command.txt'
zsh -c 'cat /tmp/test_command.txt >> $HISTFILE'
check "zsh history configuration works" grep -q "test command" /commandhistory/.zsh_history

# Report test results
reportResults
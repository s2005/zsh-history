#!/bin/bash

# This test file runs for the "with-oh-my-zsh" scenario

set -e

# Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

# Basic tests
check "command history directory exists" test -d /commandhistory
check "zsh history file exists" test -f /commandhistory/.zsh_history

# Oh-My-Zsh tests
check "oh-my-zsh is installed" test -d ~/.oh-my-zsh
check "zsh plugins directory has correct permissions" [ "$(stat -c '%U' ~/.oh-my-zsh/custom/plugins)" = "$(whoami)" ]

# Test actual zsh history functionality
zsh -c 'echo "test command" > /tmp/test_command.txt'
zsh -c 'cat /tmp/test_command.txt >> $HISTFILE'
check "zsh history configuration works" grep -q "test command" /commandhistory/.zsh_history

# Report test results
reportResults
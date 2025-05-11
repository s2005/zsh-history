#!/bin/bash

# This test file runs for the "with-non-root-user" scenario

set -e

# Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

# Basic tests
check "command history directory exists" test -d /commandhistory
check "zsh history file exists" test -f /commandhistory/.zsh_history

# Non-root user tests
check "running as non-root user" [ "$(whoami)" != "root" ]
check "running as vscode user" [ "$(whoami)" = "vscode" ]

# Check zsh configuration in user's home directory
check "zshrc file exists" test -f ~/.zshrc
check "zshrc contains history path" grep -q "/commandhistory/.zsh_history" ~/.zshrc

# TODO: Uncomment and investigate the following test
# check "history file is properly owned" [ "$(stat -c '%U' /commandhistory/.zsh_history)" = "vscode" ]

# Report test results
reportResults
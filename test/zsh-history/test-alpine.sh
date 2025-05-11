#!/bin/bash

# This test file runs for the "with-alpine" scenario

set -e

# Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

# Basic tests
check "command history directory exists" test -d /commandhistory
check "zsh history file exists" test -f /commandhistory/.zsh_history

# Alpine-specific tests
check "alpine base image is used" grep -q "Alpine Linux" /etc/os-release

# Check zsh is installed and can find the history file
check "zsh can read history file" zsh -c 'test -f $HISTFILE'

# Report test results
reportResults
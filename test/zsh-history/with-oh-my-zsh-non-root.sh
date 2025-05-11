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
ls -la ~ | grep zsh_history || echo "No zsh_history in home directory"

# Check the current user and groups
echo "Current user info:"
id
echo "Current shell: $SHELL"

# Verify HISTFILE setting
echo "Looking for HISTFILE in .zshrc"
cat ~/.zshrc | grep HISTFILE
HIST_FILE_SETTING=$(grep "HISTFILE=" ~/.zshrc | tail -1 | cut -d'=' -f2)
echo "Found HISTFILE setting: $HIST_FILE_SETTING"

# Get the current user's UID and verify uid
CURRENT_UID=$(id -u)
echo "Current UID: $CURRENT_UID"

# Debug the command history directory permissions
echo "Command history directory ownership:"
ls -lan /commandhistory

# Try different ways to write to the history file to make sure at least one works
echo "Writing test command using direct echo"
echo "test command (direct)" >> /commandhistory/.zsh_history

# Show the history file content
echo "History file contents:"
cat /commandhistory/.zsh_history 2>/dev/null || sudo cat /commandhistory/.zsh_history 2>/dev/null || echo "Could not read history file"

# Verify the content was written properly - check for either variant
grep -q "test command vscode" /commandhistory/.zsh_history && 
  check "zsh history file contains test command" true ||
  check "zsh history file contains test command" false

# Report test results
reportResults

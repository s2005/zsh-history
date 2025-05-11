#!/bin/bash

# This test file runs for the "default" scenario in _global

set -e

# Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

# Basic checks
check "command history directory exists" test -d /commandhistory
check "zsh history file exists" test -f /commandhistory/.zsh_history

# Configuration checks
check "zshrc file exists" test -f ~/.zshrc
check "zshrc contains history config" grep -q "HISTFILE=/commandhistory/.zsh_history" ~/.zshrc

# Flag file check
check "installation flag file exists" test -f /tmp/zsh_history_configured

# Report results
reportResults
#!/bin/bash

# This test file will be executed against an auto-generated devcontainer.json that
# includes the 'zsh-history' Feature with no options.
#
# For more information, see: https://github.com/devcontainers/cli/blob/main/docs/features/test.md

set -e

# Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

# Basic checks
check "command history directory exists" test -d /commandhistory
check "zsh history file exists" test -f /commandhistory/.zsh_history

# Configuration checks
check "zshrc file exists" test -f ~/.zshrc
check "zshrc contains history config" grep -q "HISTFILE=/commandhistory/.zsh_history" ~/.zshrc

# Report results
reportResults
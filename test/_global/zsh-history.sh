#!/bin/bash

# This test file will be executed against an auto-generated devcontainer.json that
# includes the 'zsh-history' Feature with no options.
#
# For more information, see: https://github.com/devcontainers/cli/blob/main/docs/features/test.md
#
# These scripts are run as 'root' by default. Although that can be changed
# with the '--remote-user' flag.
#
# This test can be run with the following command:
#
#    devcontainer features test \ 
#                   --features zsh-history \
#                   --remote-user root \
#                   --skip-scenarios \
#                   --base-image mcr.microsoft.com/devcontainers/base:ubuntu \
#                   /path/to/this/repo

set -e

# Optional: Import test library bundled with the devcontainer CLI
# See https://github.com/devcontainers/cli/blob/HEAD/docs/features/test.md#dev-container-features-test-lib
# Provides the 'check' and 'reportResults' commands.
source dev-container-features-test-lib

# Feature-specific tests
# The 'check' command comes from the dev-container-features-test-lib. 
# Syntax is: check <LABEL> <cmd> [args...]

# Check that the command history directory exists
check "command history directory exists" test -d /commandhistory

# Check that the zsh history file exists in the directory
check "zsh history file exists" test -f /commandhistory/.zsh_history

# Report results
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults

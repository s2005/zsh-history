#!/bin/bash

# This test file will be executed against an auto-generated devcontainer.json that
# includes the 'zsh-history' Feature with no options.
#
# For more information, see: https://github.com/devcontainers/cli/blob/main/docs/features/test.md

set -e

# Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

# Source common tests from default.sh
DEFAULT_TEST_SOURCED=true
source "$(dirname "$0")/default.sh"

# Run the common tests
run_basic_checks
run_zshrc_checks

# Report results
reportResults
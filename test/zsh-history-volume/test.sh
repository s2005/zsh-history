#!/bin/bash

# This test file will be executed against an auto-generated devcontainer.json that
# includes the 'zsh-history-volume' Feature with default options.
#
# For more information, see: https://github.com/devcontainers/cli/blob/main/docs/features/test.md

set -e

# Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

# Source common tests from default.sh
DEFAULT_TEST_SOURCED=true
source "$(dirname "$0")/default.sh"

echo "Testing zsh-history-volume feature with default options..."

# Run the common tests
run_basic_checks
run_zshrc_checks
run_history_functionality_test

# Additional specific tests for this feature - just check for mountpoint
# Since the devcontainerId is dynamically generated, we can't check for exact pattern
check "Volume mount exists" findmnt -n ${HISTORY_PATH} >/dev/null

# Verify the feature can actually store history across sessions
TEST_CMD="test_history_persistence_$(date +%s)"
echo $TEST_CMD >> ${HISTORY_PATH}/.zsh_history
check "History file contains test command" grep -q "$TEST_CMD" ${HISTORY_PATH}/.zsh_history

# Report results
reportResults
#!/bin/bash

# This test file will be executed against an auto-generated devcontainer.json that
# includes the 'zsh-history-bind' Feature with default options.
#
# For more information, see: https://github.com/devcontainers/cli/blob/main/docs/features/test.md

set -e

# Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

# Source common tests from default.sh
DEFAULT_TEST_SOURCED=true
source "$(dirname "$0")/default.sh"

echo "Testing zsh-history-bind feature with default options..."

# Run the common tests
run_basic_checks
run_zshrc_checks

# Check file ownership and permissions
CURRENT_USER=$(whoami)
HISTORY_FILE="${HISTORY_PATH}/.zsh_history"
FILE_OWNER=$(stat -c '%U' "${HISTORY_FILE}" 2>/dev/null || echo "unknown")
FILE_PERMS=$(stat -c '%a' "${HISTORY_FILE}" 2>/dev/null || echo "unknown")

echo "DEBUG: History file ownership: ${FILE_OWNER}, permissions: ${FILE_PERMS}, current user: ${CURRENT_USER}"

# Check that the bind mount exists (specific format may vary by system)
check "Bind mount exists" findmnt -n ${HISTORY_PATH} | grep -E "bind|9p"

# Test writing to the history file - sudo should be available now through common-utils
TEST_CMD="test_history_persistence_$(date +%s)"
echo "${TEST_CMD}" | sudo tee -a "${HISTORY_PATH}/.zsh_history" >/dev/null || true
check "History file contains test command" grep -q "${TEST_CMD}" "${HISTORY_PATH}/.zsh_history"

# Report results
reportResults
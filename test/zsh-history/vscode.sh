#!/bin/bash

# This test file runs for the "with-non-root-user" scenario

set -e

# Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

# Source common tests from default.sh
DEFAULT_TEST_SOURCED=true
source "$(dirname "$0")/default.sh"

# Run common tests
run_basic_checks
run_zshrc_checks

# Non-root user specific tests
check "running as non-root user" [ "$(whoami)" != "root" ]
check "running as vscode user" [ "$(whoami)" = "vscode" ]

# TODO: Uncomment and investigate the following test
# check "history file is properly owned" [ "$(stat -c '%U' /commandhistory/.zsh_history)" = "vscode" ]

# Report test results
reportResults
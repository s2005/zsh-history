#!/bin/bash

# This test script is for the "zsh-history" scenario
# It is executed after the container is built according to the scenario configuration in scenarios.json

set -e

# Import test library bundled with the devcontainer CLI
# Provides the 'check' and 'reportResults' commands
source dev-container-features-test-lib

# Source common tests from default.sh
DEFAULT_TEST_SOURCED=true
source "$(dirname "$0")/default.sh"

# Run the basic checks (we might skip more complex checks for this simple case)
run_basic_checks

# Report test results
# If any of the checks above exited with a non-zero exit code, the test will fail
reportResults

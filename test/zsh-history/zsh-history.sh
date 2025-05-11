#!/bin/bash

# This test script is for the "zsh-history" scenario
# It is executed after the container is built according to the scenario configuration in scenarios.json

set -e

# Optional: Import test library bundled with the devcontainer CLI
# Provides the 'check' and 'reportResults' commands
source dev-container-features-test-lib

# Basic function tests
# The 'check' command checks if the following command returns a 0 exit code
check "command history directory exists" test -d /commandhistory
check "zsh history file exists" test -f /commandhistory/.zsh_history

# Report test results
# If any of the checks above exited with a non-zero exit code, the test will fail
reportResults

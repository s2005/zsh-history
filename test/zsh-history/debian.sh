#!/bin/bash

# This test file runs for the "with-debian" scenario

set -e

# Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

# Source common tests from default.sh
DEFAULT_TEST_SOURCED=true
source "$(dirname "$0")/default.sh"

# Run common tests
run_basic_checks
run_zshrc_checks

# Debian-specific tests
check "debian base image is used" grep -q "Debian" /etc/os-release

# Check zsh is installed and can find the history file
check "zsh can read history file" zsh -c 'test -f $HISTFILE'

# Report test results
reportResults
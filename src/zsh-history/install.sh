#!/usr/bin/env bash
set -euxo pipefail

# Echo statements for debugging purposes
echo "Executing install.sh for zsh-history feature"
echo "Remote user: ${_REMOTE_USER}"
echo "Remote user home: ${_REMOTE_USER_HOME}"
echo "Container user: ${_CONTAINER_USER}"
echo "Container user home: ${_CONTAINER_USER_HOME}"

# The following block ensures that a /.zsh_history file exists and has the correct
# permissions, particularly for scenarios involving a root-level Oh My Zsh installation.

echo "Managing /.zsh_history and root .oh-my-zsh permissions..."
# Determine current user and whether they can use sudo
CURRENT_USER=$(whoami)
CAN_SUDO=0
if command -v sudo >/dev/null 2>&1; then
    sudo -n true >/dev/null 2>&1 && CAN_SUDO=1
fi

# Handle root .zsh_history file
if [ "${CURRENT_USER}" = "root" ]; then
    echo "Current user is root. Performing root-level operations directly."
    touch /.zsh_history
else
    echo "Current user ('${CURRENT_USER}') is not root."
    if [ $CAN_SUDO -eq 1 ]; then
        echo "User can use sudo. Using sudo for root-level operations."
        sudo touch /.zsh_history
    else
        echo "User cannot use sudo. Skipping root-level operations."
    fi
fi

# Handle Oh My Zsh permissions for both root and user
# Check for Oh My Zsh at root level
if [ -d "/.oh-my-zsh/custom/plugins/" ]; then
    echo "Found Oh My Zsh at root level."
    if [ "${CURRENT_USER}" = "root" ]; then
        # If we're root, we can directly modify the permissions
        chmod -R 755 /.oh-my-zsh/custom/plugins/
    elif [ $CAN_SUDO -eq 1 ]; then
        # If we can sudo, use it
        sudo chmod -R 755 /.oh-my-zsh/custom/plugins/
    fi
else
    echo "Root Oh My Zsh plugins directory (/.oh-my-zsh/custom/plugins/) not found."
fi
echo "Finished managing /.zsh_history and root .oh-my-zsh permissions."

# Create directory for command history
mkdir -p /commandhistory

# Create and set permissions for .zsh_history file
touch /commandhistory/.zsh_history

# Set ownership to the remote user to handle automatic UID assignment
if [ -n "${_REMOTE_USER}" ]; then
    echo "Setting /commandhistory ownership to ${_REMOTE_USER}"
    # Get actual UID of the remote user (handles "automatic" UID assignment)
    ACTUAL_UID=$(id -u "${_REMOTE_USER}")
    ACTUAL_GID=$(id -g "${_REMOTE_USER}")
    chown -R "${ACTUAL_UID}:${ACTUAL_GID}" /commandhistory
    echo "Set ownership to UID=${ACTUAL_UID}:GID=${ACTUAL_GID}"
else
    echo "No remote user specified, keeping default ownership"
fi

# Fix permissions for zsh plugins if .oh-my-zsh exists for the remote user
if [ -d "${_REMOTE_USER_HOME}/.oh-my-zsh" ]; then
    chown -R ${_REMOTE_USER}:${_REMOTE_USER} "${_REMOTE_USER_HOME}/.oh-my-zsh/custom/plugins/"
else
    echo ".oh-my-zsh directory not found for user ${_REMOTE_USER} at ${_REMOTE_USER_HOME}/.oh-my-zsh. Skipping chown for plugins."
fi

# Append to .zshrc file
cat >> "${_REMOTE_USER_HOME}/.zshrc" << 'ZSHRC_CONFIG'

# Added by zsh-history feature
autoload -Uz add-zsh-hook
append_history() { fc -W }
add-zsh-hook precmd append_history
export HISTFILE=/commandhistory/.zsh_history
export HISTSIZE=100000
export SAVEHIST=100000
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
ZSHRC_CONFIG

# Set proper permissions
chown ${_REMOTE_USER}:${_REMOTE_USER} "${_REMOTE_USER_HOME}/.zshrc"
chmod 644 "${_REMOTE_USER_HOME}/.zshrc"

echo "Zsh history configuration written to ${_REMOTE_USER_HOME}/.zshrc"
echo "install.sh for zsh-history completed."

#!/usr/bin/env bash
set -euxo pipefail

# Get the username option, fallback to REMOTE_USER if not provided
USERNAME="${USERNAME:-"${_REMOTE_USER}"}"
# Get the history path from the environment variable set via containerEnv
HISTORY_PATH="${ZSH_HISTORY_PATH:-"/commandhistory"}"

# Echo statements for debugging purposes
echo "Executing install.sh for zsh-history-volume feature"
echo "Remote user: ${_REMOTE_USER}"
echo "Remote user home: ${_REMOTE_USER_HOME}"
echo "Container user: ${_CONTAINER_USER}"
echo "Container user home: ${_CONTAINER_USER_HOME}"
echo "Selected username for configuration: ${USERNAME}"
echo "History path: ${HISTORY_PATH}"

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
    chmod 666 /.zsh_history # Make it writable by any user
else
    echo "Current user ('${CURRENT_USER}') is not root."
    if [ $CAN_SUDO -eq 1 ]; then
        echo "User can use sudo. Using sudo for root-level operations."
        sudo touch /.zsh_history
        sudo chmod 666 /.zsh_history # Make it writable by any user
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

# Create directory for command history if it doesn't exist
# Note: If using a mounted volume, this directory might already exist
mkdir -p "${HISTORY_PATH}"

# Create and set permissions for .zsh_history file if it doesn't exist
touch "${HISTORY_PATH}/.zsh_history"

# Make the history directory and file accessible to everyone
# This ensures that both root and non-root users can access it
chmod -R 777 "${HISTORY_PATH}"

# If we have information about the specified user, set ownership
if [ -n "${USERNAME}" ]; then
    echo "Setting ${HISTORY_PATH} ownership to ${USERNAME}"
    chown -R ${USERNAME}:${USERNAME} "${HISTORY_PATH}" 2>/dev/null || echo "Warning: Could not change ownership of ${HISTORY_PATH}"
else
    echo "No username specified, keeping default ownership for ${HISTORY_PATH}"
fi

# Determine the home directory of the target user
USER_HOME=""
if [ "${USERNAME}" = "${_REMOTE_USER}" ]; then
    USER_HOME="${_REMOTE_USER_HOME}"
elif [ "${USERNAME}" = "root" ]; then
    USER_HOME="/root"
elif [ -d "/home/${USERNAME}" ]; then
    USER_HOME="/home/${USERNAME}"
else
    echo "Could not determine home directory for ${USERNAME}, using ${_REMOTE_USER_HOME}"
    USER_HOME="${_REMOTE_USER_HOME}"
    USERNAME="${_REMOTE_USER}"
fi

# Fix permissions for zsh plugins if .oh-my-zsh exists for the user
if [ -d "${USER_HOME}/.oh-my-zsh" ]; then
    chown -R ${USERNAME}:${USERNAME} "${USER_HOME}/.oh-my-zsh/custom/plugins/" 2>/dev/null || echo "Warning: Could not change ownership of ${USER_HOME}/.oh-my-zsh/custom/plugins/"
else
    echo ".oh-my-zsh directory not found for user ${USERNAME} at ${USER_HOME}/.oh-my-zsh. Skipping chown for plugins."
fi

# Ensure the .zshrc file exists
touch "${USER_HOME}/.zshrc"
chown ${USERNAME}:${USERNAME} "${USER_HOME}/.zshrc" 2>/dev/null || echo "Warning: Could not change ownership of ${USER_HOME}/.zshrc"

# Append to .zshrc file
cat >> "${USER_HOME}/.zshrc" << ZSHRC_CONFIG

# Added by zsh-history-volume feature
autoload -Uz add-zsh-hook
append_history() { fc -W }
add-zsh-hook precmd append_history
export HISTFILE=${HISTORY_PATH}/.zsh_history
export HISTSIZE=100000
export SAVEHIST=100000
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
ZSHRC_CONFIG

# Set proper permissions
chown ${USERNAME}:${USERNAME} "${USER_HOME}/.zshrc" 2>/dev/null || echo "Warning: Could not change ownership of ${USER_HOME}/.zshrc"
chmod 644 "${USER_HOME}/.zshrc"

echo "Zsh history configuration written to ${USER_HOME}/.zshrc"
echo "History file location: ${HISTORY_PATH}/.zsh_history"
echo "install.sh for zsh-history-volume completed."

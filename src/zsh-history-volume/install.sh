#!/usr/bin/env bash
set -euxo pipefail

# Get the username option, fallback to REMOTE_USER if not provided
USERNAME="${USERNAME:-"${_REMOTE_USER}"}"
# History path is now fixed to /zshhistory/
HISTORY_PATH="/zshhistory"

# Echo statements for debugging purposes
echo "Executing install.sh for zsh-history-volume feature"
echo "Remote user: ${_REMOTE_USER}"
echo "Remote user home: ${_REMOTE_USER_HOME}"
echo "Container user: ${_CONTAINER_USER}"
echo "Container user home: ${_CONTAINER_USER_HOME}"
echo "Selected username for configuration: ${USERNAME}"
echo "Fixed history path: ${HISTORY_PATH}"

# Create directory for zsh history if it doesn't exist
# Note: If using a mounted volume, this directory might already exist
mkdir -p "${HISTORY_PATH}"

# Create and set permissions for .zsh_history file if it doesn't exist
touch "${HISTORY_PATH}/.zsh_history"

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

# Fix permissions for zsh plugins if .oh-my-zsh exists for the remote user
if [ -d "${_REMOTE_USER_HOME}/.oh-my-zsh" ]; then
    chown -R ${_REMOTE_USER}:${_REMOTE_USER} "${_REMOTE_USER_HOME}/.oh-my-zsh/custom/plugins/"
else
    echo ".oh-my-zsh directory not found for user ${_REMOTE_USER} at ${_REMOTE_USER_HOME}/.oh-my-zsh. Skipping chown for plugins."
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

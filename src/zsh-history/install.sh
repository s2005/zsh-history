#!/usr/bin/env bash
set -euxo pipefail

# Echo statements for debugging purposes
echo "Executing install.sh for zsh-history feature"
echo "Remote user: ${_REMOTE_USER}"
echo "Remote user home: ${_REMOTE_USER_HOME}"
echo "Container user: ${_CONTAINER_USER}"
echo "Container user home: ${_CONTAINER_USER_HOME}"

# Create directory for command history
mkdir -p /commandhistory

# Create and set permissions for .zsh_history file
touch /commandhistory/.zsh_history
chown -R ${_REMOTE_USER}:${_REMOTE_USER} /commandhistory

# Fix permissions for zsh plugins if .oh-my-zsh exists for the remote user
if [ -d "${_REMOTE_USER_HOME}/.oh-my-zsh" ]; then
    chown -R ${_REMOTE_USER}:${_REMOTE_USER} "${_REMOTE_USER_HOME}/.oh-my-zsh/custom/plugins/"
else
    echo ".oh-my-zsh directory not found for user ${_REMOTE_USER} at ${_REMOTE_USER_HOME}/.oh-my-zsh. Skipping chown for plugins."
fi

# Create .zshrc file if it doesn't exist
# Use | envsubst to ensure environment variables are expanded properly
cat > "${_REMOTE_USER_HOME}/.zshrc" << 'ZSHRC_CONFIG'
# Added by zsh-history feature (install.sh)
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

# Create a flag file to indicate installation was successful
touch /tmp/zsh_history_configured

echo "Zsh history configuration written to ${_REMOTE_USER_HOME}/.zshrc"
echo "install.sh for zsh-history completed."

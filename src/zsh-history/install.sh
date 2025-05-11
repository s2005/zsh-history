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
if [ "${_REMOTE_USER}" != "root" ]; then
    echo "Remote user ('${_REMOTE_USER}') is not root. Using sudo for root-level operations."
    sudo touch /.zsh_history
    sudo chown -R ${_REMOTE_USER}:${_REMOTE_USER} /.zsh_history

    if [ -d "/.oh-my-zsh/custom/plugins/" ]; then
        sudo chown -R ${_REMOTE_USER}:${_REMOTE_USER} /.oh-my-zsh/custom/plugins/
    else
        echo "Root Oh My Zsh plugins directory (/.oh-my-zsh/custom/plugins/) not found. Skipping chown."
    fi
else
    echo "Remote user is root. Performing root-level operations directly."
    touch /.zsh_history

    if [ -d "/.oh-my-zsh/custom/plugins/" ]; then
        chown -R ${_REMOTE_USER}:${_REMOTE_USER} /.oh-my-zsh/custom/plugins/
    else
        echo "Root Oh My Zsh plugins directory (/.oh-my-zsh/custom/plugins/) not found. Skipping chown."
    fi
fi
echo "Finished managing /.zsh_history and root .oh-my-zsh permissions."

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

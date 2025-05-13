
# Persistent Zsh History (Bind Mount)

Configures persistent Zsh history in a dev container using a bind mount from the project folder.

## Example Usage

```json
"features": {
    "ghcr.io/s2005/zsh-history/zsh-history-bind:1": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| username | Username for whom to configure zsh history | string | "" (defaults to remoteUser) |

## How It Works

This feature uses a bind mount to store Zsh history in a directory on the host machine:

1. The host directory `/workspaces/zsh-history/.history` is mounted to `/commandhistory` in the container
2. The feature configures Zsh to store its history in `/commandhistory/.zsh_history`
3. Permissions are set to allow the specified user to read and write the history file
4. Additional Zsh configuration handles permission edge cases

## Preparation

Before using this feature, you must create the history directory on your host machine:

```bash
mkdir -p /workspaces/zsh-history/.history
```

## Advantages of Bind Mounts

- Direct access to history files from the host machine
- Easy to back up or manage history files using host tools
- Can be integrated with existing dotfiles or configuration management
- Ideal when you want to see or edit history files outside the container

## Dependencies

This feature has the following dependencies that are automatically installed:
- `ghcr.io/devcontainers-contrib/features/zsh-plugins:0`: Provides Zsh plugins support
- `ghcr.io/devcontainers/features/common-utils`: For Zsh and Oh My Zsh installation

The `remoteUser` should have Zsh installed and configured as their default shell.

## Comparing to zsh-history-volume

This feature differs from `zsh-history-volume` in a key way:
- `zsh-history-bind`: Stores history in your **host filesystem** via bind mount
- `zsh-history-volume`: Stores history in a **Docker volume** (isolated from the host)

Choose this feature if you want direct access to your shell history files from the host.

---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/s2005/zsh-history/blob/main/src/zsh-history-bind/devcontainer-feature.json). Add additional notes to a `NOTES.md`._

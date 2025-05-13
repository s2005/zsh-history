
# Persistent Zsh History (Bind Mount)

Configures persistent Zsh history in a dev container using a bind mount from the host filesystem.

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
| historyPath | Path inside the container where the history will be stored | string | "/commandhistory" |
| hostPath | Path on the host machine to bind mount for history storage | string | "${localEnv:HOME}${localEnv:USERPROFILE}/.devcontainer-history" |

## Custom Configuration Example

Using a specific host directory:

```json
"features": {
    "ghcr.io/s2005/zsh-history/zsh-history-bind:1": {
        "username": "vscode",
        "historyPath": "/custom/history/path",
        "hostPath": "${localEnv:HOME}${localEnv:USERPROFILE}/Documents/zsh-history"
    }
}
```

Using a Windows-specific absolute path:

```json
"features": {
    "ghcr.io/s2005/zsh-history/zsh-history-bind:1": {
        "historyPath": "/custom/history/path",
        "hostPath": "D:/DevContainers/zsh-history"
    }
}
```

# This feature configures persistent Zsh history using a bind mount

It ensures that Zsh history is saved to a location on your host machine and shared across terminal sessions.

Key features:
- Automatically binds a host directory for persistent history storage
- Configurable history path and host directory
- Automatically depends on Zsh plugins feature
- Direct access to history files from the host machine

## Advantages of Bind Mounts

- Direct access to history files from the host machine
- Easy to back up or manage history files using host tools
- Can be integrated with existing dotfiles or configuration management
- Ideal when you want to see or edit history files outside the container

## Host Path Considerations

- For Windows paths, use forward slashes: `D:/path/to/history`
- For paths with spaces, ensure proper escaping
- The default path uses environment variables for cross-platform compatibility

## Dependencies

This feature has the following dependencies that are automatically installed:
- `ghcr.io/devcontainers-contrib/features/zsh-plugins:0`: Provides Zsh plugins support
- `ghcr.io/devcontainers/features/common-utils`: For Zsh and Oh My Zsh installation

The `remoteUser` should have Zsh installed and configured as their default shell.

---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/s2005/zsh-history/blob/main/src/zsh-history-bind/devcontainer-feature.json). Add additional notes to a `NOTES.md`._

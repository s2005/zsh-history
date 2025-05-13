# Persistent Zsh History (Volume Mount)

Configures persistent Zsh history in a dev container using a Docker volume mount with fixed paths.

## Example Usage

```json
"features": {
    "ghcr.io/s2005/zsh-history/zsh-history-volume:1": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| username | Username for whom to configure zsh history | string | "" (defaults to remoteUser) |

## Fixed Configuration

This feature uses fixed configuration to ensure consistency:

- **Target Path**: `/zshhistory/` (fixed, not configurable)
- **Volume Name**: `zsh-history-${devcontainerId}` (automatically generated to ensure uniqueness)
- **Mount Type**: `volume` (not configurable)

## Example in devcontainer.json

```json
"features": {
    "ghcr.io/s2005/zsh-history/zsh-history-volume:1": {
        "username": "vscode"
    }
}
```

# This feature configures persistent Zsh history using a Docker volume

It ensures that Zsh history is saved to a Docker volume and shared across terminal sessions and container rebuilds.

Key features:
- Fixed path configuration for consistent usage
- Unique volume name per container for isolation
- Automatic volume mounting for persistent history storage
- Automatically depends on Zsh plugins feature

## Advantages of Volume Mounts

- Data persists even when containers are rebuilt or removed
- No configuration of Docker file sharing required
- Works consistently across platforms
- Optimal for most use cases where direct access to history from host is not needed

## Dependencies

This feature has the following dependencies that are automatically installed:
- `ghcr.io/devcontainers-contrib/features/zsh-plugins:0`: Provides Zsh plugins support
- `ghcr.io/devcontainers/features/common-utils`: For Zsh and Oh My Zsh installation

The `remoteUser` should have Zsh installed and configured as their default shell.

## How the Volume Name Works

The volume name is generated using the pattern `zsh-history-${devcontainerId}`, which ensures:
- Each container gets its own unique history storage
- History persists between container rebuilds
- No conflicts between different dev containers

---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/s2005/zsh-history/blob/main/src/zsh-history-volume/devcontainer-feature.json). Add additional notes to a `NOTES.md`._

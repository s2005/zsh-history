# Dev Container Features: zsh-history

> This repo provides custom [dev container Features](https://containers.dev/implementors/features/) for Zsh history persistence, hosted on GitHub Container Registry. The features in this repository follow the [dev container Feature distribution specification](https://containers.dev/implementors/features-distribution/).

## Features

This repository contains two features for enhancing your development environment with persistent Zsh history:

### `zsh-history-volume`

Uses Docker volumes for persistent Zsh history storage. Ideal for most users and simplest to set up.

```jsonc
{
    "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
    "features": {
        "ghcr.io/s2005/zsh-history/zsh-history-volume:1": {}
    }
}
```

[Learn more about zsh-history-volume](./src/zsh-history-volume/README.md)

### `zsh-history-bind`

Uses bind mounts to host directories for persistent Zsh history storage. Ideal when you need direct access to history files from the host machine.

```jsonc
{
    "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
    "features": {
        "ghcr.io/s2005/zsh-history/zsh-history-bind:1": {}
    }
}
```

[Learn more about zsh-history-bind](./src/zsh-history-bind/README.md)

## Which Feature Should I Use?

- **Use `zsh-history-volume`** if you just want your history to persist between container rebuilds and don't need to access the history files directly.
  
- **Use `zsh-history-bind`** if you want to:
  - Access history files directly from your host machine
  - Back up or manage history files with host tools
  - Share history between different projects or containers
  - Use Windows-specific paths for history storage

Both features provide similar functionality but differ in how they store the history data.

## Custom Configuration Examples

### Volume Mount with Custom Settings

```jsonc
{
    "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
    "features": {
        "ghcr.io/s2005/zsh-history/zsh-history-volume:1": {
            "username": "vscode",
            "historyPath": "/custom/history/path",
            "volumeName": "my-custom-history-volume"
        }
    }
}
```

### Bind Mount with Windows Path

```jsonc
{
    "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
    "features": {
        "ghcr.io/s2005/zsh-history/zsh-history-bind:1": {
            "username": "vscode",
            "historyPath": "/custom/history/path",
            "hostPath": "D:/zsh-history-data"
        }
    }
}
```

## Repo and Feature Structure

Similar to the [`devcontainers/features`](https://github.com/devcontainers/features) repo, this repository has a `src` folder. Each Feature has its own sub-folder, containing at least a `devcontainer-feature.json` and an entrypoint script `install.sh`.

```shell
├── src
│   ├── zsh-history-volume
│   │   ├── devcontainer-feature.json
│   │   ├── install.sh
│   │   └── README.md
│   ├── zsh-history-bind
│   │   ├── devcontainer-feature.json
│   │   ├── install.sh
│   │   └── README.md
...
```

## Distributing Features

### Versioning

Features are individually versioned by the `version` attribute in a Feature's `devcontainer-feature.json`. Features are versioned according to the semver specification. More details can be found in [the dev container Feature specification](https://containers.dev/implementors/features/#versioning).

### Publishing

Features are published to GHCR (GitHub Container Registry) and can be referenced in a `devcontainer.json` with:

```json
"ghcr.io/s2005/zsh-history/zsh-history-volume:1"
```

or

```json
"ghcr.io/s2005/zsh-history/zsh-history-bind:1"
```

## Note for Existing Users

If you were previously using the `zsh-history` feature, we recommend migrating to one of the new features:

- If you were using the default volume mount, switch to `zsh-history-volume`
- If you were using a bind mount, switch to `zsh-history-bind`

The new features provide better schema compliance and a cleaner configuration experience.

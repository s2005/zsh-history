
# Persistent Zsh History (zsh-history)

Configures persistent Zsh history in a dev container.

## Example Usage

```json
"features": {
    "ghcr.io/s2005/zsh-history/zsh-history:1": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|


# This feature configures persistent Zsh history

It ensures that Zsh history is saved to a mounted volume (`/commandhistory/.zsh_history`)
and shared across terminal sessions.

It depends on `ghcr.io/devcontainers/features/common-utils` for Zsh and Oh My Zsh installation.
The `remoteUser` should have Zsh installed and configured as their default shell.
The volume mount for `/commandhistory` must be configured in the main `devcontainer.json` that uses this feature.


---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/s2005/zsh-history/blob/main/src/zsh-history/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._

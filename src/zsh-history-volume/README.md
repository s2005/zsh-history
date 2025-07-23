
# Persistent Zsh History (Volume Mount) (zsh-history-volume)

Configures persistent Zsh history in a dev container using a volume mount. Includes oh-my-zsh permissions fix. Note: '${devcontainerId}' is not standard JSON variable substitution; set the volume name manually or handle substitution in your tooling.

## Example Usage

```json
"features": {
    "ghcr.io/s2005/zsh-history/zsh-history-volume:1": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| username | Username for whom to configure zsh history (default is the remote user) | string | - |



---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/s2005/zsh-history/blob/main/src/zsh-history-volume/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._

# Persistent Zsh History (zsh-history)

Configures persistent Zsh history in a dev container, allowing command history to be preserved across container rebuilds and instances.

## Example Usage

```json
"features": {
    "ghcr.io/s2005/zsh-history:1": {}
},
"mounts": [
    "source=project-zsh-history,target=/commandhistory,type=volume"
]
```

## Requirements

- This feature requires a volume mount to persist history data.
- The volume should be mounted at `/commandhistory`.
- To make this feature work properly, you need to include both the feature and the mount in your devcontainer.json.

## Options

This feature currently has no configurable options.

## How it Works

This feature:

1. Creates a directory at `/commandhistory` in the container
2. Creates a `.zsh_history` file in this directory
3. Configures Zsh to use this file for history storage
4. Sets appropriate permissions

Your command history will persist across container rebuilds as long as the volume persists.

---

_Note: This file was auto-generated. Add additional notes to a `NOTES.md`._

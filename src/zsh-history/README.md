
# ⚠️ DEPRECATED: Persistent Zsh History (zsh-history)

**This feature has been deprecated and will be removed in the future.** 

Please use one of the following replacement features instead:
- **[zsh-history-volume](../zsh-history-volume)**: For Docker volume persistence (recommended for most users)
- **[zsh-history-bind](../zsh-history-bind)**: For bind mounts to host directories

## Migrating from zsh-history

### If you're using volume mounts (default):

Change from:
```json
"features": {
    "ghcr.io/s2005/zsh-history/zsh-history:1": {}
},
"mounts": [
    "source=zsh-history-volume,target=/commandhistory,type=volume"
]
```

To:
```json
"features": {
    "ghcr.io/s2005/zsh-history/zsh-history-volume:1": {}
}
```

### If you're using bind mounts:

Change from:
```json
"features": {
    "ghcr.io/s2005/zsh-history/zsh-history:1": {
        "historyMountSource": "D:/my-history-data",
        "historyMountType": "bind"
    }
},
"mounts": [
    "source=D:/my-history-data,target=/commandhistory,type=bind"
]
```

To:
```json
"features": {
    "ghcr.io/s2005/zsh-history/zsh-history-bind:1": {
        "hostPath": "D:/my-history-data"
    }
}
```

## Why This Change?

The new features provide several benefits:
- Better schema compliance
- Clearer user intent
- Automatic mount configuration
- Simpler usage

## Legacy Documentation (for reference only)

### Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| username | Username for whom to configure zsh history | string | "" (defaults to remoteUser) |
| historyPath | Path inside the container where the history will be stored | string | "/commandhistory" |
| historyMountSource | Source for the history mount (volume name or host path) | string | "zsh-history-volume" |
| historyMountType | Type of mount for history (volume or bind) | string | "volume" |

---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/s2005/zsh-history/blob/main/src/zsh-history/devcontainer-feature.json). Add additional notes to a `NOTES.md`._

# Migrating from zsh-history to the New Features

This document provides a quick guide for migrating from the deprecated `zsh-history` feature to the new `zsh-history-volume` or `zsh-history-bind` features.

## Which Feature Should I Use?

- **Use `zsh-history-volume`** if:
  - You were using the default volume mount setup
  - You just need history persistence across container rebuilds
  - You don't need to access history files from the host

- **Use `zsh-history-bind`** if:
  - You were using bind mounts
  - You want to access history files directly from the host
  - You need to specify a Windows path or custom host directory

## Migration Examples

### Example 1: Basic Volume Mount (most common)

**Before:**
```json
"features": {
    "ghcr.io/s2005/zsh-history/zsh-history:1": {}
},
"mounts": [
    "source=zsh-history-volume,target=/commandhistory,type=volume"
]
```

**After:**
```json
"features": {
    "ghcr.io/s2005/zsh-history/zsh-history-volume:1": {
        "volumeName": "zsh-history-volume"
    }
}
```

## Benefits of the New Features

1. **No Manual Mount Configuration**: The new features automatically configure the appropriate mounts
2. **Clearer Intent**: By choosing a specific feature, you make your intent clear
3. **Schema Compliance**: The new features fully comply with the Dev Container specification
4. **Specialized Options**: Each feature has options specific to its mount type

For more details, see the documentation for [zsh-history-volume](../zsh-history-volume/README.md) and [zsh-history-bind](../zsh-history-bind/README.md).

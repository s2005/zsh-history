# ⚠️ DEPRECATED: Zsh History Feature - Advanced Notes

This feature has been deprecated. Please use one of the following replacement features instead:
- **[zsh-history-volume](../zsh-history-volume)**: For Docker volume persistence
- **[zsh-history-bind](../zsh-history-bind)**: For bind mounts to host directories

## Legacy Documentation (for reference only)

### How the Mount Configuration Works

This feature uses a different approach than directly specifying mounts in the feature definition. Instead:

1. The feature configures environment variables based on the options you provide
2. The installation script reports the exact mount command you need to include in your devcontainer.json
3. You must manually add this mount to your devcontainer.json

### Mount Types Explained

1. **Volume Mount (default)**:
   - Uses Docker named volumes
   - Data persists across container rebuilds
   - Cannot be easily accessed from the host
   - Best for most use cases
   - Example: `"source=zsh-history-volume,target=/commandhistory,type=volume"`

2. **Bind Mount**:
   - Mounts a directory from the host into the container
   - Allows direct access to history files from the host
   - Must specify a valid host path
   - Example: `"source=D:/my-history-data,target=/commandhistory,type=bind"`

### Environment Variables

The feature sets the following container environment variables:
- `ZSH_HISTORY_PATH`: Points to the configured history path
- `HISTORY_MOUNT_SOURCE`: Contains the source for the mount (volume name or host path)
- `HISTORY_MOUNT_TYPE`: Contains the type of mount ("volume" or "bind")

### Dependency Management

This feature automatically depends on:
- `ghcr.io/devcontainers-contrib/features/zsh-plugins:0`: For Zsh plugins support
- `ghcr.io/devcontainers/features/common-utils`: For Zsh and Oh My Zsh installation

## Why Migrate to the New Features?

The new features provide several benefits:
- Better schema compliance
- Clearer user intent 
- Automatic mount configuration
- Simpler usage
- No need to manually add mounts to devcontainer.json

## How to Migrate

See the [README.md](./README.md) for migration instructions.

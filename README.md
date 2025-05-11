# Dev Container Features: zsh-history

> This repo provides a starting point and example for creating your own custom [dev container Features](https://containers.dev/implementors/features/), hosted for free on GitHub Container Registry. The example in this repository follows the [dev container Feature distribution specification](https://containers.dev/implementors/features-distribution/).

## Features

This repository contains a _collection_ of Features for enhancing your development environment.

### `zsh-history`

The `zsh-history` feature configures persistent Zsh history in a dev container, ensuring your command history is preserved across sessions.

```jsonc
{
    "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
    "features": {
        "ghcr.io/s2005/zsh-history/zsh-history:1": {}
    },
    "mounts": [
        "source=zsh-history,target=/commandhistory,type=volume"
    ]
}
```

## Repo and Feature Structure

Similar to the [`devcontainers/features`](https://github.com/devcontainers/features) repo, this repository has a `src` folder. Each Feature has its own sub-folder, containing at least a `devcontainer-feature.json` and an entrypoint script `install.sh`.

```shell
├── src
│   ├── zsh-history
│   │   ├── devcontainer-feature.json
│   │   ├── install.sh
│   │   ├── README.md
│   │   └── NOTES.md
|   ├── ...
│   │   ├── devcontainer-feature.json
│   │   └── install.sh
...
```

An [implementing tool](https://containers.dev/supporting#tools) will composite [the documented dev container properties](https://containers.dev/implementors/features/#devcontainer-feature-json-properties) from the feature's `devcontainer-feature.json` file, and execute in the `install.sh` entrypoint script in the container during build time.  Implementing tools are also free to process attributes under the `customizations` property as desired.

## Distributing Features

### Versioning

Features are individually versioned by the `version` attribute in a Feature's `devcontainer-feature.json`. Features are versioned according to the semver specification. More details can be found in [the dev container Feature specification](https://containers.dev/implementors/features/#versioning).

### Publishing

> NOTE: The Distribution spec can be [found here](https://containers.dev/implementors/features-distribution/).  
>
> While any registry [implementing the OCI Distribution spec](https://github.com/opencontainers/distribution-spec) can be used, this template will leverage GHCR (GitHub Container Registry) as the backing registry.

Features are meant to be easily sharable units of dev container configuration and installation code.  

This repo contains a **GitHub Action** [workflow](.github/workflows/release.yaml) that will publish each Feature to GHCR.

_Allow GitHub Actions to create and approve pull requests_ should be enabled in the repository's `Settings > Actions > General > Workflow permissions` for auto generation of `src/<feature>/README.md` per Feature (which merges any existing `src/<feature>/NOTES.md`).

By default, each Feature will be prefixed with the `<owner/<repo>` namespace. For example, the features in this repository can be referenced in a `devcontainer.json` with:

```json
ghcr.io/s2005/zsh-history/zsh-history:1
```

The provided GitHub Action will also publish a "metadata" package with just the namespace, eg: `ghcr.io/s2005/zsh-history`. This contains information useful for tools aiding in Feature discovery.

### Marking Feature Public

Note that by default, GHCR packages are marked as `private`. To stay within the free tier, Features need to be marked as `public`.

This can be done by navigating to the Feature's "package settings" page in GHCR, and setting the visibility to 'public`. The URL may look something like:

```text
https://github.com/users/s2005/packages/container/zsh-history/settings
```

### Adding Features to the Index

If you'd like your Features to appear in the [public index](https://containers.dev/features) so that other community members can find them, you can do the following:

* Go to [github.com/devcontainers/devcontainers.github.io](https://github.com/devcontainers/devcontainers.github.io)
  * This is the GitHub repo backing the [containers.dev](https://containers.dev/) spec site
* Open a PR to modify the [collection-index.yml](https://github.com/devcontainers/devcontainers.github.io/blob/gh-pages/_data/collection-index.yml) file

This index is from where [supporting tools](https://containers.dev/supporting) like [VS Code Dev Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) and [GitHub Codespaces](https://github.com/features/codespaces) surface Features for their dev container creation UI.

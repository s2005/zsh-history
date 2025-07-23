# Changelog

All notable changes to the zsh-history features will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.1] - 2025-07-23

### Added
- Oh-My-Zsh permissions fix for both `zsh-history-bind` and `zsh-history-volume` features
- Automatic ownership correction for `~/.oh-my-zsh/custom/plugins/` directory
- Comprehensive test coverage for oh-my-zsh permissions scenarios
- Local testing script for verifying permissions fix

### Changed
- Updated feature descriptions to mention oh-my-zsh permissions fix
- Improved error handling and logging when oh-my-zsh directory is not found

### Fixed
- Permission issues with oh-my-zsh plugins when using zsh-history features
- Consistent permissions fix implementation across supported features

## [1.0.0] - Previous Release

### Added
- `zsh-history-bind` feature for bind mount persistence
- `zsh-history-volume` feature for volume mount persistence
- Basic zsh history configuration and persistence

### Deprecated
- `zsh-history` (original feature) - Users should migrate to `zsh-history-bind` or `zsh-history-volume`

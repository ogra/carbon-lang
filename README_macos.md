# Carbon Language for macOS (Intel/Apple Silicon)

This repository is a fork of [Carbon language](https://github.com/carbon-language/carbon-lang) and for building macOS binaries.

## Changes to original repo:

Tag names and version strings are renamed. (Because of version detection by [proto](https://moonrepo.dev/proto) version manager.)

## Installation via proto

1. [Install proto](https://moonrepo.dev/docs/proto/install)
2. `proto plugin add carbon https://raw.githubusercontent.com/ogra/carbon-lang/macosbuild/proto/plugins/carbon.toml`
3. `proto list-remote carbon`
4. `proto install carbon <version>` (e.g. `proto install carbon 0.0.0-pre.0+nightly20240810`)

## Uninstallation

`proto uninstall carbon`

For details, see [proto's documentation](https://moonrepo.dev/docs/proto).

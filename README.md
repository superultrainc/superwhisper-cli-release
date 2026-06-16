# superwhisper-cli-release

Public release artifacts for the [superwhisper](https://superwhisper.com) CLI.
The CLI source lives in a private repo; this repo holds only the prebuilt
universal macOS binary and the install script.

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/superultrainc/superwhisper-cli-release/main/install.sh | bash
```

The script installs the latest release to `/usr/local/bin` (or `~/.local/bin`
if that isn't writable). Override with `SUPERWHISPER_VERSION` or
`SUPERWHISPER_BINDIR`.

## Releases

Binaries are published here automatically by the CLI repo's release workflow
when a `v*` tag is pushed. Each release includes the universal macOS tarball
and a `checksums.txt`.

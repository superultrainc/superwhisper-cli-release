#!/usr/bin/env bash
# superwhisper CLI installer.
# Downloads the latest prebuilt universal macOS binary from the
# superwhisper-cli-release GitHub releases and installs it.
#
#   curl -fsSL https://raw.githubusercontent.com/superultrainc/superwhisper-cli-release/main/install.sh | bash
#
# Env overrides:
#   SUPERWHISPER_VERSION   install a specific tag (e.g. v0.1.0) instead of latest
#   SUPERWHISPER_BINDIR    install directory (default: /usr/local/bin or ~/.local/bin)

set -euo pipefail

REPO="superultrainc/superwhisper-cli-release"

err() { printf '\033[31merror:\033[0m %s\n' "$1" >&2; exit 1; }
info() { printf '\033[36m==>\033[0m %s\n' "$1"; }

[ "$(uname -s)" = "Darwin" ] || err "superwhisper is macOS-only."

# Resolve the version (tag) to install.
tag="${SUPERWHISPER_VERSION:-}"
if [ -z "$tag" ]; then
  info "Resolving latest release..."
  tag=$(curl -fsSL "https://api.github.com/repos/$REPO/releases/latest" \
    | grep '"tag_name"' | head -1 | cut -d'"' -f4)
  [ -n "$tag" ] || err "Could not determine the latest release tag."
fi

asset="superwhisper-${tag}-macos-universal.tar.gz"
base="https://github.com/$REPO/releases/download/$tag"

# Pick an install dir we can write to.
bindir="${SUPERWHISPER_BINDIR:-}"
if [ -z "$bindir" ]; then
  if [ -w /usr/local/bin ] 2>/dev/null; then
    bindir="/usr/local/bin"
  else
    bindir="$HOME/.local/bin"
  fi
fi
mkdir -p "$bindir"

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

info "Downloading $asset ($tag)..."
curl -fsSL "$base/$asset" -o "$tmp/$asset" || err "Download failed: $base/$asset"

# Verify the checksum if checksums.txt is published with the release.
if curl -fsSL "$base/checksums.txt" -o "$tmp/checksums.txt" 2>/dev/null; then
  info "Verifying checksum..."
  ( cd "$tmp" && grep "$asset" checksums.txt | shasum -a 256 -c - ) \
    || err "Checksum verification failed."
fi

info "Installing to $bindir/superwhisper..."
tar -xzf "$tmp/$asset" -C "$tmp"
install -m 0755 "$tmp/superwhisper" "$bindir/superwhisper"

info "Installed: $("$bindir/superwhisper" --version)"
case ":$PATH:" in
  *":$bindir:"*) ;;
  *) printf '\033[33mnote:\033[0m %s is not on your PATH. Add it:\n  export PATH="%s:$PATH"\n' "$bindir" "$bindir" ;;
esac

#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=tools/project-env.sh
source "$SCRIPT_DIR/project-env.sh"

MISE_VERSION="2026.9.12"
MISE="$PROJECT_ROOT/.local/bin/mise"

case "$(uname -s)-$(uname -m)" in
Linux-x86_64) mise_platform="linux-x64" ;;
Linux-aarch64 | Linux-arm64) mise_platform="linux-arm64" ;;
Darwin-x86_64) mise_platform="macos-x64" ;;
Darwin-arm64) mise_platform="macos-arm64" ;;
*)
  echo "Unsupported platform: $(uname -s) $(uname -m)" >&2
  exit 1
  ;;
esac

mkdir -p \
  "$PROJECT_ROOT/.local/bin" \
  "$MISE_DATA_DIR" \
  "$MISE_CACHE_DIR" \
  "$MISE_STATE_DIR" \
  "$MISE_CONFIG_DIR"

if [[ ! -x $MISE ]] || [[ $($MISE --version 2>/dev/null | awk '{print $1}') != "$MISE_VERSION" ]]; then
  asset="mise-v${MISE_VERSION}-${mise_platform}"
  archive="$asset.tar.xz"
  base_url="https://github.com/jdx/mise/releases/download/v${MISE_VERSION}"
  tmp_dir="$(mktemp -d "$PROJECT_ROOT/.local/mise-download.XXXXXX")"
  trap 'rm -rf "$tmp_dir"' EXIT

  echo "Downloading mise $MISE_VERSION..."
  curl --fail --location --retry 3 --retry-all-errors --connect-timeout 15 \
    --proto '=https' --tlsv1.2 "$base_url/$archive" -o "$tmp_dir/$archive"
  curl --fail --location --retry 3 --retry-all-errors --connect-timeout 15 \
    --proto '=https' --tlsv1.2 \
    "$base_url/SHASUMS256.txt" -o "$tmp_dir/SHASUMS256.txt"

  expected_checksum="$(awk -v archive="./$archive" '$2 == archive { print $1 }' "$tmp_dir/SHASUMS256.txt")"
  if [[ -z $expected_checksum ]]; then
    echo "No checksum found for $archive" >&2
    exit 1
  fi
  if command -v sha256sum >/dev/null 2>&1; then
    actual_checksum="$(sha256sum "$tmp_dir/$archive" | awk '{ print $1 }')"
  elif command -v shasum >/dev/null 2>&1; then
    actual_checksum="$(shasum -a 256 "$tmp_dir/$archive" | awk '{ print $1 }')"
  else
    echo "sha256sum or shasum is required to verify $archive" >&2
    exit 1
  fi
  if [[ $actual_checksum != "$expected_checksum" ]]; then
    echo "Checksum verification failed for $archive" >&2
    exit 1
  fi

  tar -xJf "$tmp_dir/$archive" -C "$tmp_dir"
  mise_binary="$(find "$tmp_dir" -type f -name mise -print -quit)"
  if [[ -z $mise_binary ]]; then
    echo "mise binary not found in $archive" >&2
    exit 1
  fi
  install -m 0755 "$mise_binary" "$MISE"
fi

cd "$PROJECT_ROOT"
"$MISE" install
env -u DEBUG "$MISE" exec -- gem install bundler --version 2.5.23 --no-document

bundle_installed=false
for attempt in 1 2 3; do
  if env -u DEBUG "$MISE" exec -- bundle install; then
    bundle_installed=true
    break
  fi
  echo "Bundler download failed (attempt $attempt/3); retrying..." >&2
done

if ! $bundle_installed; then
  echo "Unable to install Gem dependencies after 3 attempts." >&2
  exit 1
fi

"$MISE" lock ruby

echo
echo "Project environment is ready."
echo "Run commands with: ./tools/env <command>"
echo "Or activate it with: source tools/activate.sh"

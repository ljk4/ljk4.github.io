#!/usr/bin/env bash

# Shared project-local paths. Source this file or use it from another script.
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

export MISE_DATA_DIR="$PROJECT_ROOT/.local/share/mise"
export MISE_CACHE_DIR="$PROJECT_ROOT/.local/cache/mise"
export MISE_STATE_DIR="$PROJECT_ROOT/.local/state/mise"
export MISE_CONFIG_DIR="$PROJECT_ROOT/.local/config/mise"
export MISE_GLOBAL_CONFIG_FILE="$PROJECT_ROOT/.local/config/mise/config.toml"
export MISE_TRUSTED_CONFIG_PATHS="$PROJECT_ROOT"
export BUNDLE_APP_CONFIG="$PROJECT_ROOT/.local/bundle-config"
export BUNDLE_PATH="$PROJECT_ROOT/.local/bundle"
export BUNDLE_JOBS="${BUNDLE_JOBS:-4}"
export BUNDLE_RETRY="${BUNDLE_RETRY:-5}"
export GEM_SPEC_CACHE="$PROJECT_ROOT/.local/cache/gem/specs"
export PATH="$PROJECT_ROOT/.local/bin:$PATH"

# html-proofer treats any generic DEBUG value as a request for ruby/debug.
unset DEBUG

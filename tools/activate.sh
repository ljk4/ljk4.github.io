#!/usr/bin/env bash

if [[ ${BASH_SOURCE[0]} == "$0" ]]; then
  echo "Source this script instead: source tools/activate.sh" >&2
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=tools/project-env.sh
source "$SCRIPT_DIR/project-env.sh"

if [[ ! -x $PROJECT_ROOT/.local/bin/mise ]]; then
  echo "Project environment is not installed. Run: ./tools/bootstrap.sh" >&2
  return 1
fi

eval "$("$PROJECT_ROOT/.local/bin/mise" activate bash)"
cd "$PROJECT_ROOT"

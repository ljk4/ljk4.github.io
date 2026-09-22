#!/usr/bin/env bash
#
# Run jekyll serve and then launch the site

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
prod=false
host="127.0.0.1"

help() {
  echo "Usage:"
  echo
  echo "   bash /path/to/run [options]"
  echo
  echo "Options:"
  echo "     -H, --host [HOST]    Host to bind to."
  echo "     -p, --production     Run Jekyll in 'production' mode."
  echo "     -h, --help           Print this help information."
}

while (($#)); do
  opt="$1"
  case $opt in
  -H | --host)
    host="$2"
    shift 2
    ;;
  -p | --production)
    prod=true
    shift
    ;;
  -h | --help)
    help
    exit 0
    ;;
  *)
    echo -e "> Unknown option: '$opt'\n"
    help
    exit 1
    ;;
  esac
done

command=("$SCRIPT_DIR/env" bundle exec jekyll serve --livereload --host "$host")

if [[ -f $SCRIPT_DIR/../_config_dev.yml ]]; then
  command+=(--config _config.yml,_config_dev.yml)
fi

if $prod; then
  command=(env JEKYLL_ENV=production "${command[@]}")
fi

if [[ -n ${WSL_DISTRO_NAME:-} ]] || \
  { [[ -r /proc/version ]] && grep -qi microsoft /proc/version; } || \
  { [[ -r /proc/1/cgroup ]] && grep -q docker /proc/1/cgroup; }; then
  command+=(--force_polling)
fi

printf '\n> '
printf '%q ' "${command[@]}"
printf '\n\n'
exec "${command[@]}"

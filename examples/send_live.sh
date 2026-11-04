#!/bin/sh
set -eu

if [ "$#" -ne 3 ]; then
  printf 'Usage: %s SIGNAL_ID TICKER TARGET\n' "$0" >&2
  exit 2
fi

root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
exec python3 "$root/signal_client.py" create "$1" LIVE "$2" "$3"

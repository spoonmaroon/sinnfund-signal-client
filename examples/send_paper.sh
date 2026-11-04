#!/bin/sh
set -eu

if [ "$#" -ne 5 ]; then
  printf 'Usage: %s SIGNAL_ID TICKER TARGET FUTURE_UNIX_TIME LIMIT_PRICE\n' "$0" >&2
  exit 2
fi

root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
exec python3 "$root/signal_client.py" create "$1" PAPER "$2" "$3" "$4" --limit-price "$5"

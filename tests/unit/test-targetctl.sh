#!/usr/bin/env bash
set -Eeuo pipefail

root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd -P)
temporary=$(mktemp -d)
trap 'rm -rf -- "$temporary"' EXIT
export XDG_STATE_HOME="$temporary/state"

python3 "$root/scripts/targetctl" set 10.10.11.42 laboratory
[[ $(python3 "$root/scripts/targetctl" show) == '10.10.11.42 laboratory' ]]
python3 "$root/scripts/targetctl" show --format json | python3 -c 'import json,sys; assert json.load(sys.stdin)["name"] == "laboratory"'
if python3 "$root/scripts/targetctl" set 999.1.1.1 invalid 2>/dev/null; then exit 1; fi
python3 "$root/scripts/targetctl" clear
if python3 "$root/scripts/targetctl" show >/dev/null; then exit 1; fi
printf 'targetctl: OK\n'


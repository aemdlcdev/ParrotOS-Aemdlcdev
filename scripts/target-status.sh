#!/usr/bin/env bash
set -u

state=${XDG_STATE_HOME:-"$HOME/.local/state"}/aemdlc-environment/target.json
if [[ ! -s $state ]]; then
  printf '%%{F#e51d0b} %%{F#ffffff}No target%%{F-}\n'
  exit 0
fi

python3 - "$state" <<'PY'
import json
import sys

try:
    with open(sys.argv[1], encoding="utf-8") as stream:
        target = json.load(stream)
    print(f"%{{F#e51d0b}} %{{F#ffffff}}{target['name']} - {target['address']}%{{F-}}")
except (OSError, KeyError, ValueError, TypeError):
    print("%{F#e51d0b} %{F#ffffff}No target%{F-}")
PY

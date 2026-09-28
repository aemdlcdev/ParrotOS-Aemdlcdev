#!/usr/bin/env bash
set -u

state=${XDG_STATE_HOME:-"$HOME/.local/state"}/aemdlc-environment/target.json
if [[ ! -s $state ]]; then printf '󰓾 sin objetivo\n'; exit 0; fi
python3 - "$state" <<'PY'
import json, sys
try:
    with open(sys.argv[1], encoding="utf-8") as stream:
        item = json.load(stream)
    print(f"󰓾 {item['address']} · {item['name']}")
except (OSError, KeyError, ValueError, TypeError):
    print("󰓾 estado inválido")
PY


#!/usr/bin/env bash
set -Eeuo pipefail

config=${XDG_CONFIG_HOME:-"$HOME/.config"}/polybar/config.ini
polybar-msg cmd quit >/dev/null 2>&1 || true
for _ in {1..20}; do pgrep -u "$UID" -x polybar >/dev/null || break; sleep 0.1; done

mapfile -t monitors < <(polybar --list-monitors | cut -d: -f1)
if ((${#monitors[@]} == 0)); then
  polybar --config="$config" main &
else
  for monitor in "${monitors[@]}"; do MONITOR=$monitor polybar --config="$config" main & done
fi


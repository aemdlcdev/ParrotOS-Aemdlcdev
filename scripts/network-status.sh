#!/usr/bin/env bash
set -u

route=$(ip -o route show default 2>/dev/null | head -n 1)
iface=$(awk '{for (field=1; field<=NF; field++) if ($field=="dev") print $(field+1)}' <<<"$route")
if [[ -z $iface ]]; then
  printf '%%{F#2495e7} %%{F#ffffff}Sin conexión%%{F-}\n'
  exit 0
fi

address=$(ip -o -4 addr show dev "$iface" scope global 2>/dev/null | awk 'NR==1 {sub(/\/.*/, "", $4); print $4}')
if [[ -z $address ]]; then
  printf '%%{F#2495e7} %%{F#ffffff}%s%%{F-}\n' "$iface"
  exit 0
fi

if [[ $iface == wl* ]]; then icon=''; else icon=''; fi
printf '%%{F#2495e7}%s %%{F#ffffff}%s%%{F-}\n' "$icon" "$address"

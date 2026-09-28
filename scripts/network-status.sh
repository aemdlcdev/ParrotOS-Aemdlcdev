#!/usr/bin/env bash
set -u

route=$(ip -o route show default 2>/dev/null | head -n 1)
iface=$(awk '{for(i=1;i<=NF;i++) if($i=="dev") print $(i+1)}' <<<"$route")
if [[ -z $iface ]]; then printf '󰖪 sin red\n'; exit 0; fi
address=$(ip -o -4 addr show dev "$iface" scope global 2>/dev/null | awk 'NR==1 {sub(/\/.*/, "", $4); print $4}')
[[ -n $address ]] || { printf '󰖪 %s\n' "$iface"; exit 0; }
if [[ $iface == wl* ]]; then icon='󰖩'; else icon='󰈀'; fi
printf '%s %s\n' "$icon" "$address"


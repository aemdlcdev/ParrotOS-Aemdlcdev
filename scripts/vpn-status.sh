#!/usr/bin/env bash
set -u

patterns=${AEM_VPN_PATTERNS:-'tun tap wg'}
while read -r iface; do
  for prefix in $patterns; do
    if [[ $iface == "$prefix"* ]]; then
      address=$(ip -o -4 addr show dev "$iface" scope global 2>/dev/null | awk 'NR==1 {sub(/\/.*/, "", $4); print $4}')
      if [[ -n $address ]]; then
        printf '%%{F#1bbf3e}󰆧 %%{F#ffffff}%s%%{F-}\n' "$address"
        exit 0
      fi
    fi
  done
done < <(ip -o link show | awk -F': ' '{print $2}' | cut -d@ -f1)
printf '%%{F#1bbf3e}󰆧 %%{F#ffffff}Disconnected%%{F-}\n'

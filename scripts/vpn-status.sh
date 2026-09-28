#!/usr/bin/env bash
set -u

patterns=${AEM_VPN_PATTERNS:-'tun tap wg'}
while read -r iface; do
  for prefix in $patterns; do
    if [[ $iface == "$prefix"* ]]; then
      address=$(ip -o -4 addr show dev "$iface" scope global 2>/dev/null | awk 'NR==1 {sub(/\/.*/, "", $4); print $4}')
      [[ -n $address ]] && { printf '󰌆 %s\n' "$address"; exit 0; }
    fi
  done
done < <(ip -o link show | awk -F': ' '{print $2}' | cut -d@ -f1)
printf '󰌊 VPN off\n'


#!/usr/bin/env bash
set -u
shopt -s nullglob
for battery in /sys/class/power_supply/*; do
  [[ -r $battery/type && $(<"$battery/type") == Battery ]] || continue
  capacity=$(<"$battery/capacity")
  status=$(<"$battery/status")
  case "$status" in Charging) icon='󰂄' ;; Full) icon='󰁹' ;; *) icon='󰁿' ;; esac
  printf '%s %s%%\n' "$icon" "$capacity"
  exit 0
done


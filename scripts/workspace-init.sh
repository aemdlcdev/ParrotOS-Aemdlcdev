#!/usr/bin/env bash
set -Eeuo pipefail

mapfile -t monitors < <(bspc query -M --names)
((${#monitors[@]})) || exit 0
if ((${#monitors[@]} == 1)); then
  bspc monitor "${monitors[0]}" -d I II III IV V VI VII VIII IX X
else
  bspc monitor "${monitors[0]}" -d I II III IV V
  bspc monitor "${monitors[1]}" -d VI VII VIII IX X
fi


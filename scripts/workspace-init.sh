#!/usr/bin/env bash
set -Eeuo pipefail

mapfile -t monitors < <(bspc query -M --names)
((${#monitors[@]})) || exit 0
if ((${#monitors[@]} == 1)); then
  bspc monitor "${monitors[0]}" -d 1 2 3 4 5 6 7 8 9 10
else
  bspc monitor "${monitors[0]}" -d 1 2 3 4 5
  bspc monitor "${monitors[1]}" -d 6 7 8 9 10
fi


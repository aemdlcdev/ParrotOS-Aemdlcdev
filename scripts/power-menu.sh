#!/usr/bin/env bash
set -Eeuo pipefail
theme=${XDG_CONFIG_HOME:-"$HOME/.config"}/aemdlc-environment/rofi/power-menu.rasi
choice=$(printf '%s\n' ' Lock' ' Sleep' '󰗼 Logout' ' Restart' ' Shutdown' | rofi -dmenu -i -p 'System' -theme "$theme") || exit 0
case "$choice" in
  ' Lock') exec i3lock -c 10141f ;;
  ' Sleep') systemctl suspend ;;
  '󰗼 Logout') bspc quit ;;
  ' Restart'|' Shutdown')
    confirm=$(printf '%s\n' 'Cancel' "Confirm $choice" | rofi -dmenu -p 'Confirmation' -theme "$theme") || exit 0
    [[ $confirm == "Confirm $choice" ]] || exit 0
    [[ $choice == ' Restart' ]] && systemctl reboot || systemctl poweroff
    ;;
esac


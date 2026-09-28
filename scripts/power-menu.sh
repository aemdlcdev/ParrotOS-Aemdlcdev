#!/usr/bin/env bash
set -Eeuo pipefail
theme=${XDG_CONFIG_HOME:-"$HOME/.config"}/aemdlc-environment/rofi/power-menu.rasi
choice=$(printf '%s\n' 'Bloquear' 'Suspender' 'Cerrar sesión' 'Reiniciar' 'Apagar' | rofi -dmenu -i -p 'Sistema' -theme "$theme") || exit 0
case "$choice" in
  Bloquear) exec i3lock -c 10141f ;;
  Suspender) systemctl suspend ;;
  'Cerrar sesión') bspc quit ;;
  Reiniciar|Apagar)
    confirm=$(printf '%s\n' 'Cancelar' "Confirmar $choice" | rofi -dmenu -p 'Confirmación' -theme "$theme") || exit 0
    [[ $confirm == "Confirmar $choice" ]] || exit 0
    [[ $choice == Reiniciar ]] && systemctl reboot || systemctl poweroff
    ;;
esac


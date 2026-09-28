#!/usr/bin/env bash
set -Eeuo pipefail
theme=${1:-}
[[ $theme == nocturne || $theme == daybreak ]] || { printf 'Uso: theme-switcher nocturne|daybreak\n' >&2; exit 2; }
config=${XDG_CONFIG_HOME:-"$HOME/.config"}
data=${XDG_DATA_HOME:-"$HOME/.local/share"}/aemdlc-environment/themes
install -m 0644 "$data/polybar/$theme.ini" "$config/polybar/theme.ini"
install -m 0644 "$data/kitty/$theme.conf" "$config/kitty/theme.conf"
install -m 0644 "$data/rofi/$theme.rasi" "$config/aemdlc-environment/rofi/theme.rasi"
polybar-msg cmd restart >/dev/null 2>&1 || true
pkill -USR1 -x sxhkd 2>/dev/null || true
printf 'Tema activo: %s\n' "$theme"


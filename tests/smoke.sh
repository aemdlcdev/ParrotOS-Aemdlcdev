#!/usr/bin/env bash
set -Eeuo pipefail

root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)
required=(
  install.sh uninstall.sh README.md LICENSE THIRD_PARTY.md
  config/bspwm/bspwmrc config/sxhkd/sxhkdrc config/polybar/config.ini
  config/picom/picom.conf config/kitty/kitty.conf config/rofi/launcher.rasi
  scripts/targetctl scripts/network-status.sh scripts/vpn-status.sh
)
for path in "${required[@]}"; do [[ -s $root/$path ]] || { printf 'Falta: %s\n' "$path" >&2; exit 1; }; done
needle='Balth''ael'
grep -Rq --exclude='FASE-1-INVENTARIO-FUNCIONAL.md' --exclude='README.md' "$needle" "$root" && {
  printf 'Se encontró branding ajeno fuera de las menciones autorizadas\n' >&2
  exit 1
}
printf 'smoke: OK\n'


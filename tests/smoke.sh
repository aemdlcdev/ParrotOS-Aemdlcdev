#!/usr/bin/env bash
set -Eeuo pipefail

root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)
required=(
  install.sh uninstall.sh README.md LICENSE THIRD_PARTY.md
  config/bspwm/bspwmrc config/sxhkd/sxhkdrc config/polybar/config.ini
  config/picom/picom.conf config/kitty/kitty.conf config/rofi/launcher.rasi
  scripts/targetctl scripts/network-status.sh scripts/vpn-status.sh
  components/root-integration.sh config/zsh/root-init.zsh scripts/targetctl-system.sh
)
for path in "${required[@]}"; do [[ -s $root/$path ]] || { printf 'Falta: %s\n' "$path" >&2; exit 1; }; done
source "$root/metadata/versions.conf"
((${#NERD_FONT_FAMILIES[@]} == ${#NERD_FONT_SHA256S[@]})) || {
  printf 'Metadatos de Nerd Fonts incompletos\n' >&2
  exit 1
}
for checksum in "${NERD_FONT_SHA256S[@]}"; do
  [[ $checksum =~ ^[0-9a-fA-F]{64}$ ]] || {
    printf 'Checksum de Nerd Fonts ausente o inválido\n' >&2
    exit 1
  }
done
needle='Balth''ael'
grep -Rq --exclude='FASE-1-INVENTARIO-FUNCIONAL.md' --exclude='README.md' "$needle" "$root" && {
  printf 'Se encontró branding ajeno fuera de las menciones autorizadas\n' >&2
  exit 1
}
bash "$root/tests/visual-contract.sh"
bash "$root/tests/unit/test-system-paths.sh"
bash "$root/tests/unit/test-root-integration-dry-run.sh"
bash "$root/tests/unit/test-targetctl-system.sh"
printf 'smoke: OK\n'


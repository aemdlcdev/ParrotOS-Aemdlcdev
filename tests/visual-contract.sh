#!/usr/bin/env bash
set -Eeuo pipefail

root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)

expect_line() {
  local file=$1 expected=$2
  grep -Fqx -- "$expected" "$root/$file" || {
    printf 'Contrato visual incumplido: %s no contiene %s\n' "$file" "$expected" >&2
    return 1
  }
}

expect_line config/polybar/bars.ini 'offset-x = 4%'
expect_line config/polybar/bars.ini 'offset-x = 14.3%'
expect_line config/polybar/bars.ini 'offset-x = 79.7%'
expect_line config/polybar/bars.ini 'font-1 = Hack Nerd Font Mono:size=22;6'
expect_line config/polybar/bars.ini 'width = 40'
expect_line config/polybar/modules.ini 'content-font = 2'
expect_line config/polybar/themes/nocturne.ini 'workspace-active = #E53935'
expect_line config/kitty/kitty.conf 'font_family Hack Nerd Font'
expect_line config/kitty/kitty.conf 'font_size 13'
expect_line config/kitty/kitty.conf 'window_padding_width 20'
expect_line config/kitty/kitty.conf 'background_opacity 0.85'
expect_line config/kitty/themes/nocturne.conf 'background #1a1b26'
expect_line config/kitty/themes/nocturne.conf 'foreground #a9b1d6'
expect_line config/picom/picom.conf 'corner-radius = 20;'
expect_line config/picom/picom.conf 'shadow-radius = 15;'
expect_line config/picom/picom.conf 'shadow-opacity = 0.5;'
expect_line config/picom/picom.conf 'use-damage = false;'
expect_line config/bspwm/bspwmrc 'bspc config border_width 0'
expect_line config/bspwm/bspwmrc 'bspc config split_ratio 0.52'
expect_line config/rofi/power-menu.rasi '  location: 3;'
expect_line config/rofi/themes/nocturne.rasi '  background: #ffffffff;'

printf 'visual-contract: OK\n'

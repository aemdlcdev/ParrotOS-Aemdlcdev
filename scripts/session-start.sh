#!/usr/bin/env bash
set -u

data_home=${XDG_DATA_HOME:-"$HOME/.local/share"}
bin_dir="$data_home/aemdlc-environment/bin"

wallpaper=${AEM_WALLPAPER:-"$data_home/aemdlc-environment/wallpapers/aemdlc-nocturne.png"}
if [[ -n $wallpaper && -r $wallpaper ]]; then
  feh --no-fehbg --bg-fill "$wallpaper" &
fi

pgrep -u "$UID" -x sxhkd >/dev/null || sxhkd &
pgrep -u "$UID" -x picom >/dev/null || picom --config "${XDG_CONFIG_HOME:-$HOME/.config}/picom/picom.conf" &
"$bin_dir/launch-polybar" &

if command -v flameshot >/dev/null && ! pgrep -u "$UID" -x flameshot >/dev/null; then
  flameshot &
fi

if command -v vmware-user-suid-wrapper >/dev/null; then
  pgrep -u "$UID" -f vmware-user-suid-wrapper >/dev/null || vmware-user-suid-wrapper &
fi


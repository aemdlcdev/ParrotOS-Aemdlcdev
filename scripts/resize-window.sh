#!/usr/bin/env bash
set -Eeuo pipefail

direction=${1:-}
step=${AEM_RESIZE_STEP:-32}
[[ $step =~ ^[1-9][0-9]*$ ]] || exit 2

case "$direction" in
  west)  primary=left;   fallback=right;  x="-$step"; y=0 ;;
  east)  primary=right;  fallback=left;   x="$step";  y=0 ;;
  north) primary=top;    fallback=bottom; x=0; y="-$step" ;;
  south) primary=bottom; fallback=top;    x=0; y="$step" ;;
  *) printf 'Dirección inválida: %s\n' "$direction" >&2; exit 2 ;;
esac

bspc node -z "$primary" "$x" "$y" 2>/dev/null || bspc node -z "$fallback" "$x" "$y"


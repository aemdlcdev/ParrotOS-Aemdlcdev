#!/usr/bin/env bash
set -u

failures=0
check_command() {
  if command -v "$1" >/dev/null 2>&1; then printf '[OK]   %s\n' "$1"; else printf '[FALTA] %s\n' "$1"; failures=$((failures + 1)); fi
}

printf 'Aemdlc Environment — diagnóstico\n\n'
for command in bspwm bspc sxhkd polybar picom kitty rofi zsh nvim fzf flameshot ip python3; do check_command "$command"; done

printf '\nSesión: %s\n' "${XDG_SESSION_TYPE:-desconocida}"
printf 'DISPLAY: %s\n' "${DISPLAY:-no definido}"
if [[ -r /etc/os-release ]]; then . /etc/os-release; printf 'Sistema: %s %s\n' "${PRETTY_NAME:-$ID}" "${VERSION_ID:-}"; fi
if command -v polybar >/dev/null 2>&1; then printf 'Monitores Polybar:\n'; polybar --list-monitors 2>/dev/null || true; fi

if command -v fc-match >/dev/null 2>&1; then
  printf '\nFuentes visuales:\n'
  for pattern in 'Hack Nerd Font' 'Hack Nerd Font Mono' 'Iosevka Nerd Font'; do
    resolved=$(fc-match --format='%{family}\n' "$pattern" 2>/dev/null | head -n 1)
    case $pattern in
      Hack*) expected_family=Hack ;;
      Iosevka*) expected_family=Iosevka ;;
    esac
    if [[ $resolved == *"$expected_family"* ]]; then
      printf '[OK]   %s -> %s\n' "$pattern" "$resolved"
    else
      printf '[FALTA] %s (fallback: %s)\n' "$pattern" "${resolved:-ninguno}"
      failures=$((failures + 1))
    fi
  done
fi

if command -v xrdb >/dev/null 2>&1; then
  dpi=$(xrdb -query 2>/dev/null | awk '$1 == "Xft.dpi:" {print $2; exit}')
  printf 'Xft.dpi: %s\n' "${dpi:-automático}"
fi
exit "$failures"


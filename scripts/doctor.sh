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
exit "$failures"


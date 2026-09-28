#!/usr/bin/env bash
set -Eeuo pipefail
input=${1:-}
[[ -r $input ]] || { printf 'Uso: nmap-ports <archivo-nmap>\n' >&2; exit 2; }
ports=$(awk -F/ '$1 ~ /^[0-9]+$/ && $2 == "tcp" && $0 ~ /open/ {print $1}' "$input" | sort -nu | paste -sd, -)
[[ -n $ports ]] || { printf 'No se encontraron puertos TCP abiertos\n' >&2; exit 1; }
printf '%s\n' "$ports"
if command -v xclip >/dev/null && [[ -n ${DISPLAY:-} ]]; then printf '%s' "$ports" | xclip -selection clipboard; fi


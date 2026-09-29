#!/usr/bin/env bash
set -Eeuo pipefail

readonly targetctl=${AEM_TARGETCTL_PAYLOAD:-/usr/local/lib/aemdlc-environment/bin/targetctl}
readonly identity=${AEM_DESKTOP_IDENTITY_FILE:-/etc/aemdlc-environment/desktop-user}
readonly state_identity=${AEM_DESKTOP_STATE_FILE:-/etc/aemdlc-environment/desktop-state-home}
[[ -x $targetctl ]] || { printf 'targetctl no está instalado correctamente\n' >&2; exit 127; }

if [[ $(id -u) -eq 0 ]]; then
  [[ -r $identity ]] || { printf 'No se encontró el usuario del escritorio\n' >&2; exit 1; }
  [[ -r $state_identity ]] || { printf 'No se encontró el estado del usuario del escritorio\n' >&2; exit 1; }
  IFS= read -r desktop_user <"$identity"
  IFS= read -r desktop_state_home <"$state_identity"
  [[ $desktop_user =~ ^[a-z_][a-z0-9_-]*[$]?$ ]] || { printf 'Usuario de escritorio inválido\n' >&2; exit 1; }
  desktop_home=$(getent passwd "$desktop_user" | awk -F: 'NR == 1 {print $6}')
  [[ -n $desktop_home && $desktop_home != / && $desktop_state_home == "$desktop_home"/* ]] || {
    printf 'Home del usuario del escritorio inválido\n' >&2
    exit 1
  }
  exec runuser -u "$desktop_user" -- env HOME="$desktop_home" XDG_STATE_HOME="$desktop_state_home" "$targetctl" "$@"
fi

exec "$targetctl" "$@"

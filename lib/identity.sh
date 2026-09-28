#!/usr/bin/env bash

aem_resolve_target_user() {
  local candidate
  if [[ -n ${AEM_TARGET_USER:-} ]]; then
    candidate=$AEM_TARGET_USER
  elif [[ -n ${SUDO_USER:-} && $SUDO_USER != root ]]; then
    candidate=$SUDO_USER
  elif [[ $(id -u) -ne 0 ]]; then
    candidate=$(id -un)
  else
    aem_die "Ejecución como root directo: indica AEM_TARGET_USER"
  fi
  getent passwd "$candidate" >/dev/null || aem_die "Usuario inexistente: $candidate"
  AEM_USER=$candidate
  AEM_UID=$(id -u "$candidate")
  AEM_GID=$(id -g "$candidate")
  AEM_HOME=$(getent passwd "$candidate" | awk -F: '{print $6}')
  [[ -d $AEM_HOME && $AEM_HOME != / ]] || aem_die "Home inválido para $candidate"
  export AEM_USER AEM_UID AEM_GID AEM_HOME
}


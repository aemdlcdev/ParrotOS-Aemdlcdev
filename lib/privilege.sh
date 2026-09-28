#!/usr/bin/env bash

aem_as_root() {
  if [[ $AEM_DRY_RUN == 1 ]]; then
    aem_log info "[simulación/root] $*"
  elif [[ $(id -u) -eq 0 ]]; then
    "$@"
  else
    sudo -- "$@"
  fi
}

aem_as_user() {
  if [[ $AEM_DRY_RUN == 1 ]]; then
    aem_log info "[simulación/$AEM_USER] $*"
  elif [[ $(id -u) -eq "$AEM_UID" ]]; then
    "$@"
  elif [[ $(id -u) -eq 0 ]]; then
    runuser -u "$AEM_USER" -- "$@"
  else
    sudo -H -u "$AEM_USER" -- "$@"
  fi
}


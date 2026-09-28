#!/usr/bin/env bash

aem_ensure_user_dir() {
  local path=$1 mode=${2:-0755}
  if [[ $AEM_DRY_RUN == 1 ]]; then
    aem_log info "[simulación] crear directorio $path"
    return
  fi
  if [[ $(id -u) -eq 0 ]]; then
    install -d -m "$mode" -o "$AEM_UID" -g "$AEM_GID" "$path"
  else
    install -d -m "$mode" "$path"
  fi
}

aem_install_user_file() {
  local source=$1 destination=$2 mode=${3:-0644}
  [[ -f $source ]] || aem_die "Plantilla inexistente: $source"
  aem_user_path_allowed "$destination" || aem_die "Destino fuera del home rechazado: $destination"
  aem_user_path_allowed "$(dirname -- "$destination")" || aem_die "Directorio enlazado fuera del home: $destination"
  aem_ensure_user_dir "$(dirname -- "$destination")"
  if [[ -f $destination ]] && cmp -s -- "$source" "$destination"; then
    aem_log info "Sin cambios: $destination"
    return
  fi
  [[ -e $destination || -L $destination ]] && aem_backup_path "$destination"
  if [[ $AEM_DRY_RUN == 1 ]]; then
    aem_log info "[simulación] instalar $destination"
    return
  fi
  local temporary="${destination}.aem.$$"
  if [[ $(id -u) -eq 0 ]]; then
    install -m "$mode" -o "$AEM_UID" -g "$AEM_GID" "$source" "$temporary"
  else
    install -m "$mode" "$source" "$temporary"
  fi
  mv -f -- "$temporary" "$destination"
  aem_manifest_add file "$destination"
}


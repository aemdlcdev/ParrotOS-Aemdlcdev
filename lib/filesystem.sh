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

aem_ensure_system_dir() {
  local path=$1 mode=${2:-0755}
  aem_system_path_allowed "$path" || aem_die "Directorio de sistema rechazado: $path"
  aem_as_root install -d -m "$mode" -o root -g root "$path"
}

aem_install_system_file() {
  local source=$1 destination=$2 mode=${3:-0644} temporary
  [[ -f $source ]] || aem_die "Plantilla inexistente: $source"
  aem_system_file_path_allowed "$destination" || aem_die "Destino de sistema rechazado: $destination"
  if [[ $AEM_DRY_RUN == 1 ]]; then
    aem_log info "[simulación/root] instalar $destination"
    return
  fi
  if aem_as_root test -f "$destination" && aem_as_root cmp -s -- "$source" "$destination"; then
    aem_log info "Sin cambios: $destination"
    aem_manifest_add system-file "$destination"
    return
  fi
  aem_as_root test -e "$destination" && aem_backup_system_path "$destination"
  if [[ $(dirname -- "$destination") == /usr/local/bin ]]; then
    aem_as_root test -d /usr/local/bin || aem_die "Directorio de sistema inexistente: /usr/local/bin"
  else
    aem_ensure_system_dir "$(dirname -- "$destination")"
  fi
  temporary="${destination}.aem.$$"
  aem_as_root install -m "$mode" -o root -g root "$source" "$temporary"
  aem_as_root mv -f -- "$temporary" "$destination"
  aem_manifest_add system-file "$destination"
}

aem_install_system_text() {
  local content=$1 destination=$2 mode=${3:-0644} temporary
  temporary=$(mktemp)
  printf '%s\n' "$content" >"$temporary"
  aem_install_system_file "$temporary" "$destination" "$mode"
  rm -f -- "$temporary"
}

aem_install_system_block() {
  local destination=$1 snippet=$2 start end
  [[ -f $snippet ]] || aem_die "Fragmento inexistente: $snippet"
  aem_system_shared_path_allowed "$destination" || aem_die "Integración de sistema rechazada: $destination"
  start='# >>> aemdlc-environment >>>'
  end='# <<< aemdlc-environment <<<'
  if [[ $AEM_DRY_RUN == 1 ]]; then
    aem_log info "[simulación/root] añadir integración a $destination"
    return
  fi
  aem_as_root test -L "$destination" && aem_die "No se modifica una integración root enlazada: $destination"
  if aem_as_root test -f "$destination" && aem_as_root grep -Fq "$start" "$destination"; then
    aem_log info "Integración presente: $destination"
    aem_manifest_add system-shared-file "$destination"
    return
  fi
  aem_as_root test -e "$destination" && aem_backup_system_path "$destination"
  aem_as_root test -d "$(dirname -- "$destination")" || aem_die "Directorio de root inexistente: $(dirname -- "$destination")"
  {
    printf '\n%s\n' "$start"
    cat -- "$snippet"
    printf '%s\n' "$end"
  } | aem_as_root tee -a "$destination" >/dev/null
  aem_as_root chmod 0644 "$destination"
  aem_manifest_add system-shared-file "$destination"
}


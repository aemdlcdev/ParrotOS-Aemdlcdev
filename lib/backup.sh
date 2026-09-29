#!/usr/bin/env bash

aem_backup_path() {
  local source=$1 relative backup
  [[ -e $source || -L $source ]] || return 0
  relative=${source#/}
  backup="$AEM_BACKUP_DIR/$relative"
  if [[ $AEM_DRY_RUN == 1 ]]; then
    aem_log info "[simulación] backup de $source"
    return
  fi
  install -d -m 0700 "$(dirname -- "$backup")"
  cp -a -- "$source" "$backup"
  printf '%s\t%s\n' "$source" "$backup" >>"$AEM_PROJECT_STATE/backups.tsv"
  aem_log info "Backup: $source"
}

aem_backup_system_path() {
  local source=$1 relative backup timestamp
  aem_system_path_allowed "$source" || aem_die "Backup de sistema rechazado: $source"
  aem_as_root test -e "$source" || return 0
  timestamp=$(date '+%Y%m%d-%H%M%S')
  relative=${source#/}
  backup="/root/.local/state/$PROJECT_ID/backups/$timestamp/$relative"
  if [[ $AEM_DRY_RUN == 1 ]]; then
    aem_log info "[simulación/root] backup de $source"
    return
  fi
  aem_as_root install -d -m 0700 "$(dirname -- "$backup")"
  aem_as_root cp -a -- "$source" "$backup"
  aem_log info "Backup de sistema: $source"
}


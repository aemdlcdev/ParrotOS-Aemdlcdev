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


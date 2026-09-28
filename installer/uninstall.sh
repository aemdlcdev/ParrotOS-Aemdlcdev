#!/usr/bin/env bash

aem_main_uninstall() {
  local assume=0 purge_packages=0
  while (($#)); do
    case "$1" in
      --yes) assume=1; shift ;;
      --purge-packages) purge_packages=1; shift ;;
      -h|--help) printf '%s\n' 'Uso: ./uninstall.sh [--yes] [--purge-packages]'; return ;;
      *) aem_die "Opción desconocida: $1" ;;
    esac
  done
  aem_resolve_target_user
  aem_init_xdg_paths
  local manifest="$AEM_PROJECT_STATE/managed.tsv"
  [[ -f $manifest ]] || aem_die "No existe un manifiesto de instalación"
  if [[ $assume != 1 ]]; then
    [[ -t 0 ]] || aem_die "Se requiere --yes en modo no interactivo"
    local answer
    read -r -p "¿Retirar los archivos de $PROJECT_NAME? [s/N] " answer
    [[ ${answer,,} == s || ${answer,,} == si ]] || return
  fi
  local kind path checksum current
  while IFS=$'\t' read -r kind path checksum; do
    if [[ $kind != package ]] && ! aem_user_path_allowed "$path"; then
      aem_log warn "Entrada de manifiesto rechazada: $path"
      continue
    fi
    case "$kind" in
      file)
        if [[ -f $path || -L $path ]]; then
          current=$(sha256sum "$path" | awk '{print $1}')
          if [[ -n $checksum && $current == "$checksum" ]]; then rm -f -- "$path"; else aem_log warn "Conservado por cambios locales: $path"; fi
        fi
        ;;
      directory) [[ -d $path ]] && rmdir --ignore-fail-on-non-empty "$path" 2>/dev/null || true ;;
      shared-file)
        if [[ -f $path ]]; then
          sed '/^# >>> aemdlc-environment >>>$/,/^# <<< aemdlc-environment <<<$/{d;}' "$path" >"${path}.aem.$$"
          mv -f -- "${path}.aem.$$" "$path"
          if [[ $(id -u) -eq 0 ]]; then chown "$AEM_UID:$AEM_GID" "$path"; fi
        fi
        ;;
      package)
        aem_valid_package_name "$path" || { aem_log warn "Paquete inválido en manifiesto: $path"; continue; }
        [[ $purge_packages == 1 ]] && aem_as_root apt-get remove -y -- "$path"
        ;;
    esac
  done < <(awk '!seen[$0]++' "$manifest" | tac)
  aem_log success "Desinstalación terminada. Los backups se conservan en $AEM_PROJECT_STATE/backups"
}


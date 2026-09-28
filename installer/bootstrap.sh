#!/usr/bin/env bash

aem_usage() {
  cat <<EOF
Uso: ./install.sh [opciones]
  --dry-run   mostrar todo el plan sin modificar el sistema
  --yes       omitir la confirmación final
  --help      mostrar esta ayuda

Sin opciones instala el entorno completo con el tema Nocturne.
EOF
}

aem_load_components() {
  local file
  for file in "$PROJECT_ROOT"/components/*.sh; do
    # shellcheck disable=SC1090
    source "$file"
  done
}

aem_prepare_runtime() {
  if [[ $AEM_DRY_RUN == 1 ]]; then
    AEM_BACKUP_DIR="${TMPDIR:-/tmp}/$PROJECT_ID-dry-run-backup"
    AEM_LOG_FILE=''
    return
  fi
  aem_ensure_user_dir "$AEM_PROJECT_STATE" 0700
  aem_ensure_user_dir "$AEM_PROJECT_STATE/logs" 0700
  aem_ensure_user_dir "$AEM_PROJECT_STATE/backups" 0700
  AEM_BACKUP_DIR="$AEM_PROJECT_STATE/backups/$(date '+%Y%m%d-%H%M%S')"
  AEM_LOG_FILE="$AEM_PROJECT_STATE/logs/install-$(date '+%Y%m%d-%H%M%S').log"
  touch "$AEM_LOG_FILE"
  if [[ $(id -u) -eq 0 ]]; then chown "$AEM_UID:$AEM_GID" "$AEM_LOG_FILE"; fi
  exec 9>"$AEM_PROJECT_STATE/install.lock"
  flock -n 9 || aem_die "Ya existe otra ejecución del instalador"
  export AEM_BACKUP_DIR AEM_LOG_FILE
}

aem_confirm_plan() {
  [[ $AEM_ASSUME_YES == 1 ]] && return
  [[ -t 0 ]] || aem_die "Se requiere --yes en modo no interactivo"
  local answer
  read -r -p '¿Aplicar este plan? [s/N] ' answer
  [[ ${answer,,} == s || ${answer,,} == si ]] || exit 0
}

aem_main_install() {
  while (($#)); do
    case "$1" in
      --dry-run) AEM_DRY_RUN=1; shift ;;
      --yes) AEM_ASSUME_YES=1; shift ;;
      -h|--help) aem_usage; return ;;
      *) aem_die "Opción desconocida: $1" ;;
    esac
  done
  aem_require_command getent
  aem_require_command dpkg
  aem_require_command flock
  aem_detect_platform
  aem_assert_supported_platform 0 0
  aem_resolve_target_user
  aem_init_xdg_paths
  aem_prepare_runtime
  source "$PROJECT_ROOT/metadata/components.conf"
  AEM_COMPONENTS=$INSTALL_COMPONENTS
  AEM_THEME=nocturne
  export AEM_THEME AEM_COMPONENTS
  aem_load_components
  printf '\n%s\n' '========================================'
  printf '  %s — instalación completa\n' "$PROJECT_NAME"
  printf '%s\n\n' '========================================'
  aem_log info "Usuario objetivo: $AEM_USER ($AEM_HOME)"
  aem_log info "Componentes: $AEM_COMPONENTS"
  aem_log info "Tema: $AEM_THEME"
  aem_confirm_plan
  aem_log info "Actualizando índices APT"
  aem_as_root apt-get update
  local component function_name
  for component in $AEM_COMPONENTS; do
    aem_valid_component "$component" || aem_die "Nombre de componente inválido: $component"
    function_name="aem_component_${component//-/_}_install"
    declare -F "$function_name" >/dev/null || aem_die "Componente no implementado: $component"
    aem_log info "Configurando componente: $component"
    "$function_name"
  done
  if [[ $AEM_DRY_RUN != 1 ]]; then
    : >"$AEM_PROJECT_STATE/components.txt"
    for component in $AEM_COMPONENTS; do printf '%s\n' "$component" >>"$AEM_PROJECT_STATE/components.txt"; done
    printf '%s\n' "$AEM_THEME" >"$AEM_PROJECT_STATE/theme.txt"
    if [[ $(id -u) -eq 0 ]]; then chown "$AEM_UID:$AEM_GID" "$AEM_PROJECT_STATE/components.txt" "$AEM_PROJECT_STATE/theme.txt"; fi
  fi
  aem_log success "Instalación finalizada. Cierra sesión y elige BSPWM para probar el entorno."
}


#!/usr/bin/env bash
set -Eeuo pipefail

readonly PROJECT_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
source "$PROJECT_ROOT/lib/common.sh"

aem_resolve_target_user
aem_init_xdg_paths
components_file="$AEM_PROJECT_STATE/components.txt"
theme_file="$AEM_PROJECT_STATE/theme.txt"
[[ -r $components_file ]] || aem_die "No se encontró una instalación anterior"
components=$(paste -sd, "$components_file")
theme=$(<"$theme_file")
[[ $theme == nocturne || $theme == daybreak ]] || aem_die "Tema registrado inválido"
aem_log info "Actualizando los componentes administrados por $PROJECT_NAME"
exec "$PROJECT_ROOT/install.sh" --components "$components" --theme "$theme" "$@"


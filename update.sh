#!/usr/bin/env bash
set -Eeuo pipefail

readonly PROJECT_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
source "$PROJECT_ROOT/lib/common.sh"

aem_resolve_target_user
aem_init_xdg_paths
[[ -r $AEM_PROJECT_STATE/components.txt ]] || aem_die "No se encontró una instalación anterior"
aem_log info "Actualizando los componentes administrados por $PROJECT_NAME"
exec "$PROJECT_ROOT/install.sh" "$@"


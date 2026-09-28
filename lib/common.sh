#!/usr/bin/env bash

source "$PROJECT_ROOT/metadata/project.conf"
source "$PROJECT_ROOT/metadata/versions.conf"
source "$PROJECT_ROOT/lib/logging.sh"
source "$PROJECT_ROOT/lib/platform.sh"
source "$PROJECT_ROOT/lib/identity.sh"
source "$PROJECT_ROOT/lib/privilege.sh"
source "$PROJECT_ROOT/lib/xdg.sh"
source "$PROJECT_ROOT/lib/validation.sh"
source "$PROJECT_ROOT/lib/filesystem.sh"
source "$PROJECT_ROOT/lib/backup.sh"
source "$PROJECT_ROOT/lib/manifest.sh"
source "$PROJECT_ROOT/lib/apt.sh"
source "$PROJECT_ROOT/lib/upstream.sh"

AEM_DRY_RUN=${AEM_DRY_RUN:-0}
AEM_ASSUME_YES=${AEM_ASSUME_YES:-0}

aem_die() {
  aem_log error "$*"
  exit 1
}

aem_require_command() {
  command -v "$1" >/dev/null 2>&1 || aem_die "Falta el comando requerido: $1"
}

aem_on_error() {
  local status=$?
  aem_log error "Fallo en ${BASH_SOURCE[1]:-desconocido}:${BASH_LINENO[0]:-0} (código $status)"
  exit "$status"
}

trap aem_on_error ERR


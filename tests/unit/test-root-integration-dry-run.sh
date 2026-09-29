#!/usr/bin/env bash
set -Eeuo pipefail

PROJECT_ROOT=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd -P)
AEM_DRY_RUN=1
AEM_USER=tester
AEM_STATE_HOME=/home/tester/.local/state

source "$PROJECT_ROOT/metadata/project.conf"
source "$PROJECT_ROOT/metadata/versions.conf"
source "$PROJECT_ROOT/lib/logging.sh"
source "$PROJECT_ROOT/lib/privilege.sh"
source "$PROJECT_ROOT/lib/validation.sh"
source "$PROJECT_ROOT/lib/manifest.sh"
source "$PROJECT_ROOT/lib/backup.sh"
source "$PROJECT_ROOT/lib/filesystem.sh"
source "$PROJECT_ROOT/lib/upstream.sh"
source "$PROJECT_ROOT/components/root-integration.sh"

aem_die() {
  printf 'root-integration dry-run: %s\n' "$*" >&2
  exit 1
}

aem_install_packages() {
  [[ $* == util-linux ]] || aem_die "Paquetes inesperados: $*"
}

aem_component_root_integration_install >/dev/null
printf 'root-integration-dry-run: OK\n'

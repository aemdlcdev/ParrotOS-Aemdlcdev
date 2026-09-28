#!/usr/bin/env bash
set -Eeuo pipefail

root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd -P)
PROJECT_ROOT=$root
source "$root/metadata/project.conf"
source "$root/lib/logging.sh"
aem_die() { printf '%s\n' "$*" >&2; return 1; }
source "$root/lib/platform.sh"
export AEM_OS_RELEASE_FILE="$root/tests/fixtures/parrot-7.3-os-release"
aem_detect_platform
[[ $AEM_OS_ID == parrot ]]
[[ $AEM_OS_VERSION == 7.3 ]]
[[ $AEM_OS_CODENAME == echo ]]
printf 'platform: OK\n'


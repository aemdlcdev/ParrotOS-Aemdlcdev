#!/usr/bin/env bash

aem_detect_platform() {
  local release_file=${AEM_OS_RELEASE_FILE:-/etc/os-release}
  [[ -r $release_file ]] || aem_die "No se puede leer $release_file"
  local ID='' ID_LIKE='' VERSION_ID='' VERSION_CODENAME=''
  # shellcheck disable=SC1091
  source "$release_file"
  AEM_OS_ID=${ID,,}
  AEM_OS_LIKE=${ID_LIKE,,}
  AEM_OS_VERSION=$VERSION_ID
  AEM_OS_CODENAME=$VERSION_CODENAME
  AEM_ARCH=$(dpkg --print-architecture 2>/dev/null || uname -m)
  export AEM_OS_ID AEM_OS_LIKE AEM_OS_VERSION AEM_OS_CODENAME AEM_ARCH
}

aem_assert_supported_platform() {
  local allow_debian=${1:-0} force=${2:-0}
  [[ $AEM_ARCH == amd64 || $AEM_ARCH == x86_64 ]] || aem_die "Arquitectura no soportada: $AEM_ARCH"
  if [[ $AEM_OS_ID == parrot && $AEM_OS_VERSION == 7* ]]; then
    aem_log success "Plataforma compatible: Parrot OS $AEM_OS_VERSION ($AEM_ARCH)"
    return
  fi
  if [[ $AEM_OS_ID == debian && $AEM_OS_VERSION == 13 && $allow_debian == 1 ]]; then
    aem_log warn "Debian 13 se admite en modo experimental"
    return
  fi
  [[ $force == 1 ]] || aem_die "Sistema no soportado: $AEM_OS_ID $AEM_OS_VERSION"
  aem_log warn "Continuando en un sistema no soportado por petición explícita"
}


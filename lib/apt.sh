#!/usr/bin/env bash

aem_package_installed() {
  dpkg-query -W -f='${db:Status-Status}' "$1" 2>/dev/null | grep -qx installed
}

aem_package_available() {
  apt-cache show --no-all-versions "$1" >/dev/null 2>&1
}

aem_install_packages() {
  local package missing=()
  for package in "$@"; do
    if aem_package_installed "$package"; then
      aem_log info "Paquete presente: $package"
    elif aem_package_available "$package"; then
      missing+=("$package")
    else
      aem_die "Paquete no disponible en los repositorios activos: $package"
    fi
  done
  ((${#missing[@]})) || return 0
  aem_log info "Instalando: ${missing[*]}"
  aem_as_root apt-get install -y --no-install-recommends "${missing[@]}"
  for package in "${missing[@]}"; do
    aem_manifest_add package "$package"
  done
}


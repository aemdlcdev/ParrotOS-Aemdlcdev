#!/usr/bin/env bash

aem_clone_tagged_repo() {
  local url=$1 version=$2 destination=$3
  if [[ -d $destination/.git ]]; then
    [[ $(git -C "$destination" remote get-url origin) == "$url" ]] || aem_die "Origen inesperado en $destination"
    [[ $(git -C "$destination" describe --tags --exact-match 2>/dev/null || true) == "$version" ]] || aem_die "Versión inesperada en $destination"
    aem_log info "Repositorio presente: $destination"
    return
  fi
  [[ $url == https://* ]] || aem_die "Origen no HTTPS rechazado: $url"
  aem_ensure_user_dir "$(dirname -- "$destination")"
  aem_as_user git clone --depth 1 --branch "$version" -- "$url" "$destination"
  aem_manifest_add directory "$destination"
}

aem_clone_pinned_commit() {
  local url=$1 commit=$2 destination=$3 temporary
  [[ $commit =~ ^[0-9a-f]{40}$ ]] || aem_die "Commit inválido para $url"
  if [[ -d $destination/.git ]]; then
    [[ $(git -C "$destination" remote get-url origin) == "$url" ]] || aem_die "Origen inesperado en $destination"
    [[ $(git -C "$destination" rev-parse HEAD) == "$commit" ]] || aem_die "Commit inesperado en $destination"
    aem_log info "Repositorio presente: $destination"
    return
  fi
  [[ $url == https://* ]] || aem_die "Origen no HTTPS rechazado: $url"
  aem_ensure_user_dir "$(dirname -- "$destination")"
  temporary="${destination}.aem.$$"
  aem_as_user git init --quiet "$temporary"
  aem_as_user git -C "$temporary" remote add origin "$url"
  aem_as_user git -C "$temporary" fetch --quiet --depth 1 origin "$commit"
  aem_as_user git -C "$temporary" checkout --quiet --detach FETCH_HEAD
  aem_as_user mv -- "$temporary" "$destination"
  aem_manifest_add directory "$destination"
}

aem_clone_system_tagged_repo() {
  local url=$1 version=$2 destination=$3
  aem_system_tree_path_allowed "$destination" || aem_die "Repositorio de sistema rechazado: $destination"
  if [[ $AEM_DRY_RUN == 1 ]]; then
    aem_log info "[simulación/root] clonar $url ($version) en $destination"
    return
  fi
  if aem_as_root test -d "$destination/.git"; then
    [[ $(aem_as_root git -C "$destination" remote get-url origin) == "$url" ]] || aem_die "Origen inesperado en $destination"
    [[ $(aem_as_root git -C "$destination" describe --tags --exact-match 2>/dev/null || true) == "$version" ]] || aem_die "Versión inesperada en $destination"
    aem_log info "Repositorio de sistema presente: $destination"
    aem_manifest_add system-tree "$destination"
    return
  fi
  [[ $url == https://* ]] || aem_die "Origen no HTTPS rechazado: $url"
  aem_ensure_system_dir "$(dirname -- "$destination")"
  aem_as_root git clone --depth 1 --branch "$version" -- "$url" "$destination"
  aem_manifest_add system-tree "$destination"
}

aem_clone_system_pinned_commit() {
  local url=$1 commit=$2 destination=$3 temporary
  [[ $commit =~ ^[0-9a-f]{40}$ ]] || aem_die "Commit inválido para $url"
  aem_system_tree_path_allowed "$destination" || aem_die "Repositorio de sistema rechazado: $destination"
  if [[ $AEM_DRY_RUN == 1 ]]; then
    aem_log info "[simulación/root] clonar $url ($commit) en $destination"
    return
  fi
  if aem_as_root test -d "$destination/.git"; then
    [[ $(aem_as_root git -C "$destination" remote get-url origin) == "$url" ]] || aem_die "Origen inesperado en $destination"
    [[ $(aem_as_root git -C "$destination" rev-parse HEAD) == "$commit" ]] || aem_die "Commit inesperado en $destination"
    aem_log info "Repositorio de sistema presente: $destination"
    aem_manifest_add system-tree "$destination"
    return
  fi
  [[ $url == https://* ]] || aem_die "Origen no HTTPS rechazado: $url"
  aem_ensure_system_dir "$(dirname -- "$destination")"
  temporary="${destination}.aem.$$"
  aem_as_root git init --quiet "$temporary"
  aem_as_root git -C "$temporary" remote add origin "$url"
  aem_as_root git -C "$temporary" fetch --quiet --depth 1 origin "$commit"
  aem_as_root git -C "$temporary" checkout --quiet --detach FETCH_HEAD
  aem_as_root mv -- "$temporary" "$destination"
  aem_manifest_add system-tree "$destination"
}


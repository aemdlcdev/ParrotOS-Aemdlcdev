#!/usr/bin/env bash

aem_manifest_add() {
  local kind=$1 path=$2
  [[ $AEM_DRY_RUN == 1 ]] && return 0
  local checksum=''
  if [[ $kind == file && -f $path ]]; then checksum=$(sha256sum "$path" | awk '{print $1}'); fi
  printf '%s\t%s\t%s\n' "$kind" "$path" "$checksum" >>"$AEM_PROJECT_STATE/managed.tsv"
}

aem_manifest_has() {
  local kind=$1 path=$2
  [[ -f $AEM_PROJECT_STATE/managed.tsv ]] && awk -F '\t' -v k="$kind" -v p="$path" '$1 == k && $2 == p {found=1} END {exit !found}' "$AEM_PROJECT_STATE/managed.tsv"
}


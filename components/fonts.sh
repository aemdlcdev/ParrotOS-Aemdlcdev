#!/usr/bin/env bash

aem_component_fonts_install() {
  aem_install_packages ca-certificates fontconfig curl xz-utils
  local font_dir="$AEM_DATA_HOME/fonts/$PROJECT_ID"
  local release_url="https://github.com/ryanoasis/nerd-fonts/releases/download/$NERD_FONTS_VERSION"
  local index family expected archive actual

  ((${#NERD_FONT_FAMILIES[@]} == ${#NERD_FONT_SHA256S[@]})) || aem_die "Metadatos de fuentes incompletos"
  aem_ensure_user_dir "$font_dir"

  for index in "${!NERD_FONT_FAMILIES[@]}"; do
    family=${NERD_FONT_FAMILIES[$index]}
    expected=${NERD_FONT_SHA256S[$index]}
    [[ $expected =~ ^[0-9a-fA-F]{64}$ ]] || aem_die "Checksum inválido para $family"

    if find "$font_dir" -maxdepth 1 -type f -name "${family}*NerdFont*.ttf" -print -quit 2>/dev/null | grep -q .; then
      aem_log info "Fuente presente: $family"
      continue
    fi
    if [[ $AEM_DRY_RUN == 1 ]]; then
      aem_log info "[simulación] descargar $family $NERD_FONTS_VERSION"
      continue
    fi

    archive=$(mktemp --suffix=.tar.xz)
    curl --fail --location --retry 3 --connect-timeout 15 --proto '=https' --tlsv1.2 \
      "$release_url/$family.tar.xz" -o "$archive"
    actual=$(sha256sum "$archive" | awk '{print $1}')
    [[ ${actual,,} == ${expected,,} ]] || { rm -f -- "$archive"; aem_die "Checksum incorrecto para $family"; }
    tar -xJf "$archive" -C "$font_dir" --no-same-owner --no-same-permissions --wildcards '*.ttf'
    rm -f -- "$archive"
  done

  if [[ $AEM_DRY_RUN != 1 ]]; then
    if [[ $(id -u) -eq 0 ]]; then chown -R "$AEM_UID:$AEM_GID" "$font_dir"; fi
    aem_as_user fc-cache -f "$font_dir"
    aem_manifest_add directory "$font_dir"
  fi
}

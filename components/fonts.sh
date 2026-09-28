#!/usr/bin/env bash
aem_component_fonts_install() {
  aem_install_packages ca-certificates fontconfig curl xz-utils
  local font_dir="$AEM_DATA_HOME/fonts/$PROJECT_ID" archive checksums url expected actual
  if find "$font_dir" -maxdepth 1 -type f -name '*NerdFont*.ttf' -print -quit 2>/dev/null | grep -q .; then aem_log info "Fuente Nerd Font presente"; return; fi
  if [[ $AEM_DRY_RUN == 1 ]]; then aem_log info "[simulación] descargar $NERD_FONT_FAMILY $NERD_FONTS_VERSION"; return; fi
  archive=$(mktemp --suffix=.tar.xz); checksums=$(mktemp)
  url="https://github.com/ryanoasis/nerd-fonts/releases/download/$NERD_FONTS_VERSION"
  curl --fail --location --retry 3 --connect-timeout 15 --proto '=https' --tlsv1.2 "$url/$NERD_FONT_FAMILY.tar.xz" -o "$archive"
  curl --fail --location --retry 3 --connect-timeout 15 --proto '=https' --tlsv1.2 "$url/SHA256SUMS" -o "$checksums"
  expected=$(awk -v name="$NERD_FONT_FAMILY.tar.xz" '$2 == name {print $1}' "$checksums")
  [[ $expected =~ ^[0-9a-fA-F]{64}$ ]] || aem_die "Checksum oficial no encontrado"
  actual=$(sha256sum "$archive" | awk '{print $1}')
  [[ ${actual,,} == ${expected,,} ]] || aem_die "Checksum de la fuente incorrecto"
  aem_ensure_user_dir "$font_dir"
  tar -xJf "$archive" -C "$font_dir" --no-same-owner --no-same-permissions --wildcards '*.ttf'
  if [[ $(id -u) -eq 0 ]]; then chown -R "$AEM_UID:$AEM_GID" "$font_dir"; fi
  aem_as_user fc-cache -f "$font_dir"
  aem_manifest_add directory "$font_dir"
  rm -f -- "$archive" "$checksums"
}


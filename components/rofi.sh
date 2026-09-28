#!/usr/bin/env bash
aem_component_rofi_install() {
  aem_install_packages rofi
  aem_install_user_file "$PROJECT_ROOT/config/rofi/launcher.rasi" "$AEM_PROJECT_CONFIG/rofi/launcher.rasi" 0644
  aem_install_user_file "$PROJECT_ROOT/config/rofi/power-menu.rasi" "$AEM_PROJECT_CONFIG/rofi/power-menu.rasi" 0644
  aem_install_user_file "$PROJECT_ROOT/config/rofi/themes/$AEM_THEME.rasi" "$AEM_PROJECT_CONFIG/rofi/theme.rasi" 0644
  local file
  for file in nocturne.rasi daybreak.rasi; do aem_install_user_file "$PROJECT_ROOT/config/rofi/themes/$file" "$AEM_PROJECT_DATA/themes/rofi/$file" 0644; done
  aem_install_user_file "$PROJECT_ROOT/scripts/power-menu.sh" "$AEM_PROJECT_DATA/bin/power-menu" 0755
}


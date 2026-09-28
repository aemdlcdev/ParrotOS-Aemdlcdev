#!/usr/bin/env bash
aem_component_kitty_install() {
  aem_install_packages kitty
  aem_install_user_file "$PROJECT_ROOT/config/kitty/kitty.conf" "$AEM_CONFIG_HOME/kitty/kitty.conf" 0644
  aem_install_user_file "$PROJECT_ROOT/config/kitty/themes/$AEM_THEME.conf" "$AEM_CONFIG_HOME/kitty/theme.conf" 0644
  local file
  for file in nocturne.conf daybreak.conf; do aem_install_user_file "$PROJECT_ROOT/config/kitty/themes/$file" "$AEM_PROJECT_DATA/themes/kitty/$file" 0644; done
}


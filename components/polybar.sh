#!/usr/bin/env bash
aem_component_polybar_install() {
  aem_install_packages polybar iproute2 procps python3
  local file
  for file in config.ini bars.ini modules.ini; do aem_install_user_file "$PROJECT_ROOT/config/polybar/$file" "$AEM_CONFIG_HOME/polybar/$file" 0644; done
  aem_install_user_file "$PROJECT_ROOT/config/polybar/themes/$AEM_THEME.ini" "$AEM_CONFIG_HOME/polybar/theme.ini" 0644
  for file in launch-polybar.sh network-status.sh vpn-status.sh target-status.sh battery-status.sh theme-switcher.sh; do aem_install_user_file "$PROJECT_ROOT/scripts/$file" "$AEM_PROJECT_DATA/bin/${file%.sh}" 0755; done
  for file in nocturne.ini daybreak.ini; do aem_install_user_file "$PROJECT_ROOT/config/polybar/themes/$file" "$AEM_PROJECT_DATA/themes/polybar/$file" 0644; done
}


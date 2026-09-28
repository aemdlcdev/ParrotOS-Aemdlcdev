#!/usr/bin/env bash
aem_component_picom_install() {
  aem_install_packages picom
  aem_install_user_file "$PROJECT_ROOT/config/picom/picom.conf" "$AEM_CONFIG_HOME/picom/picom.conf" 0644
}


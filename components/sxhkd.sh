#!/usr/bin/env bash
aem_component_sxhkd_install() {
  aem_install_packages sxhkd
  aem_install_user_file "$PROJECT_ROOT/config/sxhkd/sxhkdrc" "$AEM_CONFIG_HOME/sxhkd/sxhkdrc" 0644
}


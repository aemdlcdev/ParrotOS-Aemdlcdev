#!/usr/bin/env bash
aem_component_bspwm_install() {
  aem_install_packages bspwm feh
  aem_install_user_file "$PROJECT_ROOT/config/bspwm/bspwmrc" "$AEM_CONFIG_HOME/bspwm/bspwmrc" 0755
  aem_install_user_file "$PROJECT_ROOT/scripts/session-start.sh" "$AEM_PROJECT_DATA/bin/session-start" 0755
  aem_install_user_file "$PROJECT_ROOT/scripts/workspace-init.sh" "$AEM_PROJECT_DATA/bin/workspace-init" 0755
  aem_install_user_file "$PROJECT_ROOT/scripts/resize-window.sh" "$AEM_PROJECT_DATA/bin/resize-window" 0755
}


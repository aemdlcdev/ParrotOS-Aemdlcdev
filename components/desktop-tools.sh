#!/usr/bin/env bash
aem_component_desktop_tools_install() {
  aem_install_packages flameshot i3lock fastfetch imagemagick pavucontrol
  aem_install_user_file "$PROJECT_ROOT/scripts/doctor.sh" "$AEM_PROJECT_DATA/bin/doctor" 0755
}


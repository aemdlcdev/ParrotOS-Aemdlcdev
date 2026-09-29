#!/usr/bin/env bash

aem_component_root_integration_install() {
  local file
  aem_log info "Instalando integración segura para root"
  aem_install_packages util-linux

  aem_install_system_text "$AEM_USER" /etc/aemdlc-environment/desktop-user 0644
  aem_install_system_text "$AEM_STATE_HOME" /etc/aemdlc-environment/desktop-state-home 0644
  aem_install_system_file "$PROJECT_ROOT/config/zsh/root-init.zsh" /etc/aemdlc-environment/zsh/root-init.zsh 0644
  for file in aliases completion keybindings pentest p10k; do
    aem_install_system_file "$PROJECT_ROOT/config/zsh/$file.zsh" "/etc/aemdlc-environment/zsh/$file.zsh" 0644
  done

  aem_clone_system_tagged_repo https://github.com/romkatv/powerlevel10k.git "$POWERLEVEL10K_VERSION" /usr/local/share/aemdlc-environment/powerlevel10k
  aem_clone_system_pinned_commit https://github.com/ohmyzsh/ohmyzsh.git "$OH_MY_ZSH_COMMIT" /usr/local/share/aemdlc-environment/oh-my-zsh

  aem_install_system_file "$PROJECT_ROOT/scripts/targetctl" /usr/local/lib/aemdlc-environment/bin/targetctl 0755
  aem_install_system_file "$PROJECT_ROOT/scripts/targetctl-system.sh" /usr/local/bin/targetctl 0755
  aem_install_system_file "$PROJECT_ROOT/scripts/pentest-workspace.sh" /usr/local/bin/pentest-workspace 0755
  aem_install_system_file "$PROJECT_ROOT/scripts/nmap-ports.sh" /usr/local/bin/nmap-ports 0755
  aem_install_system_file "$PROJECT_ROOT/scripts/doctor.sh" /usr/local/bin/doctor 0755

  aem_install_system_block /root/.zshrc "$PROJECT_ROOT/config/zsh/root-zsh-hook.zsh"
  aem_install_system_block /root/.bashrc "$PROJECT_ROOT/config/zsh/root-bash-hook.sh"
}

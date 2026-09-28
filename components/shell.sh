#!/usr/bin/env bash
aem_component_shell_install() {
  aem_install_packages git ca-certificates zsh zsh-autosuggestions zsh-syntax-highlighting fzf bat lsd
  local file
  for file in init.zsh aliases.zsh completion.zsh keybindings.zsh pentest.zsh; do aem_install_user_file "$PROJECT_ROOT/config/zsh/$file" "$AEM_PROJECT_CONFIG/zsh/$file" 0644; done
  aem_clone_tagged_repo https://github.com/romkatv/powerlevel10k.git "$POWERLEVEL10K_VERSION" "$AEM_DATA_HOME/powerlevel10k"
  aem_install_user_file "$PROJECT_ROOT/config/zsh/p10k.zsh" "$AEM_PROJECT_CONFIG/zsh/p10k.zsh" 0644
  source "$PROJECT_ROOT/installer/zsh-hook.sh"
}


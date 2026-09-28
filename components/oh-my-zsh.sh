#!/usr/bin/env bash
aem_component_oh_my_zsh_install() {
  aem_install_packages zsh git
  aem_clone_pinned_commit https://github.com/ohmyzsh/ohmyzsh.git "$OH_MY_ZSH_COMMIT" "$AEM_DATA_HOME/oh-my-zsh"
}


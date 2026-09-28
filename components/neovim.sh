#!/usr/bin/env bash
aem_component_neovim_install() {
  aem_install_packages neovim ripgrep
  aem_install_user_file "$PROJECT_ROOT/config/nvim/init.lua" "$AEM_CONFIG_HOME/nvim/init.lua" 0644
  aem_install_user_file "$PROJECT_ROOT/config/nvim/lua/aem/options.lua" "$AEM_CONFIG_HOME/nvim/lua/aem/options.lua" 0644
  aem_install_user_file "$PROJECT_ROOT/config/nvim/lua/aem/keymaps.lua" "$AEM_CONFIG_HOME/nvim/lua/aem/keymaps.lua" 0644
}


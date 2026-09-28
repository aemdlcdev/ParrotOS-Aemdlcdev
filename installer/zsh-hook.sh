#!/usr/bin/env bash
set -Eeuo pipefail

zshrc="$AEM_HOME/.zshrc"
start='# >>> aemdlc-environment >>>'
end='# <<< aemdlc-environment <<<'
line='[[ -r "${XDG_CONFIG_HOME:-$HOME/.config}/aemdlc-environment/zsh/init.zsh" ]] && source "${XDG_CONFIG_HOME:-$HOME/.config}/aemdlc-environment/zsh/init.zsh"'
if [[ -f $zshrc ]] && grep -Fq "$start" "$zshrc"; then
  aem_log info "Integración Zsh presente"
  return 0
fi
[[ -e $zshrc ]] && aem_backup_path "$zshrc"
if [[ $AEM_DRY_RUN == 1 ]]; then
  aem_log info "[simulación] añadir integración a $zshrc"
  return 0
fi
temporary="${zshrc}.aem.$$"
if [[ -f $zshrc ]]; then cp -- "$zshrc" "$temporary"; else : >"$temporary"; fi
{
  [[ -s $zshrc ]] && printf '\n'
  printf '%s\n%s\n%s\n' "$start" "$line" "$end"
} >>"$temporary"
chmod 0644 "$temporary"
mv -f -- "$temporary" "$zshrc"
if [[ $(id -u) -eq 0 ]]; then chown "$AEM_UID:$AEM_GID" "$zshrc"; fi
aem_manifest_add shared-file "$zshrc"


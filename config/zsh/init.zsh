export AEMDLC_BIN="${XDG_DATA_HOME:-$HOME/.local/share}/aemdlc-environment/bin"
path=("$AEMDLC_BIN" "$HOME/.local/bin" $path)
typeset -U path PATH
if [[ -r "${XDG_DATA_HOME:-$HOME/.local/share}/oh-my-zsh/oh-my-zsh.sh" ]]; then
  export ZSH="${XDG_DATA_HOME:-$HOME/.local/share}/oh-my-zsh"
  ZSH_THEME=""
  plugins=(git)
  DISABLE_AUTO_UPDATE=true
  source "$ZSH/oh-my-zsh.sh"
fi
setopt autocd interactivecomments notify numericglobsort promptsubst
setopt hist_ignore_all_dups share_history
HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/aemdlc-environment/zsh-history"
HISTSIZE=20000
SAVEHIST=10000
mkdir -p -m 700 -- "${HISTFILE:h}"
for module in aliases completion keybindings pentest; do source "${XDG_CONFIG_HOME:-$HOME/.config}/aemdlc-environment/zsh/$module.zsh"; done
[[ -r /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]] && source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
[[ -r /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
[[ -r "${XDG_DATA_HOME:-$HOME/.local/share}/powerlevel10k/powerlevel10k.zsh-theme" ]] && source "${XDG_DATA_HOME:-$HOME/.local/share}/powerlevel10k/powerlevel10k.zsh-theme"
[[ -r "${XDG_CONFIG_HOME:-$HOME/.config}/aemdlc-environment/zsh/p10k.zsh" ]] && source "${XDG_CONFIG_HOME:-$HOME/.config}/aemdlc-environment/zsh/p10k.zsh"


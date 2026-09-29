export AEMDLC_BIN=/usr/local/bin
path=(/usr/local/bin "$AEMDLC_BIN" $path)
typeset -U path PATH

export ZSH=/usr/local/share/aemdlc-environment/oh-my-zsh
if [[ -r "$ZSH/oh-my-zsh.sh" ]]; then
  ZSH_THEME=""
  plugins=(git)
  DISABLE_AUTO_UPDATE=true
  source "$ZSH/oh-my-zsh.sh"
fi

setopt autocd interactivecomments notify numericglobsort promptsubst
setopt hist_ignore_all_dups share_history
HISTFILE=/root/.local/state/aemdlc-environment/zsh-history
HISTSIZE=20000
SAVEHIST=10000
mkdir -p -m 700 -- "${HISTFILE:h}"

for module in aliases completion keybindings pentest; do
  source "/etc/aemdlc-environment/zsh/$module.zsh"
done
[[ -r /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]] && source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
[[ -r /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
[[ -r /usr/local/share/aemdlc-environment/powerlevel10k/powerlevel10k.zsh-theme ]] && source /usr/local/share/aemdlc-environment/powerlevel10k/powerlevel10k.zsh-theme
[[ -r /etc/aemdlc-environment/zsh/p10k.zsh ]] && source /etc/aemdlc-environment/zsh/p10k.zsh

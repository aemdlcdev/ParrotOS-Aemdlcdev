autoload -Uz compinit
cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/aemdlc-environment"
mkdir -p -- "$cache_dir"
compinit -d "$cache_dir/zcompdump"
[[ -r /usr/share/doc/fzf/examples/completion.zsh ]] && source /usr/share/doc/fzf/examples/completion.zsh
[[ -r /usr/share/doc/fzf/examples/key-bindings.zsh ]] && source /usr/share/doc/fzf/examples/key-bindings.zsh


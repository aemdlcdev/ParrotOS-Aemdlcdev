alias ll='lsd -lh --group-dirs first'
alias la='lsd -lah --group-dirs first'
alias lt='lsd --tree --depth 2'
if (( $+commands[batcat] )); then alias cat='batcat --paging=never'; else alias cat='bat --paging=never'; fi
alias grep='grep --color=auto'
alias ip='ip --color=auto'
alias settarget='targetctl set'
alias showtarget='targetctl show'
alias cleartarget='targetctl clear'


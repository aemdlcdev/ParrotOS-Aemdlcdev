if [[ $- == *i* && -z ${AEMDLC_ROOT_ZSH_ACTIVE:-} && -x /usr/bin/zsh ]]; then
  export AEMDLC_ROOT_ZSH_ACTIVE=1
  exec /usr/bin/zsh
fi

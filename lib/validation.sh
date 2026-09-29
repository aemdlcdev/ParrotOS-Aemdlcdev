#!/usr/bin/env bash

aem_valid_component() {
  [[ $1 =~ ^[a-z0-9][a-z0-9-]*$ ]]
}

aem_valid_target_name() {
  [[ -n $1 && ${#1} -le 64 && $1 != *$'\n'* && $1 != *$'\r'* && $1 != *$'\t'* ]]
}

aem_valid_ip() {
  local value=$1
  python3 - "$value" <<'PY'
import ipaddress, sys
try:
    ipaddress.ip_address(sys.argv[1])
except ValueError:
    raise SystemExit(1)
PY
}

aem_user_path_allowed() {
  local candidate home_real candidate_real
  candidate=$1
  home_real=$(realpath -m -- "$AEM_HOME")
  candidate_real=$(realpath -m -- "$candidate")
  [[ $candidate_real == "$home_real"/* ]]
}

aem_system_path_allowed() {
  local candidate
  candidate=$(realpath -m -- "$1")
  case "$candidate" in
    /etc/aemdlc-environment|/etc/aemdlc-environment/*|\
    /usr/local/lib/aemdlc-environment|/usr/local/lib/aemdlc-environment/*|\
    /usr/local/share/aemdlc-environment|/usr/local/share/aemdlc-environment/*|\
    /usr/local/bin/targetctl|/usr/local/bin/pentest-workspace|/usr/local/bin/nmap-ports|/usr/local/bin/doctor|\
    /root/.bashrc|/root/.zshrc|/root/.local/state/aemdlc-environment|/root/.local/state/aemdlc-environment/*) return 0 ;;
    *) return 1 ;;
  esac
}

aem_system_file_path_allowed() {
  local candidate
  candidate=$(realpath -m -- "$1")
  case "$candidate" in
    /etc/aemdlc-environment/*|/usr/local/lib/aemdlc-environment/*|\
    /usr/local/bin/targetctl|/usr/local/bin/pentest-workspace|/usr/local/bin/nmap-ports|/usr/local/bin/doctor) return 0 ;;
    *) return 1 ;;
  esac
}

aem_system_shared_path_allowed() {
  [[ $1 == /root/.bashrc || $1 == /root/.zshrc ]]
}

aem_system_tree_path_allowed() {
  local candidate
  candidate=$(realpath -m -- "$1")
  [[ $candidate == /usr/local/share/aemdlc-environment/powerlevel10k || $candidate == /usr/local/share/aemdlc-environment/oh-my-zsh ]]
}

aem_valid_package_name() {
  [[ $1 =~ ^[a-z0-9][a-z0-9+.-]*(:[a-z0-9]+)?$ ]]
}


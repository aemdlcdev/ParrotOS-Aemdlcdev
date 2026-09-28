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

aem_valid_package_name() {
  [[ $1 =~ ^[a-z0-9][a-z0-9+.-]*(:[a-z0-9]+)?$ ]]
}


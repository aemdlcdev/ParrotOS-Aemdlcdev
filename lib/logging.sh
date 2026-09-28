#!/usr/bin/env bash

aem_log() {
  local level=$1
  shift
  local stamp color reset
  stamp=$(date '+%Y-%m-%d %H:%M:%S')
  color='' reset=''
  if [[ -t 2 ]]; then
    case "$level" in
      info) color=$'\033[1;36m' ;;
      warn) color=$'\033[1;33m' ;;
      error) color=$'\033[1;31m' ;;
      success) color=$'\033[1;32m' ;;
    esac
    reset=$'\033[0m'
  fi
  printf '%s[%s] %-7s%s %s\n' "$color" "$stamp" "${level^^}" "$reset" "$*" >&2
  if [[ -n ${AEM_LOG_FILE:-} ]]; then
    printf '[%s] %-7s %s\n' "$stamp" "${level^^}" "$*" >>"$AEM_LOG_FILE"
  fi
}


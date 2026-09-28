#!/usr/bin/env bash

aem_choose_profile() {
  local choice
  printf '\n%s\n' "========================================"
  printf '  %s — instalador Linux\n' "$PROJECT_NAME"
  printf '%s\n' "========================================"
  printf '%s\n' '[1] Entorno completo' '[2] Escritorio BSPWM' '[3] Terminal y shell' \
    '[4] Herramientas' '[5] Flujo pentest' '[6] Instalación mínima' '[0] Salir'
  read -r -p 'Selección: ' choice
  case "$choice" in
    1) printf full ;;
    2) printf desktop ;;
    3) printf shell ;;
    4) printf tools ;;
    5) printf pentest ;;
    6) printf minimal ;;
    0) exit 0 ;;
    *) aem_die "Selección no válida" ;;
  esac
}


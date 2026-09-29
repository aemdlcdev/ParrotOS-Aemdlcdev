#!/usr/bin/env bash
set -Eeuo pipefail

root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd -P)
source "$root/lib/validation.sh"

allowed=(
  /etc/aemdlc-environment/zsh/root-init.zsh
  /usr/local/lib/aemdlc-environment/bin/targetctl
  /usr/local/share/aemdlc-environment/powerlevel10k
  /usr/local/bin/targetctl
  /root/.bashrc
)
rejected=(
  /etc/passwd
  /usr/local/bin/bash
  /root/.ssh/authorized_keys
  /home/example/.zshrc
)

for path in "${allowed[@]}"; do
  aem_system_path_allowed "$path" || { printf 'Ruta válida rechazada: %s\n' "$path" >&2; exit 1; }
done
for path in "${rejected[@]}"; do
  ! aem_system_path_allowed "$path" || { printf 'Ruta peligrosa aceptada: %s\n' "$path" >&2; exit 1; }
done

aem_system_file_path_allowed /usr/local/bin/targetctl
! aem_system_file_path_allowed /root/.bashrc
aem_system_shared_path_allowed /root/.bashrc
! aem_system_shared_path_allowed /etc/passwd
! aem_system_shared_path_allowed /root/../etc/passwd
aem_system_tree_path_allowed /usr/local/share/aemdlc-environment/powerlevel10k
! aem_system_tree_path_allowed /root/.local/state/aemdlc-environment

printf 'system-paths: OK\n'

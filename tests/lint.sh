#!/usr/bin/env bash
set -Eeuo pipefail

root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)
status=0
while IFS= read -r -d '' file; do
  if ! bash -n "$file"; then status=1; fi
done < <(find "$root" -type f -name '*.sh' -print0)

python3 -m py_compile "$root/scripts/targetctl"
if command -v shellcheck >/dev/null 2>&1; then
  mapfile -d '' scripts < <(find "$root" -type f -name '*.sh' -print0)
  shellcheck -x "${scripts[@]}"
else
  printf 'AVISO: ShellCheck no está instalado\n' >&2
fi

if find "$root" -type f -size +2M -print -quit | grep -q .; then
  printf 'ERROR: se detectó un archivo mayor de 2 MiB\n' >&2
  status=1
fi

exit "$status"


#!/usr/bin/env bash
set -Eeuo pipefail

root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd -P)
fixture=$(mktemp -d)
trap 'rm -rf -- "$fixture"' EXIT
mkdir -p -- "$fixture/bin" "$fixture/home/tester/.local/state"

printf '%s\n' tester >"$fixture/desktop-user"
printf '%s\n' "$fixture/home/tester/.local/state" >"$fixture/desktop-state-home"

cat >"$fixture/payload" <<'SH'
#!/usr/bin/env bash
printf '%s|%s|%s\n' "$HOME" "$XDG_STATE_HOME" "$*"
SH
cat >"$fixture/bin/id" <<'SH'
#!/usr/bin/env bash
printf '0\n'
SH
cat >"$fixture/bin/getent" <<SH
#!/usr/bin/env bash
printf 'tester:x:1000:1000::%s:/bin/zsh\n' '$fixture/home/tester'
SH
cat >"$fixture/bin/runuser" <<'SH'
#!/usr/bin/env bash
[[ $1 == -u && $2 == tester && $3 == -- && $4 == env ]] || exit 64
shift 3
exec "$@"
SH
chmod +x "$fixture/payload" "$fixture/bin/id" "$fixture/bin/getent" "$fixture/bin/runuser"

result=$(
  PATH="$fixture/bin:/usr/bin:/bin" \
  AEM_TARGETCTL_PAYLOAD="$fixture/payload" \
  AEM_DESKTOP_IDENTITY_FILE="$fixture/desktop-user" \
  AEM_DESKTOP_STATE_FILE="$fixture/desktop-state-home" \
  bash "$root/scripts/targetctl-system.sh" set 10.10.10.10 laboratory
)
expected="$fixture/home/tester|$fixture/home/tester/.local/state|set 10.10.10.10 laboratory"
[[ $result == "$expected" ]] || { printf 'Contexto target inesperado: %s\n' "$result" >&2; exit 1; }

printf 'targetctl-system: OK\n'

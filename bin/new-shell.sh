#!/usr/bin/env bash

cat <<'EOTEMP'
#!/usr/bin/env bash

THIS="$(realpath "$0")"
HEREDIR="$(dirname "$THIS")"
SCRIPT="$(basename "$0")"

set -euo pipefail

main() {
}

main "$@"
EOTEMP


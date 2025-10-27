#!/usr/bin/env bash

THIS="$(realpath "$0")"
HEREDIR="$(dirname "$THIS")"
SCRIPT="$(basename "$0")"

set -euo pipefail

main() {
    mv "$HOME/.vimrc" "$HOME/.config/nvim/init.vim"
}

main "$@"

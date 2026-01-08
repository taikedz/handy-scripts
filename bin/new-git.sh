#!/usr/bin/env bash

set -euo pipefail

[[ -n "${1:-}" ]] || {
    echo "No path specified"
    exit 11
}

mkdir -p "$1"
git init "$1"

cd "$1"

git checkout -b main

populate() {
    if [ ! -e "$1" ]; then
        echo -e "$2" > "$1"
    fi
}

populate README.md "# $(basename "$PWD")"
populate LICENSE.txt "All rights reserved - for now."
populate .gitignore "*.swp\n*.pyc\n*.venv\nbin/"

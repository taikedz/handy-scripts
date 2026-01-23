#!/usr/bin/env bash

set -euo pipefail

if [[ -z "$*" ]]; then
    echo Specify a version e.g. 1.25.3
    exit 1
fi

mkdir -p "$HOME/.go-tgzs"
cd "$HOME/.go-tgzs"

version="$1"
tarball="go${version}.linux-amd64.tar.gz"

wget "https://go.dev/dl/$tarball"

echo -n "Deploying: "
realpath "$tarball"

sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "$tarball"

rm "$tarball"


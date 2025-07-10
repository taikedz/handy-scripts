#!/usr/bin/env bash

# These need to be set for some tooling to work - for example, VSCode's Intellisense when using the Go extension

set -euo pipefail

go env | grep -e "GOROOT=|GOENV=" >> ~/go/go.env

echo -e '. "$HOME/go/go.env"\nexport GOROOT\nexport GOPATH' >> "$HOME/.bashrc"

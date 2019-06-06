#!/usr/bin/env bash

cd "$(dirname "$0")"

mkdir -p ~/.local/bin

if ! grep "PATH=" "$HOME/.bashrc" | grep '\.local/bin'; then
    echo 'export PATH="$PATH:$HOME/.local/bin"' >> "$HOME/.bashrc"
fi

addscript() {
    cp "$1" "$HOME/.local/bin/"
}


scripts_to_add=(
    bin/pstree
    bin/rmkernel.sh
    bin/rotate-screen
    bin/secret
    bin/portblock
    bin/sendme
    bin/datereset
    bin/brightness
    bin/mdpreview
    bin/mvaudio
    bin/pow
    bin/saytimer
    bin/sendme
    bin/wifi
    bin/z64
)

for script in "${scripts_to_add[@]}"; do
    addscript "$script"
done

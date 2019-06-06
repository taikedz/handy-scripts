#!/usr/bin/env bash

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


cd "$(dirname "$0")"

mkdir -p ~/.local/bin

if ! grep "PATH=" "$HOME/.bashrc" | grep '\.local/bin'; then
    echo 'export PATH="$PATH:$HOME/.local/bin"' >> "$HOME/.bashrc"
fi

addscript() {
    cp "$1" "$HOME/.local/bin/"
}

addconfig() {
    if grep HANDYCONFIG "$2"; then
        return 0
    fi

    if [[ "${SUDO:-}" = true ]]; then
        cat "$1" | sudo tee -a "$2" >/dev/null
    else
        cat "$1" >> "$2"
    fi

    echo "Updated [$2]"
}

for script in "${scripts_to_add[@]}"; do
    addscript "$script"
done

addconfig configs/vimrc "$HOME/.vimrc"
addconfig configs/user.bashrc "$HOME/.bashrc"
SUDO=true addconfig configs/root.bashrc /etc/bash.bashrc

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

addconfig() {
    if grep -q HANDYCONFIG "$2"; then
        return 0
    fi

    if [[ "${SUDO:-}" = true ]]; then
        cat "$1" | sudo tee -a "$2" >/dev/null
    else
        cat "$1" >> "$2"
    fi

    echo "Updated [$2]"
}

install_scripts() {
    mkdir -p "$HOME/.local/bin"

    for script in "${scripts_to_add[@]}"; do
        cp "$script" "$HOME/.local/bin/"
    done
}

install_configs() {
    addconfig configs/vimrc "$HOME/.vimrc"
    addconfig configs/user.bashrc "$HOME/.bashrc"
    SUDO=true addconfig configs/root.bashrc /etc/bash.bashrc
}

main() {
    cd "$(dirname "$0")"

    case "$1" in
    config|configs)
        install_configs ;;

    script|scripts)
        install_scripts ;;

    --help|-h)
        echo "$0 [configs|scripts]"
        exit
        ;;

    *)
        install_configs
        install_scripts
        ;;
    esac
}

main "$@"

#!/usr/bin/env bash

scripts_to_add=(
    bin/pstree
    bin/rmkernel.sh
    bin/datereset
    bin/z64
    bin/reconcile-swp.sh
)

scripts_to_add_desktop() {
    bin/rotate-screen
    bin/secret
    bin/portblock
    bin/sendme
    bin/brightness
    bin/mdpreview
    bin/mvaudio
    bin/pow
    bin/saytimer
    bin/sendme
    bin/wifi
}

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

copy_scripts() {
    local script
    declare -n p_scriptslist="$1"

    for script in "${p_scriptslist[@]}"; do
        echo "Adding $script"
        cp "$script" "$HOME/.local/bin/"
    done
}

install_scripts() {
    mkdir -p "$HOME/.local/bin"

    copy_scripts scripts_to_add

    if [[ "$1" = desktop ]]; then
        copy_scripts scripts_to_add_desktop
    fi
}

install_configs() {
    addconfig configs/vimrc "$HOME/.vimrc"
    addconfig configs/user.bashrc "$HOME/.bashrc"
    SUDO=true addconfig configs/root.bashrc /etc/bash.bashrc
}

main() {
    cd "$(dirname "$0")"

    action="${1:-}"; shift || :

    case "$action" in
    configs)
        install_configs ;;

    scripts)
        install_scripts "$@" ;;

    all)
        install_configs
        install_scripts "$@"
        ;;

    *)
        echo "'$0 configs' -- install just the configs"
        echo "'$0 scripts [desktop]' -- install just scripts, optionally include desktop scripts"
        echo "'$0 all [desktop]' -- install configs and scripts, optionally include desktop scripts"
        ;;

    esac
}

main "$@"

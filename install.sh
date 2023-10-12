#!/usr/bin/env bash

scripts_to_add=(
    bin/pstree.sh
    bin/rmkernel.sh
    bin/datereset
    bin/z64
    bin/reconcile-swp.sh
    bin/pyv
)

scripts_to_add_desktop=(
    bin/rotate-screen
    bin/secret
    bin/discretion
    bin/sendme
    bin/brightness
    bin/mdpreview
    bin/mvaudio
    bin/pow
    bin/saytimer
    bin/sendme
    bin/wifi
)

addpath() {
    mkdir -p ~/.local/bin

    if ! grep "PATH=" "$HOME/.bashrc" | grep '\$HOME/\.local/bin' >/dev/null; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
    fi
}

addconfig() {
    # Check for marker of having previously done an install of config
    if grep -q HANDYCONFIG "$2" && [[ "${HANDYCONFIG_FORCE:-}" != true ]]; then
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

    mkdir -p "$HOME/.local/bin"

    for script in "${p_scriptslist[@]}"; do
        echo "Adding $script"
        cp "$script" "$HOME/.local/bin/"
    done
}

install_scripts() {
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

install_one() {
    if [[ ! -f "$1" ]]; then return 1; fi

    local this_script=("$1")

    copy_scripts this_script
}

main() {
    cd "$(dirname "$0")"
    addpath

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
        if ! install_one "$action"; then
            echo "'$0 configs' -- install just the configs (set HANDYCONFIG_FORCE=true to forcibly overwrite pre-existing configs)"
            echo "'$0 scripts [desktop]' -- install just scripts, optionally include desktop scripts"
            echo "'$0 all [desktop]' -- install configs and scripts, optionally include desktop scripts"
            echo "'$0 SCRIPTFILE -- install this one script"
        fi
        ;;

    esac
}

main "$@"

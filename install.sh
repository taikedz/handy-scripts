#!/usr/bin/env bash


THIS="$(realpath "$0")"
HEREDIR="$(dirname "$THIS")"
SCRIPT="$(basename "$0")"

set -euo pipefail

add_bashrc_files() {
    # Allow custom isolated *.bashrc files

    mkdir -p ~/.bashrc.d
    mkdir -p "$HOME/.local/bin"

    if ! grep '// LOADRC' ~/.bashrc ; then
        cat "$HEREDIR/bashrc/_loader.sh" >> ~/.bashrc
    fi

    for rcfile in "$HEREDIR"/bashrc/*.bashrc ; do
        if [[ ! -f ~/.bashrc.d/"$(basename "$rcfile")" ]]; then
            cp "$rcfile" ~/.bashrc.d/
        fi
    done
}

scripts_to_add=(
    bin/pstree.sh
    bin/rmkernel.sh
    bin/datereset
    bin/z64
    bin/reconcile-swp.sh
    bin/pyv
    bin/ignore-dir.sh
    bin/new-git.sh
    bin/new-go.sh
    bin/new-shell.sh
    bin/new-py.sh
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
    SUDO=true addconfig configs/root.bashrc /etc/bash.bashrc
}

install_files() {
    for f in "$@"; do
        if [[ ! -f "$f" ]]; then return 1; fi
    done

    local this_script=("$@")

    copy_scripts this_script
}

main() {
    cd "$(dirname "$0")"
    add_bashrc_files

    case "${1:-}" in
    configs)
        install_configs ;;

    scripts)
        install_scripts "$@" ;;

    all)
        install_configs
        install_scripts "$@"
        ;;

    *)
        if ! install_files "$@"; then
            echo "'$0 configs' -- install just the configs (set HANDYCONFIG_FORCE=true to forcibly overwrite pre-existing configs)"
            echo "'$0 scripts [desktop]' -- install just scripts, optionally include desktop scripts"
            echo "'$0 all [desktop]' -- install configs and scripts, optionally include desktop scripts"
            echo "'$0 SCRIPTFILE -- install this one script"
        fi
        ;;

    esac
}

main "$@"

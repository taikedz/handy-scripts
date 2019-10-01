#!/usr/bin/env bbrun

### reconcile-swp.sh SEARCHDIR Usage:help
#
# Find temporary vim "swap" files, try to load them in a new session.
#
# After the user exits vim, they are asked whether to delete the swap file.
#
###/doc

#%include std/out.sh
#%include std/colours.sh
#%include std/autohelp.sh
#%include std/syntax-extensions.sh
#%include std/askuser.sh

$%function rswp:real_name(*p_realfile swapfile) {
    p_realfile="$(dirname "$swapfile")/$(basename "$swapfile"|sed -r 's/^\.(.+)\.swp$/\1/' )"
}

$%function rswp:do_reconcile(swapfile) {
    local realfile

    rswp:real_name realfile "$swapfile"

    if askuser:confirm "${CBPUR}Swap found for '$realfile'. Edit?"; then
        vim "$realfile"
    fi

    if askuser:confirm "${CBRED}Delete$CDEF [${CBBLU}$swapfile${CDEF}]?"; then
        out:warn "Removing $swapfile"
        rm "$swapfile"

    else
        out:info "Keeping $swapfile"
    fi

    echo
}

$%function rswp:search(?target) {
    out:info "Searching for swap files ..."

    find "${target:-.}" -name '.*.swp' -exec bash "$0" :reconcile {} \;

    out:info ".... done."
}

main() {
    autohelp:check "$@"

    if [[ "$1" = :reconcile ]]; then
        rswp:do_reconcile "$2"

    else
        rswp:search "$1"
    fi
}

main "$@"

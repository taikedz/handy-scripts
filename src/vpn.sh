#!/usr/bin/env bbrun

### VPN controller Usage:help
#
#    vpn { start | stop }
#
# Start or stop the VPN connection.
#
###/doc

#%include std/out.sh
#%include std/isroot.sh
#%include std/autohelp.sh

VPN_CONFIG="${VPN_CONFIG:-$HOME/.config/vpnc/default.conf}"

if [[ "$1" = sudo ]]; then
    shift

    isroot:require "You must be root to run this script."

    [[ -f "$VPN_CONFIG" ]] || out:fail "No $VPN_CONFIG file found."



    if [[ "$1" = start ]]; then
        out:info "Starting VPN using [$VPN_CONFIG]"
        vpnc-connect "$VPN_CONFIG"

    elif [[ "$1" = stop ]]; then
        out:info "Stopping VPN"
        vpnc-disconnect

    else
        echo "Specify 'start' or 'stop'"
    fi
else
    autohelp:check-or-null "$@"
    sudo "$0" sudo "$@"
fi

# vim: set filetype=sh:

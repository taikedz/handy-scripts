#!/bin/bash

### <HELP>
# Script to remove extraneous kernels. Tested for Ubuntu 16.04 and 18.04
#
# If kernel updates or autoclean/autoremove fail because there is no more space in /boot
#  then you can use this script to clean out old stuff and free up space to return to a normal state
#
# try
#    ./rmkernel.sh 2
#
# this will print the removal commands to remove all but the 2 newest kernels (by version number)
#
# To apply the removals run
#    ./rmkernel.sh 2 | sudo bash
#
#
# ** Fixes for missing image files **
#
# After running kernel removals, you may get errors like `Internal Error: Could not find image <path>`
#
# Simply `touch <path>` on each of those paths and run again `apt-get -f install` to fix-install.
#  Then re-run `rmkernel.sh <N>`
#
### </HELP>

ERR_help_not_found=100

rmk:list-installed-kernel-info-pairs() {
    dpkg --list 'linux-image*'|
        grep ii|
        awk '{print $3 "\t" $2}'|
        sed -r 's/~\S+//'|
        sort -V
}

rmk:list-installed-kernel-packages() {
    rmk:list-installed-kernel-info-pairs|
        cut -f2
}

rmk:list-installed-kernel-versions() {
    rmk:list-installed-kernel-info-pairs|
        cut -f1
}

rmk:full-clean() {
    # Perform a purge of package-less kernels
    rmk:purge-packageless-kernels

    # Regular dpkg-based clean
    rmk:clean-dpkg "$1"
}

rmk:clean-dpkg() {
    echo ""
    echo "# Keeping the most recent $1 kernel(s)"

    rmk:list-installed-kernel-packages|
        head -n -"$1"| while read; do
            echo dpkg --force-all --remove "$REPLY"
        done
    
    echo ""
    echo "apt-get autoclean -y && apt-get autoremove -y"

    echo "echo 'Fixing missing packages ...'"
    echo "apt-get -f install -y"
}

rmk:shorten-version() {
    # Remove the final number ("patch" (??) version)
    #  since it is not used in file names in /boot
    
    sed -r 's/.[0-9]+$//g'
}

rmk:purge-packageless-kernels() {
    # Previous attempts at kernel forced removal may have caused some
    #  excess files to remain in /boot
    # This clears such files out.
    local current_versions="$(rmk:list-installed-kernel-versions|rmk:shorten-version|xargs echo|sed 's/ /|/g')"

    echo "#  The following do not have a corresponding installed package:"
    
    ls /boot/config* /boot/initrd* /boot/retpoline* /boot/vmlinuz* /boot/abi* 2>/dev/null | grep -vP "$current_versions" | sed -r 's/^/rm /'
}

util:isnum() {
    [[ "$1" =~ ^[0-9]+$ ]]
}

util:printhelp() {
    local helpstart helpend script
    script="$0"

    helpstart="$(grep -E '^### <HELP>' "$script" -n|cut -d: -f1)"
    helpend="$(grep -E '^### </HELP>' "$script" -n|cut -d: -f1)"

    (util:isnum "$helpstart" && util:isnum "$helpend") || {
        echo "! Could not extract help section"
        exit $ERR_help_not_found
    }

    sed -n "$helpstart,$helpend p" "$script"
}

main() {
    [[ $# -gt 0 ]] || {
        util:printhelp
        exit
    }

    echo "# Pipe the following output to \`sudo bash\` to execute the deletions:"
    echo ""

    if util:isnum "$1"; then
        rmk:full-clean "$1"

    else
        echo "$1 is not a number"
        exit 2
    fi
}

main "$@"

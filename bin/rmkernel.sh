#!/bin/bash

### <HELP>
# Script to remove extraneous kernels
#
# If kernel updates or autoclean/autoremove fail because there is no more space in /boot
#  then you can use this script to clean out old stuff and free up space to return to a normal state
#
# try
#    ./rmkernel.sh 2
# this will print the removal commands
#
# To apply the removals run
#    ./rmkernel.sh 2 | sudo bash
#
#
# ** Boot cleaning **
#
# If the /boot partition really filled up completely, you might want to manually remove
# some files from /boot using
#
#   ./rmkernel.sh clean-boot
#
# (pipe to `bash` to apply)
#
# This is a force-removal though, and may break your system.
#
#
#
# ** Fixes for missing image files **
#
# After running kernel removal, you may get errors like `Internal Error: Could not find image <path>`
#
# Simply `touch` each of those paths and run again `apt-get -f install` to fix-install.
#
### </HELP>

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

rmk:clean-dpkg() {
    # Perform a purge of package-less kernels
    #rmk:clean-boot

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

rmk:clean-boot() {
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

    if [[ "$1" = clean-boot ]]; then
        rmk:clean-boot

    elif util:isnum "$1"; then
        rmk:clean-dpkg "$1"

    else
        echo "$1 is not a number"
        exit 2
    fi
}

main "$@"

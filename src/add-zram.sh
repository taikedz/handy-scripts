#!/usr/bin/env bbrun

# Configure the size of the ZRAM pool (in MiB)
ZRAM_SIZE="${ZRAM_SIZE:-512}"

### add-zram Usage:help
#
# Add zRAM and activate on a systemd Linux host.
#
# Set environment variable ZRAM_SIZE to an integer of MiB for the size of the zRAM pool.
#
# By default, ZRAM_SIZE=512
#
# Based off of a tutorial by Jack Wallen at https://www.techrepublic.com/article/how-to-enable-the-zram-module-for-faster-swapping-on-linux/
#
###/doc

#%include std/safe.sh
#%include std/isroot.sh
#%include std/out.sh
#%include std/askuser.sh
#%include std/autohelp.sh

azram:overwrite_check() {
    local need_overwrite=no
    local zramf
    local zram_files=(
        /etc/modules-load.d/zram.conf
        /etc/modprobe.d/zram.conf
        /etc/udev/rules.d/99-zram.rules
        /etc/systemd/system/zram.service
    )

    for zramf in "${zram_files[@]}"; do
        [[ ! -f "$zramf" ]] || {
            echo "$zramf"
            need_overwrite=yes
        }
    done

    if grep /dev/zram0 < /proc/swaps ; then
        need_overwrite=yes
    fi

    if [[ "$need_overwrite" = yes ]]; then
        askuser:confirm "It looks like some zRAM configuration is already active - proceed (previous configuration will be overwritten!)?" || out:fail "Abort"
    fi
}

azram:add_conf() {
    echo "zram" > /etc/modules-load.d/zram.conf

    echo "options zram num_devices=1" > /etc/modprobe.d/zram.conf

    echo 'KERNEL=="zram0", ATTR{disksize}="%ZRAMSIZE%M",TAG+="systemd"' | sed "s/%ZRAMSIZE%/$ZRAM_SIZE/" > /etc/udev/rules.d/99-zram.rules

    cat <<EOSERVICE > /etc/systemd/system/zram.service
[Unit]
Description=Swap with zram
After=multi-user.target

[Service]
Type=oneshot 
RemainAfterExit=true
ExecStartPre=/sbin/mkswap /dev/zram0
ExecStart=/sbin/swapon /dev/zram0
ExecStop=/sbin/swapoff /dev/zram0

[Install]
WantedBy=multi-user.target
EOSERVICE
}

azram:main() {
    isroot:require "You must be root to run this script."

    azram:overwrite_check

    azram:add_conf

    systemctl enable zram

    out:info "You will need to reboot for this change to take effect."
}

autohelp:check "$@"
azram:main "$@"

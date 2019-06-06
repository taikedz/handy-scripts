# Ubuntu

On grub menu press `c`

Run `vbeinfo` to list supported sizes

Run `reboot` to return to grub

Edit `/etc/default/grub`

Add a line

	GRUB_GFXPAYLOAD_LINUX=640x480

Then update grub

	sudo update-grub

then reboot

# CentOS

    vim /etc/grub2.cfg

Find the kernel vmlinuz

At the end of the options, add `vga=791`

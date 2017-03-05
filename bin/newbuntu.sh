#!/bin/bash

set -uo pipefail

newuser=
sshserver=
sshport=22
DEBUG=no

# TODO
# Interactive mode toggle

function faile {
	echo "[1;31mFAIL: $@[0m" 1>&2
	exit 1
}

function debug {
	[[ "$DEBUG" = "yes" ]] && echo "[1;33mDEBUG: $@[0m" 1>&2
}

function printhelp {
cat <<EOHELP

Set up your new server according to this basic script

When run without options, operates on the current server.

You need to specify a target user.

OPTIONS

-u USER
	Target user name.

-s SERVER
	Target server name, or user+server. Typically you should specify 'root@YOURSERVER' to specify connecting with the root account

	If you do not specify the server, the script operates on the local server.

-p PORT
	Port on which to connect, by default this is port 22

EOHELP
}

# ===============
# Only run as root
debug Check for root

if [[ "$UID" != 0 ]]; then
	debug "Need to sudo"
	sudo "$0" $@
	exit 0
fi

# ================
# Now it is safe to consume args (after root check)
debug Getting args

while [[ -n "$@" ]]; do
ARG=$1 ; shift
debug "Got $ARG"
case "$ARG" in
	-u)
		newuser=$1
		shift
		;;
	-s)
		sshserver=$1
		shift
		;;
	-p)
		sshport=$1
		shift
		;;
	--debug)
		DEBUG=yes
		;;
	--help)
		printhelp
		exit 0
		;;
	*)
		faile "Unknown argument '$ARG'; use '--help' for more info"
		;;
esac
done

debug Done getting args

debug Check for user

if [[ -z "$newuser" ]]; then
	faile "No target user"
fi

if [[ -n "$sshserver" ]]; then
	debug "SCP to $sshserver"
	scp -P "$sshport" "$0" "$sshserver:./" || faile Cannot scp
	debug "SSH to $sshserver"
	ssh "$sshserver" -p "$sshport" "./$(basename $0)" || faile Cannot ssh
	exit 0
fi

debug Checking if $newuser exists

# ===============
# Set up initial user
if [[ $(grep -P "^$newuser:" /etc/passwd -c) -lt 1 ]]; then
	debug "Creating user [$newuser]"
	adduser "$newuser" # interactive, will prompt for password
	gpasswd -a "$newuser" sudo # make super-admin
fi

# ===============
# Add new user's keys, only if necessary
debug "Key adding"

mkdir -p ~"$newuser"/.ssh
cp -i -r ~/.ssh/authorized_keys ~"$newuser"/.ssh/
chown -R $newuser:$newuser ~"$newuser"/.ssh
chmod 600 ~"$newuser"/.ssh
chmod 700 ~"$newuser"/.ssh/authorized_keys

# We have custom user, now remove SSH root login

debug Check for SSHd config
[[ -f /etc/ssh/sshd_config ]] && {
	debug "Deny root login"
	sed -r -e 's/^#?(PasswordAuthentication).*$/\1 no/' -e 's/^#?(PermitRootLogin).*$/\1 no/' -i /etc/ssh/sshd_config
	service ssh restart # needs to be updated for systemd
}

# =================
# Final setup tasks

debug Run updates

apt-get update
apt-get install tmux vim htop git --assume-yes

read -p "Install LAMP stack? > "
if [[ "$REPLY" = "yes" ]] || [[ "$REPLY" = "y" ]]; then
	apt-get install apache2 php5{,-mysql} mariadb-server --assume-yes
	chown -R www-data:www-data /var/www
	mkdir /var/www/pkg
	gpasswd -a "$newuser" www-data
fi

mkdir /root/gitprojects
cd /root/gitprojects
git clone https://github.com/taikedz/handy-scripts
git clone https://github.com/taikedz/vefirewall
git clone https://github.com/taikedz/alpacka

(cd vefirewall ; bash ./install)
(cd handy-scripts ; bash bin/install)
(cd alpacka; bash setup/install)

vefirewall --apply # this will be run in interactive mode

# =================
# Finally, do upgrade - potentially longest task, hence last

#apt-get upgrade --assume-yes

#!/bin/bash

set -u

CONTAINERNAME=
TEMPLATEOS=
ACTION=
EXPOSURE=

DOATTACH=no
INTERFACES='^'$(ifconfig | grep -P '^[^\s]+'|cut -d' ' -f 1|xargs echo|sed 's/ /|/g')'$'
numpat='^[0-9]+$'

DEBUGMODE=no

function uconfirm {
	reqanswer='y|yes|Y|YES'
	read -p "[1;32$@[0m : y/N> "
	[[ $? = 0 ]] && [[ "$REPLY" =~ $reqanswer ]] # returns the status of this test combination
}

function faile {
	echo "[1;31m$@[0m" 1>&2
	exit 1
}

function debuge {
	if [[ "$DEBUGMODE" = yes ]]; then
		echo "[1;34m${@}[0m" 1>&2
	fi
}

function warne {
	echo "[1;33m${@}[0m"
}

function attachcontainer {
	if [[ $DOATTACH = yes ]]; then
		#warne "Attaching to container root session"
		lxc-attach -n "$CONTAINERNAME"
	fi
}

function usecontainer {
	lxc-ls | grep "$CONTAINERNAME" || faile "No such container $CONTAINERNAME"
}

function setupuser {
	read -p "Username: "
	myuser=$(cat /etc/passwd|cut -d ':' -f1|grep -P "^$REPLY\$")
	userhome=$(cat /etc/passwd|grep -P "^$myuser:"|cut -d ':' -f6)
	[[ -z "$myuser" ]] && faile "No such user [$myuser]"

	# there is an issue when setting up on ecryptfs encrypted home directories
	# https://bugs.launchpad.net/ubuntu/+source/lxc/+bug/1389305
	if [[ $(mount | grep "$myuser" | grep ecryptfs -c) -gt 0 ]]; then
		uconfirm "$myuser seems to be using an encrypted home folder. Their containers will not allow suid executables. Install workaround at /var/nocryptlxc?" && {
			$nclxcd="/var/nocryptlxc/$myuser"
			mkdir -p "$nclxcd"

			[[ -d "$userhome/.config/lxc" ]] && mv "$userhome/.config/lxc" "$nclxcd/config"
			[[ -d "$userhome/.local/share/lxc" ]] && mv "$userhome/.local/share/lxc" "$nclxcd/store"
			mkdir -p "$nclxcd/config"
			mkdir -p "$nclxcd/store"
			chown $myuser:$myuser "$nclxcd" "$nclxcd/config" "$nclxcd/store"
			
			ln -s "$nclxcd/config" "$userhome/.config/lxc"
			ln -s "$nclxcd/store" "$userhome/.local/share/lxc"
		}
	fi
	[[ ! -e "$userhome/.config/lxc" ]] && mkdir -p "$userhome/.config/lxc"
	chown -R $myuser:$myuser "$userhome/.config/lxc"

	echo "$myuser veth lxcbr0 10" >> /etc/lxc/lxc-usernet
	cp /etc/lxc/default.conf "$userhome/.config/lxc/"
	chown $myuser:$myuser "$userhome/.config/lxc/default.conf"
	cat <<EOF >> "$userhome/.config/lxc/default.conf"

lxc.id_map = u 0 $(cat /etc/subuid |grep $myuser| awk -F ':' '{print $2,$3}')
lxc.id_map = g 0 $(cat /etc/subgid |grep $myuser| awk -F ':' '{print $2,$3}')
EOF
	# these need to be set so as to be able to run unprivileged
	# the rest of the structure in $userhome/.local/share/lxc should be OK
	chmod o+x $userhome
	chmod o+x $userhome/.local
	chmod o+x $userhome/.local/share
}

function printhelp {
cat <<EOF

LXC Wrapper by Tai Kedzierski (C) 2016
Released under the GPLv3 (GNU General Public License v3)

DESCRIPTION

Easy wrapper for managing LXC containers

If LXC is not installed, you will be prompted to install.

Installation and other root tasks require sudo access.

USAGE

  $(basename $0) ACTION CONTAINERNAME [OPTIONS]

ACTIONS

install
	install LXC if it is not yet installed
	offers to set up a non-privileged user

list
	list the details of the specirfied container

use
	generic action, use with modifier options

create the named container
	requires a template OS name

start
	start the named container

stop
	stop the named container

destroy
	destroy the named container

OPTIONS

-t TEMPLATEOS
	Name of the target OS, e.g. "ubuntu"

-a
	operational option
	attach to the console of the named container
	can only be used with create and start actions

-e iface export inport
	operational option
	expose the container's port (inport) to the host's port (export) on interface (iface)
	can be used with start, create and use actions

EOF
}

if [[ -z "$@" ]]; then
	lxc-ls --fancy
	exit 0
fi

if [[ -z "$@" ]]; then
	faile "You must specify the action to take"
fi

ACTION=$1 ; shift

while [[ -n "$@" ]]; do
	ARG=$1 ; shift
	case "$ARG" in
		-a)
			debuge attach option
			DOATTACH=yes
			;;
		-t)
			TEMPLATEOS="$1" ; shift
			;;
		-e)
			IFACE=$1 ; shift
			EXPORT=$1 ; shift
			INPORT=$1 ; shift
			if [[ ! "$IFACE" =~ $INTERFACES ]] || [[ ! "$EXPORT" =~ $numpat ]] || [[ ! "$INPORT" =~ $numpat ]]; then
				faile "Invalid interface, external port or internal port: $IFACE $EXPORT $INPORT"
			fi
			EXPOSURE="$EXPORTS,$IFACE:$EXPORT:$INPORT"
			;;
		--install)
			DOINSTALL=yes
			;;
		--help|-h)
			printhelp
			exit 0
			;;
		*)
			CONTAINERNAME=$ARG
			;;
	esac
done

if [[ "$ACTION" = install ]]; then
	[[ $UID -ne 0 ]] && faile "You need to be root"
	which lxc-ls >/dev/null 2>&1 || ( uconfirm "Install LXC?" && {
		apt update
		apt install lxc
	}
	)
	lxc-checkconfig

	uconfirm "Setup unprivilieged user?" && setupuser
	exit 0
fi

if [[ -z "$CONTAINERNAME" ]]; then
	faile "You must specify a container name"
fi


if [[ -n "$EXPOSURE" ]]; then
	usecontainer
	CONIP=$(lxc-ls --fancy | tail -n +3|grep "$CONTAINERNAME" | awk '{print $3}')
	for expx in $(echo "${EXPOSURE#,}" | sed 's/,/ /g'); do
		myiface=$(echo $expx|cut -d':' -f 1)
		myext=$(echo $expx|cut -d':' -f 2)
		myint=$(echo $expx|cut -d':' -f 3)
		sudo iptables -t nat -A PREROUTING -i $myiface -p tcp --dport $myext -j DNAT --to "$CONIP:$myint"
	done
fi

if [[ "$ACTION" = create ]]; then
	if [[ -z "$TEMPLATEOS" ]]; then
		faile "No template OS specified. Hint: try option '-t ubuntu'"
	fi
	time lxc-create -n "$CONTAINERNAME" -t "$TEMPLATEOS"
	# this downloads from some online location... where??
	attachcontainer
elif [[ "$ACTION" = start ]]; then
	usecontainer
	lxc-start -n "$CONTAINERNAME" -d
	attachcontainer
elif [[ "$ACTION" = list ]]; then
	lxc-ls --fancy | head -n 2
	lxc-ls --fancy | tail -n +3 | grep "$CONTAINERNAME"
elif [[ "$ACTION" = stop ]]; then
	usecontainer
	lxc-stop -n "$CONTAINERNAME"
elif [[ "$ACTION" = confirm ]]; then
	usecontainer
	read -p "[1;31mTo destroy the container [1;32m$CONTAINERNAME[1;31m, type its name in again: [0m"
	if [[ "$REPLY" = "$CONTAINERNAME" ]]; then
		lxc-destroy -n "$CONTAINERNAME"
	fi
elif [[ "$ACTION" = use ]]; then
	usecontainer
	attachcontainer
fi

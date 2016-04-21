#!/bin/bash

bfile=
mybbuild=bbuild
mytarrun=tarrun

while [[ -n "$*" ]]; do
	ARG=$1; shift
	case "$ARG" in
	-b|--bbuild)
		mybbuild=$1; shift
		;;
	-t|-tarrun)
		mytarrun=$1; shift
		;;
	*)
		if [[ -n "$bfile" ]]; then
			echo "Please only specify ONE file to build at a time."
		fi
		bfile=$1; shift
		;;
	esac
done


if [[ -z "$bfile" ]]; then
	echo "Please specify a file to compile"
	exit 1
fi

bname="$(basename "$bfile")"

if [[ ! -f "$bfile" ]]; then
	echo "Not a file [$bfile]"
	exit 2
fi

# ======= optional shellcheck block, if installed ----¬

if [[ -n "$(which /usr/bin/shellcheck 2>/dev/null)" ]]; then
	shellcheck "$bfile"
	scstatus=$?
	read -p "Build ? [y/N] > "

	if [[ "$REPLY" != y ]]; then
		exit $scstatus
	fi
else
	echo "Install 'shellcheck' for pre-build syntax check. Proceeding with build now." 1>&2
fi

# ========/

bbuild "$bfile"

mkdir -p test/

if [[ "$*" =~ --install ]]; then
	sudo mv "$bname.tgz" "/usr/local/bin/$bname" && echo "Installed $bname to /usr/local/bin"
else
	mv "$bname".tgz "test/$bname"
	echo "Stored "$bname" in $PWD/test/$bname"
fi

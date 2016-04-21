#!/bin/bash

if [[ -z "$*" ]]; then
	echo "Please specify a file to compile"
	exit 1
fi

bfile="$1"
bname="$(basename "$bfile")"

if [[ ! -f "$bfile" ]]; then
	echo "Not a file [$bfile]"
	exit 2
fi

# =======

shellcheck "$bfile"
scstatus=$?
read -p "Build ? [y/N] > "

if [[ "$REPLY" = y ]]; then
	bbuild "$bfile"
else
	echo "Shellcheck exited with code $scstatus"
	exit $scstatus
fi

mkdir -p test/

if [[ "$*" =~ --install ]]; then
	sudo mv "$bname.tgz" "/usr/local/bin/$bname" && echo "Installed $bname to /usr/local/bin"
else
	mv "$bname".tgz "test/$bname"
	echo "Stored "$bname" in $PWD/test/$bname"
fi

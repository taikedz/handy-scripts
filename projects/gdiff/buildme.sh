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

bbuild "$bfile"
mkdir -p test/

if [[ "$*" =~ --install ]]; then
	sudo mv "$bname.tgz" "/usr/local/bin/$bname" && echo "Installed $bname to /usr/local/bin"
else
	mv "$bname".tgz "test/$bname"
	echo "Stored "$bname" in test/$bname"
fi

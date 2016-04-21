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

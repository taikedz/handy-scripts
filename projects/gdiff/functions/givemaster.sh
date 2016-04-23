#!/bin/bash

function givemaster {
	switchbranch master
	if [[ ${1+x} = x ]]; then local mytmp=$1
	local tgtdir=$(myprojdir)
	else local mytmp="$(mktemp --tmpdir "master-$(basename "$tgtdir")-XXX.tgz")"; fi
	tar -czf "$mytmp" -C "$tgtdir" ./ --exclude='./.git*'
	switchbranch "$CURBRANCH"
	infoe "Wrote master contents to $mytmp"
}

function myprojdir {
(
	while [[ ! -d ./.git ]]; do
		if [[ "$PWD" = / ]]; then
			exit 1
		fi
		cd ..
	done
	echo "$PWD"
) || faile "Not a git directory"
}

#!/bin/bash

## Find .ogg, .m4a and .mp4 files in specified folders, and generate a ffmpeg-based script for converting the fiels and moving the originals to a saved location
##
## Due to difficulties in processing special characters through a pipe, you MUST use process substitution:
##
##    bash <(convert-to-mp3.sh DIRNAMES ...)
##

# Written because my sodding car USB reader doesn't recognize other formats like OGG.

convert:find_files() {
	find "$1" | grep -vP '(^|/)_originals/' |grep -P '\.(ogg|m4a|mp4)$'
}

convert:process_each() {
	local newfile label size rest contdir soundfile soundfile
	echo "set -x"

	while read soundfile; do
		contdir="$(dirname "$soundfile")"
		read label size rest < <(stat "$soundfile" | grep -P '^\s+Size:')

		if [[ "$size" = 0 ]]; then
			echo "# Skipping '$soundfile'"
			continue
		fi

		newfile="$soundfile.mp3"
		if [[ ! -f "$newfile" ]]; then
			echo ffmpeg -loglevel 16 -i "\"$soundfile\"" "\"$newfile\"" "|| { rm \"$newfile\"; exit 1 ; }"
		fi

		echo mkdir -p "\"_originals/$contdir\""
		echo mv "\"$soundfile\"" "\"_originals/$contdir/\""
		echo
	done
}

names:base() {
	local base filename
	filename="$(basename "$1")"

	# TODO not finished
}

printhelp() {
	egrep '^##' "$0"
	exit 0
}

checkhelp() {
	if [[ $# = 0 ]] ||  [[ "$*" =~ --help ]]; then
		printhelp
	fi
}

main() {
	local dirname

	checkhelp "$@"

	trap exit SIGINT
	for dirname in "$@"; do
		convert:find_files "$dirname" | convert:process_each
	done
}

main "$@"

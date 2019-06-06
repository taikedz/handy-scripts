#!/usr/bin/env bash

# From http://soliverez.com.ar/home/2015/04/using-digikam-and-owncloud-to-share-family-pictures/

FILES_SOURCE="$1"
FILES_DEST="$2"

IFS="$(echo -en "\n\b")"
cd "$FILSE_SOURCE"

tree_list=($(find . -type d))

for t in "${tree_list[@]}"; do
    file_list=($(exiftool -m -Rating "$t" | awk '/Rating : 5/ { print p} {p = $0 }' | sed s/========// | sed -e 's/^[ \t]*//'))

    if [ -n "${file_list[*]:-}" ]; then
        mkdir -p "$FILES_DEST/$t"
        for f in "${file_list[@]}"; do
            cp -au "$f" "$FILES_DEST/$t"
        done
    fi
done

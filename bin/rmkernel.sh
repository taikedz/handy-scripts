#!/bin/bash

versions=$(ls /boot | grep -P "generic|vmlinuz" | sed -r -e 's/^([^-]+)-([^-]+-[^-]+).+$/\2/g' | sort | uniq)
vcount=$(echo $versions | sed -r -e 's/ /\n/g' | wc -l)

[[ $# -gt 0 ]] || {
	echo -e "You must specify the number of most recent images to keep.\n\nThere are currently $vcount kernel versions in /boot."
	exit
}

matcher='^[0-9]+$'
[[ $1 =~ $matcher ]] || {
	echo "$1 is not a number"
	exit 2
}

echo "# Keeping the most recent $1 kernel(s)"
echo "# pipe to sudo bash to execute the following deletions:"

versions=$(echo $versions | sed -r -e 's/ /\n/g' | head -n "-$1" )

#echo -e "#Versions:\n$versions\n====="

dryrun=
for ver in $versions; do
	dryrun="$dryrun "$(ls /boot/*$ver* )
done
echo -n 'rm '
echo $dryrun | sed -r -e 's/ +/\nrm /g'
exit


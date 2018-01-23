#!/bin/bash

# Versions are LABEL-VERSION-ISSUANCE-VARIANT
#  we are interesetd in the VERSION-ISSUANCE pair

versions="$(ls /boot| grep -P "generic|vmlinuz" | sed -r -e 's/^[^-]+-([^-]+-[^-]+).+$/\1/g' | sort -V | uniq)"

vcount=$(echo "$versions" | wc -l)

[[ $# -gt 0 ]] || {
	echo -e "You must specify the number of most recent images to keep.\n\nThere are currently $vcount kernel versions in /boot."
	exit 1
}

keepcount="$1"; shift

numpat='^[0-9]+$'
[[ $keepcount =~ $numpat ]] || {
	echo "[$keepcount] is not a number"
	exit 2
}

echo -e "#\033[32;1m Keeping the newest $keepcount kernel(s)\033[0m"
echo -e "#\033[33;1m pipe to sudo bash to execute the following deletions:\033[0m"

# List versions, omit the last few (MINUS keepcount) which we are keeping
delversions=($(echo "$versions" | head -n "-$keepcount" ))

# The obverse
keepversions=($(echo "$versions" | tail -n "$keepcount" ))

echo ''

echo "# Keeping:"
for keepver in "${keepversions[@]}"; do
	echo "# $keepver"
done

echo ''

for ver in "${delversions[@]}"; do
	ls /boot/*"$ver"* | sed -r -e 's/^/rm /g'
done

echo -e "\napt-get autoclean -y && apt-get autoremove -y\n"


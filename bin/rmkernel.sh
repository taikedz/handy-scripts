#!/bin/bash

versions=$(ls /boot | grep -P "generic|vmlinuz" | sed -r -e 's/^([^-]+)-([^-]+-[^-]+).+$/\2/g' | sort | uniq)
vcount=$(echo $versions | sed -r -e 's/ /\n/g' | wc -l)

[[ $# -gt 0 ]] || {
	echo -e "You must specify the number of most recent images to keep.\n\nThere are currently $vcount kernel versions in /boot."
	exit
}

keepcount="$1"; shift

numpat='^[0-9]+$'
[[ $keepcount =~ $numpat ]] || {
	echo "$keepcount is not a number"
	exit 2
}

echo "#[31;1m Keeping the most recent $keepcount kernel(s)[0m"
echo "#[33;1m pipe to sudo bash to execute the following deletions:[0m"

keepversions=$(echo $versions | sed -r -e 's/ /\n/g' | head -n "-$keepcount" )

#echo -e "#Versions:\n$versions\n====="
echo ''

for ver in $keepversions; do
	echo /boot/*$ver* | sed -r -e 's/ +/\nrm /g' -e 's/^/rm /'
done

echo -e "\napt-get autoclean -y && apt-get autoremove -y \n"


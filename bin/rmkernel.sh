#!/bin/bash

# Script to remove extraneous kernels

# If kernel updates or autoclean/autoremove fail because there is no more space in /boot
#  then you can use this script to clean out old stuff and free up space to return to a normal state

# try
#	./rmkernel.sh 2
# this will print the removal commands
# To apply the removals run
#	./rmkernel.sh 2 | sudo bash

rmk:dpkg() {
	dpkg --list 'linux-image*'|
		grep ii|
		awk '{print $3 "\t" $2}'|
		sed -r 's/~\S+//'|
		sort -V|
		cut -f2|
		head -n -"$1"| while read; do
			echo dpkg --force-all --remove "$REPLY"
		done
	
	apt-get autoclean && apt-get autoremove
}

main() {
	[[ $# -gt 0 ]] || {
		echo -e "You must specify the number of most recent images to keep."
		exit
	}

	matcher='^[0-9]+$'
	[[ $1 =~ $matcher ]] || {
		echo "$1 is not a number"
		exit 2
	}

	echo "# Keeping the most recent $1 kernel(s)"
	echo "# pipe to sudo bash to execute the following deletions:"

	rmk:dpkg "$1"
}

main "$@"

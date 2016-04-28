#!/bin/bash

	if [[ -d ./secdir.enc ]]; then
		uconfirm "It seems this directory has already been initialized. Overwrite? This will destroy configs!!" ||
			faile "Aborting re-initalization"
	fi
	infoe "Initialize a new directory"
	debuge "App dir is $APPLICATION_WD"
	{
		mkdir -p "$PWD/secdir.enc"
		#% bundle files/config
		cp $APPLICATION_WD/files/config secdir.enc/
		cp $APPLICATION_WD/README.md secdir.enc/
	} && echo "secdir has been set up for use in $PWD"
	exit

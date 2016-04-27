#!/bin/bash

	if [[ -d ./.enc ]]; then
		uconfirm "It seems this directory has already been initialized. Overwrite? This will destroy configs!!" ||
			faile "Aborting re-initalization"
	fi
	infoe "Initialize a new directory"
	debuge "App dir is $APPLICATION_WD"
	{
		mkdir -p "$PWD/.enc"
		cp files/config .enc/
	} && echo "secdir has been set up for use in $PWD"
	exit

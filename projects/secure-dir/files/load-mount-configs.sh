#!/bin/bash

config_usesection Mount

export CWDALLOWED=yes
if config_isset load_in_cwd; then CWDALLOWED=$(config_readval load_in_cwd); fi

export LOADDIR=$PWD
if config_isset home; then
	LOADDIR=$(config_readval home)
	LOADDIR=${LOADDIR//'$HOME'/$HOME}
fi
debuge "Loading to $LOADDIR"

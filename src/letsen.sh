#!/bin/bash

## letsen.sh Usage:help
# 
# 	Shell-based Let's Encrypt Automator
# 
# The "Let's Encrypt" project aims to provide browser-recognized SSL
# certificates to any website free of charge, with the Let's Encrypt
# group acting as the browser-recognized Certificate Authority.
# 
# This script is designed to automate Let's Encrypt certificate renewal.
# 
# Place it on your server - for example in /usr/local/bin/ - and add
# a root cron to call it at the desired frequency (recommended: once a day).
#
# Usage:
# 
# 	letsen.sh {--certificate=CERTIFICATE|--config=CONFIGFILE}
# 
# Options: ---------------------
# 
# By default, the operation is to renew the certificate
# specified either on the command line or in the custom
# configuration file.
# 
#   CERTIFICATE
# 
# Specify a certificate to renew, as path to certificate
# 
#   CONFIGFILE
# 
# Specify a configuration file. Configuration file over-
# rides the certificate specified on command line.
#
# Config file: -----------------
# 
# The default config file can be found at /etc/letsen/letsen.cfg
# 
# You can define any number of configuration files,
# but only the default one will be used unless other-
# wise specified.
# 
# The default configuration is always loaded.
# 
# Any other configuration file overwirtes only the
# relevant variables. Only one secondary configuration
# file can be used per run.
# 
#
# (C) 2015 Tai Kedzierski
# GNU General Public License version 3
# https://www.gnu.org/licenses/gpl-3.0.html
# 
# This script is loosely based on the efforts by Damia Soler
# (https://blog.damia.net); written with the intent to be easily configur-
# able, and usable in multi-host setups.
# 
###/doc 

## -------- optional - add signal trap
## 'trap' COMMAND signal

#trap 'exit' SIGINT

set -u

#%include bashout autohelp

# Config file
CONFIGFILE=/etc/letsen/letsen.cfg

function testvar {
	shift # first token is var name
	echo "$@"
}

function testconfig {
	set +u
	cat <<EOVARS | while read x; do
CONFIGFILE $CONFIGFILE
DAYSTILRENEW $DAYSTILRENEW
ADMINEM $ADMINEM
CERTEM $CERTEM
LEXEC $LEXEC
OPERATION $OPERATION
CERTIFICATE $CERTIFICATE
WEBROOT $WEBROOT
FQDN $FQDN
EOVARS
		if [[ -z "$(testvar $(echo $x) )" ]]; then
			faile "Undefined $x"
			exit 1
		fi
	done
	echo "OK"
	set -u
}

## -------- Define script-wide variables

# Threshold of number of days lafte before renewal must take place
DAYSTILRENEW=1

# Admin email - who to alert on failure
ADMINEM=

# Email registered in the certificate
CERTEM="$ADMINEM"

# Let's Encrypt Executable
LEXEC=

# What operation to perform
OPERATION=

# Certificate to operate on
CERTIFICATE=

# Where the root of the site is
WEBROOT=

# Website domain
FQDN=

## -------- parse arguments

# Load global config file before loading arguments and custom configs
source "$CONFIGFILE"

while [[ -n "$@" ]]; do
	arg=$1 ; shift
	case "$arg" in
		-cert)
			CERTIFICATE=$1
			shift
			;;
		-config) # Override the config
			CONFIGFILE=$1
			shift
			;;
		*)
			faile "Unkown option $arg"
			;;
	esac
done

# Load new config file, does no unset global pieces implicitely
source "$CONFIGFILE"

[[ "$(testconfig)" != OK ]] && exit 1

## ++++++ Add main now +++++

if [[ -f "$CERTIFICATE" ]]; then
	CVALIDTIL=$(date -d "$(openssl x509 -in "$CERTIFICATE" -text -noout|grep "Not After"|sed -r 's/^[^:]+?:\s*//')" "+%s")
	TODAY=$(date -d "now" "+%s")

	DAYSLEFT=$(( ($CVALIDTIL - $TODAY)/86400 )) # VALIDTIL should be in the future
else
	DAYSLEFT=0
fi

if [[ "$DAYSLEFT" -lt "$DAYSTILRENEW" ]]; then
	# Try to renew now
	NONCE=$RANDOM
	WEBPATH=.well-known/acme-challenge
	CHALDIR="$WEBROOT/$WEBPATH"
	CHALURL="http://$FQDN/$WEBPATH/$NONCE"
	mkdir -p "$CHALDIR"
	touch "$CHALDIR/index.html" # allow no listing of dir
	echo "$FQDN" > "$CHALDIR/$NONCE"
	if wget -O /dev/null -q "$CHALURL"; then # make sure; if we cn't get it, Let's Encrypt certainly won't
		"$LEXEC" --renew-by-default -a webroot --webroot-path "$WEBROOT" --server "https://acme-v01.api.letsencrypt.org/directory" --email "$CERTEM" --agree-tos --agree-dev-preview -d "$FQDN" auth
	else
		echo "Could not renew certificate for $FQDN" | mail -s "Certificate renew fail: $FQDN" "$ADMINEM"
	fi
	# cleanup
	rm "$CHALDIR/$NONCE" # this *should* be safe at this point....
	rm "$CHALDIR/index.html"
	rmdir "$CHALDIR"
fi

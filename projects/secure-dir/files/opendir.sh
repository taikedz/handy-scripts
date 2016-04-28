#!/bin/bash


# Define a secure directory

SECDIR="$PWD/secdir.enc/$CUST"

LOADDIR=./

# =====
# Target dir - will be overridden by next options
OPEDIR="$(abspath "$LOADDIR/$CUST")"

# =====
# Load the mount configuration options
#% include files/load-mount-configs.sh

# ==== Override with command line options
#% # include files/swallow-options.source

debuge "Operating on $OPEDIR"


# =======================================
# Check that we are allowed to mount in current working directory

debuge "[[ -n ${CWDALLOWED+x} ]] && [[ ! $CWDALLOWED = yes ]]"
debuge "[[ "$(abspath "$LOADDIR")" =~ "$(abspath "./")" ]]"

if [[ -n "${CWDALLOWED+x}" ]] && [[ ! "$CWDALLOWED" = yes ]] && [[ ! "$ACTION" =~ $(echo "close|unmount") ]]; then
	if [[ "$(abspath "$LOADDIR")" =~ "$(abspath "./")" ]]; then # use grep comparison to prevent any directories under too
		faile "Cannot load under current working directory - configure the mount location home= in your secdir.enc/config file"
	fi
fi

# ================
# Do mount

if grep -E "^$CUST:" "$MOUNTFILE" -q; then
	faile "$CUST is already mounted at $(grep -E "^$CUST:" "$MOUNTFILE"|cut -d':' -f2)"
fi

infoe "Opening $CUST"
debuge "Making $OPEDIR"
mkdir -p "$OPEDIR" || faile "Cannot write to [$OPEDIR]"

debuge "Loading ... $SECDIR > $OPEDIR"
_open_crypt "$SECDIR" "$OPEDIR" || {
	rmdir "$OPEDIR" 2>/dev/null
	faile "Could not open [$CUST]"
}
echo "$CUST:$OPEDIR" >> "$MOUNTFILE"

#debuge "Creating softlinks"
#linkall "$@"

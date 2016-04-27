#!/bin/bash

# Opening a secure directory

SECDIR="$PWD/.enc/$CUST"

# =======================================
# Check that the current directory is a secdir directory

if [[ ! -d "$PWD/.enc" ]]; then
	faile "Current directory $PWD is not a valid secdir location."
fi


if [[ -z "$*" ]]; then
	faile "You must specify the name of a secure directory to load"
fi

# =====
# Load the mount configuration options
#% include files/load-mount-configs.sh

# =====
# Target dir - will be overridden by next options
OPEDIR="$(abspath "$LOADDIR/$CUST")"

debuge "Operating on $OPEDIR"

# =======================================
# Check that we are allowed to mount in current working directory

debuge "[[ -n ${CWDALLOWED+x} ]] && [[ ! $CWDALLOWED = yes ]]"
debuge "[[ "$(abspath "$LOADDIR")" =~ "$(abspath "$PWD")" ]]"

if [[ -n "${CWDALLOWED+x}" ]] && [[ ! "$CWDALLOWED" = yes ]] && [[ ! "$ACTION" =~ $(echo "close|unmount") ]]; then
	if [[ "$(abspath "$LOADDIR")" =~ "$(abspath "$PWD")" ]]; then # use grep comparison to prevent any directories under too
		faile "Cannot load under current working directory - use the '-to MOUNTPOINT' option"
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

debuge "Creating softlinks"
linkall "$@"

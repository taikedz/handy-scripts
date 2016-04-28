#!/bin/bash

#% include bashout askuser
. "$BBPATH/bashout.source"
. "$BBPATH/colours.source"
. "$BBPATH/askuser.source"

function qualdate {
	# somehow we need to ensure that the date from this function is universally accepted...
	# this function echoes SOURCE + ":" + INT + ":" = COMMENTS
	# where SOURCE identifies who set the date (localhost, or server name, or method)
	# and INT is the seconds since epoch
	# and COMMENTS is some human readable comments
	
	# check network; get date from server
	# TODO - FIXME implement
	
	# ----
	# if that fails, return date as per local clock
	echo "localhost:$(date "+%s"):as per $HOSTNAME"
}

function loadarchive {
	
	local STOREDIR=./
	local DESTDIR=./
	local ACTION=$1; shift
	local pACTIONS='(push|pull)'
	local ACCOUNTS=
	
	
	if [[ ! "$ACTION" =~ $pACTIONS ]]; then
		faile "Invalid action [$ACTION]"
	fi
	
	while [[ -n "$*" ]]; do
		local ARG=$1; shift
		debuge "Argument: [$ARG]"
		case "$ARG" in
			-s|--store)
				if [[ -d "$1/secdir.enc" ]]; then
					STOREDIR=$1; shift
				else
					faile "Not a valid store directory [$1]"
				fi
				;;
			-d|--destdir)
				if [[ -d "$1" ]]; then
					DESTDIR=$1; shift
				else
					faile "Not a valid destination directory [$1]"
				fi
				;;
			*)
				ACCOUNTS=("${ACCOUNTS[@]}" "$ARG")
				;;
		esac
	done

	debuge "DESTDIR: $DESTDIR // STOREDIR: $STOREDIR"
	
	for ACCOUNT in "${ACCOUNTS[@]}"; do
		if [[ -z "$ACCOUNT" ]]; then continue; fi

		if [[ "$ACTION" = push ]]; then
			if [[ ! -d "$STOREDIR/secdir.enc/$ACCOUNT" ]]; then
				warne "Skipping non-existent account [$ACCOUNT]"
				continue
			fi
			infoe "Uploading $ACCOUNT"
			echo "$(qualdate)" > "$STOREDIR/secdir.enc/$ACCOUNT/.tar-timestamp" || warne "Could not set date" # repeat this on every dir closure!
			debuge "qualified date is $(cat "$STOREDIR/secdir.enc/$ACCOUNT/.tar-timestamp")"
			tar cz  -C "$STOREDIR/secdir.enc/$ACCOUNT/" ./ | _cryptfilter encrypt "-" > "$DESTDIR/$ACCOUNT.tgz"
		else
			if [[ ! -f "$DESTDIR/$ACCOUNT.tgz" ]]; then
				warne "Skipping non-existent archive [$DESTDIR/$ACCOUNT.tgz]"
				continue
			fi
			infoe "Downloading $ACCOUNT"
			mkdir -p "$STOREDIR/secdir.enc/$ACCOUNT"
			if [[ ! -f "$STOREDIR/secdir.enc/$ACCOUNT/.tar-timestamp" ]] &&
				! uconfirm "$CYEL No ${CBLU}local${CYEL} timestamp file - are you sure you want to overwrite this directory?$CDEF"; then
				
				faile "Aborting download - no local timestamp"
			fi
			if ! (_cryptfilter decrypt "$DESTDIR/$ACCOUNT.tgz" | tar xz "./.tar-timestamp") && ! uconfirm "$CRED No ${CYEL}archive${CDEF} timestamp file - are you sure you want to import this archive?$CDEF"; then
				faile "Aborting download - no archive timestamp"
			fi
			local curtime="$(cat "$STOREDIR/secdir.enc/$ACCOUNT/.tar-timestamp")"
			local tartime="$(_cryptfilter decrypt "$DESTDIR/$ACCOUNT.tgz" | tar xzf ./.tar-timestamp)"
			local curtimet="$(echo "$curtime"|cut -d':' -f2)"
			local tartimet="$(echo "$tartime"|cut -d':' -f2)"
			debuge "Current directory time string=$curtime"
			debuge "Archive directory time string=$tartime"

			if (echo "$tartime"|grep -E '^localhost' -q); then
				uconfirm "The archive tar time was set from the host's $(echo "$tartime"|cut -d':' -f3) own clock - trust it?" || faile "Aborting - we do not trust tar timestamp"
			fi

			if [[ "$curtimet" -gt "$tartimet" ]]; then
				uconfirm "Current edit time $curtimet is later than archive time $tartimet - are you sure you want to ${CRED}squash your copy$CDEF?" || faile "Abort"
			fi

			_cryptfilter decrypt "$DESTDIR/$ACCOUNT.tgz" | tar xz -C "$STOREDIR/secdir.enc/$ACCOUNT/"
		fi
	done
	
}

### _cryptfilter Usage:bbuild
#
#	_cryptfilter MODE FILE [ OPTIONS ... ]
#
# just pases data through. Override this function to replace it with your own
#
# Read FILE, process the stream, write to stdout
#
# FILE must be a file, or "-" for stdin
#
# * MODE must be in the first position, any other arguments are optional
# * MODE must be either "encrypt" or "decrypt"
#
###/doc
function _cryptfilter {
	local mode=$1; shift
	local tfile=$1; shift
	if [[ "$mode" = encrypt ]]; then
		cat "$tfile"
	elif [[ "$mode" = decrypt ]]; then
		cat "$tfile"
	else # recommended: passthrough, but warn all the same
		warne "Bad mode [$mode] - passing through unchanged"
		cat "$tfile"
	fi
}

loadarchive "$@"

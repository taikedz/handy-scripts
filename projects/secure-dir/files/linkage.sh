#!/bin/bash

optpat="^--"

function linkall {
	while [[ -n "$@" ]]; do
		if [[ "$1" =~ $optpat ]]; then shift ; continue ; fi
		local TGT=$(abspath "$1") ; shift
		ln -s "$TGT" "$OPEDIR" && echo "$TGT" >> "$PWD/secdir.enc/${CUST}.links"
	done
}

function delinkall {
	if [[ ! -f "$PWD/secdir.enc/${CUST}.links" ]]; then return 0; fi
	cat "$PWD/secdir.enc/${CUST}.links" | while read lfile; do
		unlink "$lfile"
		sed "/$(echo "$lfile"|sed 's|/|\\/|g')/d" -i "$PWD/secdir.enc/${CUST}.links"
	done
	[[ $(wc -l "$PWD/secdir.enc/${CUST}.links") -lt 1 ]] && rm "$PWD/secdir.enc/${CUST}.links"
}



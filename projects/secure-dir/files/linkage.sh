#!/bin/bash

optpat="^--"

function linkall {
	while [[ -n "$@" ]]; do
		if [[ "$1" =~ $optpat ]]; then shift ; continue ; fi
		local TGT=$(abspath "$1") ; shift
		ln -s "$TGT" "$OPEDIR" && echo "$TGT" >> "$PWD/.enc/${CUST}.links"
	done
}

function delinkall {
	if [[ ! -f "$PWD/.enc/${CUST}.links" ]]; then return 0; fi
	cat "$PWD/.enc/${CUST}.links" | while read lfile; do
		unlink "$lfile"
		sed "/$(echo "$lfile"|sed 's|/|\\/|g')/d" -i "$PWD/.enc/${CUST}.links"
	done
	[[ $(wc -l "$PWD/.enc/${CUST}.links") -lt 1 ]] && rm "$PWD/.enc/${CUST}.links"
}



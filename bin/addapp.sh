#!/bin/bash

# ===============¬
# Define the directories to traverse for programs

progsources=(
	"/cygdrive/c/Program Files"
	"/cygdrive/c/Program Files (x86)"
)

# ================/

check_for() {
	[ -e "/usr/local/bin/$1" ]
	return $?
}

check_result() {
	local resultf="$1"; shift

	if [ -z "$resultf" ]; then
		return 1

	elif [ "$(echo "$resultf"|wc -l)" -gt 1 ]; then
		faile "Found more than one result:\n\n$resultf"
	fi
}

add_from() {
	local targetdir="$1"; shift
	local targetapp="$1"; shift
	local appname="$1"; shift

	check_for "$targetapp" && faile "We already have $targetapp"

	echoe "  Searching $targetdir ..."
	local resultf="$(search_in "$targetdir" "$targetapp")"

	check_result "$resultf" || return 1

	[ -z "$appname" ] && appname="$targetapp"

	ln -s "$resultf" "/usr/local/bin/$appname" && echoe ">> $resultf is now available as $appname <<"
}

search_in() {
	local targetdir="$1"; shift
	local targetapp="$1"; shift

	find "$targetdir" -name "$targetapp"
}

echoe() {
	echo -e "$*" >&2
}

faile() {
	echoe "$*"
	exit 1
}

add_app() {
	for sourcedir in "${progsources[@]}"; do
		add_from "$sourcedir" "$@" && return
	done
	
	faile "Could not find $targetapp"
}

search_app() {
	for sourcedir in "${progsources[@]}"; do
		search_in "$sourcedir" "*$1*" && return
	done
	
	faile "Could not find $targetapp"
}

main() {
	local action=add
	local cmds="^(find)$"

	if [[ "$1" =~ $cmds ]]; then
		action="$1"; shift
	fi

	[ -n "$1" ] || faile "Find a program file, or add a file EXENAME from Program Files to /usr/local/bin, optionally with a substitute name BINNAME.\n\nUsage:\n\n    addapp.sh [find] EXENAME [BINNAME]"

	case "$action" in
		find)
			search_app "$@"
			;;
		add)
			add_app "$@"
			;;
	esac
}

main "$@"


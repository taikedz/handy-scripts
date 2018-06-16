#!/bin/bash

## Scour the current directory for git repositories
## Report on the status
## If not "working tree clean" in `git status output`
##   then starts a new bash shell in that directory
##
## Once your are done in the repository, type
##
## exit 0 to continue to next repository
##
## exit 1 to stop processing repositories

set -e

# Rather than use bare binary, use all ASCII
#   for web and clipboard compatibility
c_nul="$(echo -e "\033[0m")"
c_red="$(echo -e "\033[31;1m")"
c_yel="$(echo -e "\033[33;1m")"

main() {
	if [[ "$*" =~ --help ]]; then
		egrep "^##" "$0"
		exit 0
	fi
	
	if [[ -n "${1:-}" ]]; then
		git-verify "$1"
	else
		parts=(:)
		while read target; do
			parts[${#parts[@]}]="$target"
		done < <(find . -name '.git')

		for target in "${parts[@]:1}"; do
			bash "$0" "$target" || die "$target"
		done

		echo "${c_yel}Processed"
		for x in "${parts[@]:1}"; do echo "  $x"; done
		echo "$c_nul"

	fi
}

git-status() { (
	cd "$1/.."
	echo "${c_yel}$(dirname "$1")${c_nul}"
	git status  | sed -r "s/^(\t.+)$/${c_red}\1${c_nul}/ ; s/^/\t/"
) ; }

is-clean() {
	if [[ ! "$*" =~ "working tree clean" ]]; then
		echo "$*"
		return 1
	fi
	return 0
}

git-verify() {
	if is-clean "$(git-status "$1")"; then
		return
	fi

	cd "$PWD/$1/.."
	bash
	cd -
}

error() {
	echo "${c_red}$*${c_nul}"
}

die() {
	error "FAIL: $*"
	exit 1
}

main "$@"

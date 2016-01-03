#!/bin/bash

# =============
# Simple function to check a list of variables, and name any that are empty
# causes script bail on error if "set -e" is set

function requirevars {
for x in $@; do
export emptyspace='^\s*$'
cat <<EOCHECK |bash
if [[ "\$$x" =~ \$emptyspace ]]; then
	echo "$x is not set"
	exit 1
else
	echo "$x=\$$x"
fi
EOCHECK
done
}

# that's all!

# ============= Tests ----------------------------------------
function testreqvars {
	export VARA=something
	export VARB=
	export VARC=whoops


	# This will be fine
	requirevars VARA VARB VARC

	echo "----------------"

	set -euo pipefail

	# this will bail current shell (not just subshell)
	requirevars VARA VARB VARC
}
[[ "$@" =~ test ]] && testreqvars

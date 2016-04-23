#!/bin/bash

### Push Master Usage:help
#
# The pushmaster command automatically switches to master, merges the changes of your branch, pushes it to the first defined push-remote, and returns you to your branch
#
###

function pushmaster {
	switchbranch master
	git merge "$CURBRANCH"
	local origin=$(git remote -v|head -n 1|grep '(push)'|egrep -o '^[a-zA-Z0-9]+')
	if [[ -n "$origin" ]] ; then
		git push $origin "$CURBRANCH"
	fi
	switchbranch "$CURBRANCH"
}

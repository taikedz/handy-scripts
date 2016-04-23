#!/bin/bash

### Push Master Usage:help
#
# The pushmaster command automatically switches to master, merges the changes of your branch, pushes it to the first defined push-remote, and returns you to your branch
#
###

function pushmaster {
	local backbranch=$CURBRANCH
	switchbranch master
	git merge "$backbranch"
	local origin=$(git remote -v|head -n 1|grep '(push)'|egrep -o '^[a-zA-Z0-9]+')
	if [[ -n "$origin" ]] ; then
		infoe "Pushing your changes on $backbranch to $origin"
		git push $origin "$backbranch"
		infoe "Pushing master to $origin"
		git push $origin master
	fi
	switchbranch "$backbranch"
}

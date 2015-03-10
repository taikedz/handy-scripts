#!/bin/bash

FTOFIX=/usr/share/xfce4/helpers/xfce4-firefox.desktop
FIXNAME="helpuse-F001 FFFOX Launcher Fixer"

doalert() {
	zenity --title="$FIXNAME" "$@"
}


if [[ $UID != 0 ]]; then
	gksudo $0
	exit
fi

if [[ ! -f $FTOFIX ]]; then
	doalert --error --text="Couldn't find the configuration file: $FTOFIX"
	exit 1
fi

checkfile() {
	echo $(grep '-remote "openURL' $FTOFIX | wc -l )
}

if [[ $(checkfile) = 0 ]]; then
	doalert --info --text="Cannot find the settings to change in $FTOFIX"
	exit 2
fi

# Checks complete - try to make the change

sed -r -e 's/^(X-XFCE-Commands(WithParameter)?=)%B -remote "openURL\(.+?\)";(.+)$/\1\3/' -i $FTOFIX

if [[ $(checkfile) != 0 ]]; then
	doalert --error --text="Modification failed : $(checkfile)."
	exit 3
else
	doalert --info --text="Fix successfully applied."
fi

#	##X-XFCE-Commands=%B -remote "openURL(about:blank,new-window)";%B;
#	##X-XFCE-CommandsWithParameter=%B -remote "openURL(%s)";%B "%s";

# Gets replaced with

#	X-XFCE-Commands=%B;
#	X-XFCE-CommandsWithParameter=%B "%s";


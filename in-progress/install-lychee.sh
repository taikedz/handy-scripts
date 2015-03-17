#!/bin/bash

# ===================================================================================
# Simple installer for Lychee Git Project
# (C) 2015 Tai Kedzierski
#
# This is Free Software, provided to you under the terms of the GNU LGPL v3 license
#
# You must retain this copyright notice
# If you incorporate this code into the source of a file  of your project
#   you must make that code available under LGPLv3 too
# If you make changes to this code, you must share those changes under the same
#   license
# You may include this code in a file separate from your source code
#   whilst not requiring you to include the source code of your application
#
# For more details, please refer to the Less GNU General Public License version 3
#
# This software carries no warranty as far as permissible by law, not even for
# suitability for any purpose, and is provided AS-IS
#
# You remain responsible for reviewing the code and
# BACKING UP ANY IMPORTANT DATA before executing it.
#
#
#  ===================================================================================

[[ $UID = 0 ]] || { echo "You are not root." && exit; } # be root

# ================ Useful tools

function matchinput() { # FIXME NEEDS VERIFICATION
	# create a generalized function to catch entry errors ...
	# matchinput PROMPT PATTERN DEFAULTVALUE
	local MYVAR
	while [[ 'x' = 'x' ]]; do
		read -p "$1 [$3]: " MYVAR
		if [[ $(echo "$MYVAR" | grep -E "^$2\$" | wc -l) != 0 ]]; then
			echo $MYVAR
			return 0
		elif [[ "x$MYVAR" = 'x' ]]; then
			echo $3
			return 1
		fi
		# else continue
	done
}

# ================= Preamble

cat <<EOMESSAGE
This script will install the Lychee self-hosted online photo manager for websites.

You will be asked about configuring MariaDB if not yet installed, and for the database details to use to connect.

Currently installs to /var/www/html/lychee or /var/www/lychee as appropriate.

Currently supports Debian + Ubuntu only

TODO:

* Add support for CentOS
* Add support for Apache Aliases
* Add support for VirtualHosts
EOMESSAGE

# ================== Install basics

DEB_INSTALLTHESE="git apache2 php5-mysql mariadb-server php5-gd libgd2-xpm-dev libpcrecpp0 libxpm4 libapache2-mod-php5"
RPM_INSTALLTHESE="git httpd php5 php5-mysql" # what other packages? Need names!

read -p "This will install git, apache2 and PHP5 from the repositories, then pull Lychee from GitHub. Would you like to proceed? y/n" MYRES;
[[ "x$MYRES" != 'x' ]] || exit 4

[[ -f /usr/bin/apt-get ]] && apt-get update && apt-get install $DEB_INSTALLTHESE --assume-yes || exit 1

# TODO - CentOS/Fedora : Not yet supported
#[[ -f /usr/bin/yum ]] && yum install $RPM_INSTALLTHESE

# find www/ directory. is there an env for this?
cd /var/www/html || cd /var/www || { echo "Could not find /var/www" && exit 2; }

git clone https://github.com/electerious/lychee.git || exit 3

chown -R www-data:www-data lychee
cd lychee
tar -czf lychee-stash.tgz CONTRIBUTING.md Dockerfile README.md src/ && rm -rf CONTRIBUTING.md Dockerfile README.md src/

# =============== Get the database details

echo "Please enter the database details for the lychee application."
echo "Please only use alphabetical and numerical characters for the database and user names."
echo "Default values appear in brackets, simply press enter to accept them."

VALIDPAT='[a-zA-Z0-9_-]+'
LYDB=$( matchinput "Lychee database" "$VALIDPAT" "lychee" )
LYUSE=$( matchinput "User for lychee database" "$VALIDPAT" "lychee-user" )
LYPWD=$( matchinput "Password for $LYSUE" "\S*" "lychee-dbpass" )

cat <<EODATA
Details are:

Databse name        : $LYDB
User name           : $LYUSE
Database password   : $LYPASS

Connecting to the MySQL database; please ensure you have the database root password ready...

EODATA


mysql -u root -p <<EOSQL
create user '$LYUSE'@'localhost';
grant all privileges on $LYDB.* to '$LYUSE'@'localhost';
EOSQL

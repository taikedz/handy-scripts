#!/bin/bash

function insert {
portserv="$1"

cat <<EOSQL | mysql -u "$DBUSER" -p"$DBPASS" "$DBNAME"
insert into Connections(id,content) values (MD5("$portserv"),"$(date "+%F-%T")");
EOSQL
}


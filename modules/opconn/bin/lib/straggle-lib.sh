#!/bin/bash

function stg_insert {
portserv="$1"
psmd5=$( stg_md5 "$portserv" )

cat <<EOSQL | mysql -u "$DBUSER" -p"$DBPASS" "$DBNAME"
insert into Connections(id,content) values ("$psmd5","$(date "+%F-%T")");
EOSQL
}

function stg_md5 {
echo -n "$1"|md5sum|sed -r 's/\s*-\s*$//'
}

function stg_getcontent {
	cat <<EOSQL|mysql -N -u "$DBUSER" -p"$DBPASS" "$DBNAME"
select Content from Connections where id='$1';
EOSQL
}
function stg_getnotes {
	cat <<EOSQL|mysql -N -u "$DBUSER" -p"$DBPASS" "$DBNAME"
select Notes from Connections where id='$1';
EOSQL
}

function stg_rm {
	cat <<EOSQL|mysql -u "$DBUSER" -p"$DBPASS" "$DBNAME"
delete from Connections where id='$1' limit 1;
EOSQL
}

function stg_setcontent {
	md5id=$1
	shift
	newcontent=$@
	cat <<EOSQL|mysql -u "$DBUSER" -p"$DBPASS" "$DBNAME"
update Connections set Content='$newcontent' where id='$md5id' limit 1;
EOSQL
}

function stg_setnotes {
	md5id=$1
	shift
	newcontent=$@
	cat <<EOSQL|mysql -u "$DBUSER" -p"$DBPASS" "$DBNAME"
update Connections set Notes='$newcontent' where id='$md5id' limit 1;
EOSQL
}


function stg_clearout {
	cat <<EOSQL|mysql -u "$DBUSER" -p"$DBPASS" "$DBNAME"
delete from Connections where Notes is null;
EOSQL
}

function stg_drop {
        cat <<EOSQL|mysql -u "$DBUSER" -p"$DBPASS" "$DBNAME"
delete from Connections where Notes is not null;
EOSQL
}

# Debug items
function stg_show {
	cat <<EOSQL|mysql -u "$DBUSER" -p"$DBPASS" "$DBNAME"
select * from Connections where Notes is not null;
EOSQL
}

function stg_show_all {
	cat <<EOSQL|mysql -u "$DBUSER" -p"$DBPASS" "$DBNAME"
select * from Connections;
EOSQL
}


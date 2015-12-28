#!/usr/bin/mysql

create table Connections (
    id char(32) primary key,
    Content varchar(128),
    Notes varchar(128)
);


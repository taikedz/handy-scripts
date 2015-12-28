#!/usr/bin/mysql

create database stragglers;
create user 'straggler'@'localhost' identified by 'raggle';
grant all privileges on stragglers.* to 'straggler'@'localhost';

use stragglers;
create table Connections (
    id char(32) primary key,
    Content varchar(128),
    Notes varchar(128)
);


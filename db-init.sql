drop table if exists people cascade;
create table people (
	id numeric(5) constraint pk_ppl primary key,
	name varchar(100)
);
drop table if exists education cascade;
create table education (

);
drop table if exists contacts cascade;
create table contacts (
	id numeric(5) constraint fk_c_ppl references people(id) not null,
	linkedin varchar(250),
	github varchar(250),
	email varchar(250)
);
drop table if exists jobs cascade;
create table jobs (

);
drop table if exists companies cascade;
create table companies (

);
drop table if exists roles cascade;
create table roles (

);
insert into people (id, name) values (1, 'Pavel Sankin');
insert into people (id, name) values (2, 'Andrei Daletski');
insert into contacts (id, linkedin, github, email) values (1, 'https://www.linkedin.com/in/pavel-sankin-bbaa371bb/', 'github.com/Pankin610', 'pavelsankin610@gmail.com');
insert into contacts (id, linkedin, github) values (2, 'https://www.linkedin.com/in/andrei-daletski-490b29205/', 'github.com/DANDROZAVR');

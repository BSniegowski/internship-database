drop table if exists people cascade;
create table people (
	id numeric(5) constraint pk_ppl primary key,
	name varchar(100)
);
drop table if exists companies cascade;
create table companies (
	id numeric(5) constraint pk_com primary key,
	company_name varchar(200) not null unique,
	main_country varchar(100),
	annual_revenue numeric(9, 4)
);

drop table if exists majors cascade;--specjalnosci/kierunki studiow
create table majors (
    id numeric(5) constraint pk_maj primary key,
    name varchar(100),
    university varchar(250)
);
drop table if exists education cascade;
create table education (
    student_id numeric(5) constraint fk_e_ppl references people(id),
    major_id numeric(5) constraint fk_e_maj references majors(id),
    primary key (student_id,major_id),
    degree varchar(100),
    graduated boolean,--false znaczy, ze end_of_studying jest oczekiwana wartoscia
    start_of_studying date not null,
    end_of_studying date--null oznacza, ze nie wiemy
);

drop table if exists contacts cascade;
create table contacts (
	id numeric(5) constraint fk_c_ppl references people(id),
	linkedin varchar(250),
	github varchar(250),
	email varchar(250)
);

drop table if exists roles cascade;
create table roles (
	role_id numeric(5) constraint pk_r primary key,
	role_name varchar(100),
	salary numeric(9),
	hours numeric(3),
	company_id numeric(5) constraint fk_r_com references companies(id)
);

drop table if exists work_place cascade;
create table work_place (
    id numeric(5) constraint pk_wp primary key,
    country varchar(100) not null,
    city varchar(100) not null,
    street varchar(250),
    street_number numeric(5)
);

drop table if exists jobs cascade;
create table jobs (
	company_id numeric(5) constraint fk_j_com references companies(id),
	role_id numeric(5) constraint fk_j_r references roles(role_id),
	employee numeric(5) constraint fk_j_ppl references people(id),
    location_id numeric(5) constraint fk_j_wp references work_place(id),
	job_id numeric(5) constraint pk_j primary key,
	starting_date date not null,
	ending_date date default null
);

drop table if exists recommendations cascade;
create table recommendations (
    recommender numeric(5) constraint fk_rec_ppl references people(id),
    recommended numeric(5) constraint fk_rec_ppl_2 references people(id),
    job_id numeric(5) constraint fk_rec_j references jobs(job_id),
    primary key (job_id,recommender)
);

insert into people (id, name) values (1, 'Pavel Sankin');
insert into people (id, name) values (2, 'Andrei Daletski');
insert into contacts (id, linkedin, github, email) values (1, 'https://www.linkedin.com/in/pavel-sankin-bbaa371bb/', 'github.com/Pankin610', 'pavelsankin610@gmail.com');
insert into contacts (id, linkedin, github) values (2, 'https://www.linkedin.com/in/andrei-daletski-490b29205/', 'github.com/DANDROZAVR');
drop table if exists people cascade;
drop table if exists residence cascade;
drop table if exists companies cascade;
drop table if exists universities cascade;
drop table if exists fields_of_study cascade;
drop table if exists majors cascade;
drop table if exists education cascade;
drop table if exists contacts cascade;
drop table if exists roles cascade;
drop table if exists work_place cascade;
drop table if exists jobs cascade;
drop table if exists recommendations cascade;
drop table if exists promotions cascade;

create table people (
	id numeric(5) constraint pk_ppl primary key,
	name varchar(100) NOT NULL
);
create table residence (
    id numeric(5) constraint fk_res_ppl references people(id),
    city varchar(100) NOT NULL,
    street varchar(100),
    dwelling_number numeric(5),
    flat_number numeric(5),
    CHECK ( street IS NOT NULL OR dwelling_number IS NOT NULL )
);
create table companies (
	id numeric(5) constraint pk_com primary key,
	name varchar(100) NOT NULL,
	main_country varchar(100) NOT NULL,
	annual_revenue numeric(9, 4)
);

create table universities (
    id numeric(5) constraint pk_uni primary key,
    name varchar(100) NOT NULL,
    city varchar(100) NOT NULL
);
create table fields_of_study ( --possible types
    id numeric(3) constraint pk_fie primary key,
    name varchar(100) NOT NULL
);
create table majors ( -- particular field at given university
    id numeric(5) constraint pk_maj primary key,
    university_id numeric(5) constraint fk_maj_uni references universities(id),
    field_id numeric(3) constraint fk_maj_fie references fields_of_study(id)
    -- should (university_id,field_id) be unique?
    -- if not, add info varchar(100) for example: this one is at faculty of ... / or this one is more practical ...
);

create table education (
    student_id numeric(5) constraint fk_e_ppl references people(id),
    major_id numeric(5) constraint fk_e_maj references majors(id),
    primary key (student_id,major_id),
    degree varchar(100),
    start_of_studying date NOT NULL,
    end_of_studying date,--null oznacza, ze nie wiemy
    CHECK ( degree = 'none' OR degree = 'bachelor' OR degree = 'master' OR degree = 'PhD'),
    CHECK ( end_of_studying IS NULL OR end_of_studying > start_of_studying )
);

create table contacts (
	id numeric(5) constraint fk_c_ppl references people(id),
	linkedin varchar(250),
	github varchar(250),
	email varchar(250),
	phone_number varchar(9),
    CHECK ( linkedin IS NOT NULL OR github IS NOT NULL OR email IS NOT NULL OR phone_number IS NOT NULL ),
    CHECK ( email IS NULL OR email ~ '^[^@]+@[^@\.]+\.[^@\.][^@]*$'),
    CHECK ( phone_number IS NULL OR length(phone_number) = 9)
    --check if phone number unique but allow multiple nulls ?
);

create table roles (
    role_id numeric(5) constraint pk_r primary key,
    role_name varchar(100),
    salary_range_min numeric(9),
    salary_range_max numeric(9),
    hours numeric(3),
    company_id numeric(5) constraint fk_r_com references companies(id)
);

create table work_place
(
    id            numeric(5) constraint pk_wp primary key,
    city          varchar(100) not null,
    street        varchar(100),
    street_number numeric(5),
    opening_hours time,
    closing_hours time
);
create table jobs (
-- isn't company_id determined by role_id (?)
	--company_id numeric(5) constraint fk_j_com references companies(id),
	role_id numeric(5) constraint fk_j_r references roles(role_id),
	employee numeric(5) constraint fk_j_ppl references people(id),
    location_id numeric(5) constraint fk_j_wp references work_place(id),
	job_id numeric(5) constraint pk_j primary key,
	starting_date date not null,
	ending_date date,
	salary numeric(9),
    CHECK ( ending_date IS NULL OR ending_date > starting_date)
--     salary >= salary_range_min
--     salary <= salary_range_max
);

create table recommendations (
-- fix:
    recommender numeric(5) constraint fk_rec_ppl references people(id),
    recommended numeric(5) constraint fk_rec_ppl_2 references people(id),
    role_id numeric(5) constraint fk_rec_r references roles(role_id),
    time_of_recommendation date NOT NULL,
    primary key (recommender,recommended,role_id,time_of_recommendation),
    CHECK ( recommender != recommended )
    -- check if not already employed on role_id
    -- check if recommender has ever worked in company

);
create table promotions ( -- some extra money for recommender if recommended is employed/ (alternatively works for example for 2 years)
    id numeric(5) constraint pk_pro primary key,
    role_id numeric(5) constraint fk_pro_r references roles(role_id),
    start_of_promotion date NOT NULL,
    end_of_promotion date NOT NULL,
    premium numeric(9) NOT NULL,
    CHECK ( end_of_promotion > start_of_promotion ),
    CHECK ( premium > 0 )
);

insert into people (id, name) values (1, 'Pavel Sankin');
insert into people (id, name) values (2, 'Andrei Daletski');
insert into contacts (id, linkedin, github, email) values (1, 'https://www.linkedin.com/in/pavel-sankin-bbaa371bb/', 'github.com/Pankin610', 'pavelsankin610@gmail.com');
insert into contacts (id, linkedin, github) values (2, 'https://www.linkedin.com/in/andrei-daletski-490b29205/', 'github.com/DANDROZAVR');
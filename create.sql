drop table if exists people cascade;
drop table if exists residences cascade;
drop table if exists companies cascade;
drop table if exists universities cascade;
drop table if exists fields_of_study cascade;
drop table if exists majors cascade;
drop table if exists educations cascade;
drop table if exists contacts cascade;
drop table if exists roles cascade;
drop table if exists work_places cascade;
drop table if exists jobs cascade;
drop table if exists recommendations cascade;
drop table if exists promotions cascade;
drop table if exists employee_search cascade;

create table people (
	id numeric(5) constraint pk_ppl primary key,
	name varchar(100) NOT NULL
);

create table contacts (
	id numeric(5) constraint fk_c_ppl references people(id),
	linkedin varchar(250) unique,
	github varchar(250) unique,
	email varchar(250) unique,
    CHECK ( linkedin IS NOT NULL OR github IS NOT NULL OR email IS NOT NULL),
    CHECK ( email IS NULL OR email ~ '^[^@]+@[^@\.]+\.[^@\.][^@]*$')
);

create table residences (
    id numeric(5) constraint fk_res_ppl references people(id),
    city varchar(100) NOT NULL,
    street varchar(100),
    dwelling_number numeric(5),
    flat_number numeric(5),
    CHECK ( street IS NOT NULL OR dwelling_number IS NOT NULL )
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
    field_id numeric(3) constraint fk_maj_fie references fields_of_study(id),
    unique (university_id,field_id)
);

create table educations (
    student_id numeric(5) constraint fk_e_ppl references people(id),
    major_id numeric(5) constraint fk_e_maj references majors(id),
    primary key (student_id,major_id),
    degree varchar(8),
    start_of_studying date NOT NULL,
    end_of_studying date,
    CHECK ( degree = 'none' OR degree = 'bachelor' OR degree = 'master' OR degree = 'PhD'),
    CHECK ( end_of_studying IS NULL OR end_of_studying > start_of_studying )
);

create table companies (
	id numeric(5) constraint pk_com primary key,
	company_name varchar(200) not null unique,
	main_country varchar(100),
	annual_revenue numeric(9, 4)
);

create table roles (
    role_id numeric(5) constraint pk_r primary key,
    role_name varchar(100),
    salary_range_min numeric(9),
    salary_range_max numeric(9),
    hours numeric(2), --weekly ?
    company_id numeric(5) constraint fk_r_com references companies(id),
    CHECK ( salary_range_max >= salary_range_min )
);

create table work_places (
    id            numeric(5) constraint pk_wp primary key,
    city          varchar(100) not null,
    street        varchar(100),
    street_number numeric(5),
    opening_hours time,
    closing_hours time
);

create or replace function isInRange(salary numeric(9), id numeric(5))
	returns bool as
$$
begin
	return
	    salary >= (select salary_range_min from roles where role_id = id)
	    AND salary <= (select salary_range_max from roles where role_id = id);
end;
$$
language plpgsql;

create table jobs (
    job_id numeric(5) constraint pk_j primary key,
	role_id numeric(5) constraint fk_j_r references roles(role_id),
	employee numeric(5) constraint fk_j_ppl references people(id),
    location_id numeric(5) constraint fk_j_wp references work_places(id),
	starting_date date not null,
	unique (role_id,employee,starting_date),

	ending_date date,
	salary numeric(9),

    CHECK ( ending_date > starting_date),
    CHECK ( isInRange(salary,role_id) )
);
--TEST
-- insert into work_places (id, city) values (1,'Krakow');
-- insert into people (id, name) values (1,'Mike');
-- insert into companies (id, company_name) values (1,'example company');
-- insert into roles (role_id, role_name, salary_range_min, salary_range_max, hours, company_id) values (1,'java dev',5000,6000,60,1);
-- insert into jobs (role_id, employee, location_id, job_id, starting_date, ending_date, salary) values (1,1,1,1,now(),null,7000);

create or replace function notEmployedThen(time_of_rec date, recommended numeric(5), role numeric(5))
	returns bool as
$$
begin
	return
        0 = (
            select count(*)
            from jobs
            where
                  employee = recommended
              AND starting_date < time_of_rec
              AND ending_date > time_of_rec
              AND role_id = role
            );
end;
$$
language plpgsql;

create or replace function companyOfRole(role numeric(5))
	returns numeric(5) as
$$
begin
	return
        (select company_id
        from roles
        where role_id = role
        );
end;
$$
language plpgsql;

create or replace function employedThen(time_of_rec date, recommender numeric(5), role numeric(5))
	returns bool as
$$
begin
	return
        0 < (
            select count(*)
            from jobs
            where
                  employee = recommender
              AND starting_date <= time_of_rec
              AND ending_date >= time_of_rec
              AND companyOfRole(role) = companyOfRole(role_id)
                --recommender works at company of role they're recommending to recommended
            );
end;
$$
language plpgsql;

create table recommendations (
    recommender numeric(5) constraint fk_rec_ppl references people(id),
    recommended numeric(5) constraint fk_rec_ppl_2 references people(id),
    role_id numeric(5) constraint fk_rec_r references roles(role_id),
    time_of_recommendation date NOT NULL,
    unique (recommender,recommended,role_id,time_of_recommendation),
    CHECK ( recommender != recommended ),

    CHECK ( notEmployedThen(time_of_recommendation,recommended,role_id)),
    CHECK ( employedThen(time_of_recommendation,recommender,role_id) )
        --need role_id to determine if recommender worked in company of role_id

);
create table employee_search ( -- some extra money for recommender if recommended is employed
    id numeric(5) constraint pk_emp primary key,
    company_id numeric(5) constraint fk_emp_r references companies(id),
    start_of_search date NOT NULL,
    end_of_search date NOT NULL,
    premium numeric(9)
    CHECK ( end_of_search > start_of_search ),
    CHECK ( premium > 0 )
);
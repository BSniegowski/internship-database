drop table if exists cities cascade;
drop table if exists people cascade;
drop table if exists residences cascade;
drop table if exists companies cascade;
drop table if exists universities cascade;
drop table if exists fields_of_study cascade;
drop table if exists majors cascade;
drop table if exists educations cascade;
drop table if exists contacts cascade;
drop table if exists positions cascade;
drop table if exists roles cascade;
drop table if exists work_places cascade;
drop table if exists jobs cascade;
drop table if exists recommendations cascade;
drop table if exists employee_search cascade;


create table cities (
    id integer constraint pk_cit primary key,
    name varchar(100) NOT NULL
);

create table people (
	id integer constraint pk_ppl primary key,
	name varchar(100) NOT NULL
);

create table contacts (
	id integer constraint fk_c_ppl references people(id),
	linkedin varchar(250) unique,
	github varchar(250) unique,
	email varchar(250) unique,
    CHECK ( linkedin IS NOT NULL OR github IS NOT NULL OR email IS NOT NULL),
    CHECK ( email IS NULL OR email ~ '^[^@]+@[^@\.]+\.[^@\.][^@]*$')
);

create table residences (
    id integer constraint fk_res_ppl references people(id),
    city_id integer constraint fk_res_cit references cities(id),
    street varchar(100),
    dwelling_number int2 NOT NULL,
    flat_number int2
);

create table universities (
    id integer constraint pk_uni primary key,
    name varchar(100) NOT NULL,
    city_id integer constraint fk_uni_cit references cities(id)
);

create table fields_of_study ( --possible types
    id integer constraint pk_fie primary key,
    name varchar(100) NOT NULL
);

create table majors ( -- particular field at given university
    id integer constraint pk_maj primary key,
    university_id integer constraint fk_maj_uni references universities(id),
    field_id integer constraint fk_maj_fie references fields_of_study(id),
    unique (university_id,field_id)
);

create table educations (
    student_id integer constraint fk_e_ppl references people(id),
    major_id integer constraint fk_e_maj references majors(id),
    primary key (student_id,major_id),
    degree varchar(8),
    start_of_studying date NOT NULL,
    end_of_studying date,
    CHECK ( degree = 'none' OR degree = 'bachelor' OR degree = 'master' OR degree = 'PhD'),
    CHECK ( end_of_studying > start_of_studying )
);

create table companies (
	id integer constraint pk_com primary key,
	company_name varchar(200) not null unique,
	headquarters integer constraint fk_com_cit references cities(id),
	annual_revenue numeric(9,2)
);

create table positions (
    id integer constraint pk_pos primary key,
    role_name varchar(100)
);

create table roles (
    role_id integer constraint pk_r primary key,
    salary_range_min numeric(9,2),
    salary_range_max numeric(9,2),
    hours int2 NOT NULL,
    company_id integer constraint fk_r_com references companies(id),
    position_id integer constraint fk_r_pos references positions(id),
    CHECK ( salary_range_max >= salary_range_min ),
    CHECK ( hours > 0 AND hours <= 80 )
);

create table work_places (
    id integer constraint pk_wp primary key,
    city_id integer constraint fk_wp_cit references cities(id),
    company_id integer constraint fk_wp_com references companies(id),
    street varchar(100),
    street_number int2,
    opening_hours time,
    closing_hours time
);

create or replace function isInRange(salary numeric(9,2), id integer)
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
    job_id integer constraint pk_j primary key,
	role_id integer constraint fk_j_r references roles(role_id),
	employee integer constraint fk_j_ppl references people(id),
    location_id integer constraint fk_j_wp references work_places(id),
	starting_date date not null,
	unique (role_id,employee,starting_date),

	ending_date date,
	salary numeric(9,2),

    CHECK ( ending_date > starting_date),
    CHECK ( isInRange(salary,role_id) )
);

create or replace function notEmployedThen(time_of_rec date, recommended integer, role integer)
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

create or replace function companyOfRole(role integer)
	returns integer as
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

create or replace function employedThen(time_of_rec date, recommender integer, role integer)
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
            );
end;
$$
language plpgsql;

create table recommendations (
    recommender integer constraint fk_rec_ppl references people(id),
    recommended integer constraint fk_rec_ppl_2 references people(id),
    role_id integer constraint fk_rec_r references roles(role_id),
    time_of_recommendation date NOT NULL,
    unique (recommender,recommended,role_id,time_of_recommendation),
    CHECK ( recommender != recommended ),

    CHECK ( notEmployedThen(time_of_recommendation,recommended,role_id)),
    CHECK ( employedThen(time_of_recommendation,recommender,role_id) )

);
create table employee_search (
    id integer constraint pk_emp primary key,
    role_id integer constraint fk_emp_r references roles(role_id),
    start_of_search date NOT NULL,
    end_of_search date NOT NULL,
    premium numeric(9,2)
    CHECK ( end_of_search >= start_of_search ),
    CHECK ( premium > 0 )
);
drop table if exists cities cascade;
drop table if exists people cascade;
drop table if exists residences cascade;
drop table if exists historical_residences cascade;
drop table if exists companies cascade;
drop table if exists universities cascade;
drop table if exists fields_of_study cascade;
drop table if exists majors cascade;
drop table if exists educations cascade;
drop table if exists contacts cascade;
drop table if exists positions cascade;
drop table if exists roles cascade;
drop table if exists work_places cascade;
drop table if exists historical_work_places cascade;
drop table if exists jobs cascade;
drop table if exists historical_salaries cascade;
drop table if exists recommendations cascade;
drop table if exists employee_search cascade;
drop table if exists open_close_hours cascade;


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
	linkedin varchar(100) unique,
	github varchar(100) unique,
	email varchar(100) unique,
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

create table historical_residences (
    id integer references people(id),
    city_id integer references cities(id),
    street varchar(100),
    dwelling_number int2 NOT NULL,
    flat_number int2,
    lived_until date
);

create or replace function alterResidences() returns trigger AS $alterResidences$
begin
  insert into historical_residences values (old.id,old.city_id,old.street,old.dwelling_number,old.flat_number,now());
  return new;
end;
$alterResidences$ LANGUAGE plpgsql;

create trigger alterResidences before update on residences
FOR EACH ROW EXECUTE PROCEDURE alterResidences();

-- insert into people values (1,'A B');
-- insert into cities values (1,'New City');
-- insert into residences values (1,1,'A',1,null);
-- update residences
-- set flat_number = 1
-- where dwelling_number = 1;

create table universities (
    id integer constraint pk_uni primary key,
    name varchar(100) NOT NULL,
    city_id integer constraint fk_uni_cit references cities(id)
);

create table fields_of_study (
    id integer constraint pk_fie primary key,
    name varchar(100) NOT NULL
);

create table majors (
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
	company_name varchar(100) not null unique,
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

create table work_places (
    id integer constraint pk_wp primary key,
    city_id integer constraint fk_wp_cit references cities(id),
    company_id integer constraint fk_wp_com references companies(id),
    street varchar(100),
    street_number int2
);


create table open_close_hours (
    location_id integer constraint fk_och_wp references work_places,
    opening_hours_Mon time,
    opening_hours_Tue time,
    opening_hours_Wen time,
    opening_hours_Thr time,
    opening_hours_Fri time,
    opening_hours_Sat time,
    opening_hours_Sun time,
    closing_hours_Mon time,
    closing_hours_Tue time,
    closing_hours_Wen time,
    closing_hours_Thr time,
    closing_hours_Fri time,
    closing_hours_Sat time,
    closing_hours_Sun time
);

create or replace function companyOfWorkPlace(place integer)
	returns integer as
$$
begin
	return
        (select company_id
        from work_places
        where id = place
        );
end;
$$
language plpgsql;

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

create or replace function oneCompanyOneJob(employee_new integer,company_id_new integer,start_of_new_job date, end_of_new_job date)
    returns bool as
$$
begin
    return
        0 = (
            select count(*)
            from jobs x
            where
                  x.employee = employee_new
                AND companyOfRole(x.role_id) = company_id_new
                AND x.starting_date < end_of_new_job
                AND x.ending_date > start_of_new_job
            );
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
	salary numeric(9,2) not null,

    CHECK ( ending_date > starting_date),
    CHECK ( isInRange(salary,role_id) ),
    CHECK ( oneCompanyOneJob(employee,companyOfRole(role_id),starting_date,ending_date) ),
    CHECK ( companyOfRole(role_id) = companyOfWorkPlace(location_id) )
);

create table historical_work_places (
    job_id integer references jobs(job_id),
    place_id integer references work_places(id),
    worked_here_till date
);
create or replace function alter_place_of_job() returns trigger as $alter_place_of_job$
begin
  insert into historical_work_places values (old.job_id,old.location_id,now());
  return new;
end;
$alter_place_of_job$ LANGUAGE plpgsql;

create trigger alter_place_of_job$ before update on jobs
FOR EACH ROW EXECUTE PROCEDURE alter_place_of_job();

create or replace function job_start(id integer)
    returns date as
$$
begin
	return
        (select starting_date
        from jobs
        where job_id = id);
end;
$$
language plpgsql;

create or replace function job_end(id integer)
    returns date as
$$
begin
	return
        (select ending_date
        from jobs
        where job_id = id);
end;
$$
language plpgsql;

create table historical_salaries (
    job_id integer constraint fk_hs_j references jobs(job_id),
    salary numeric(9,2),
    until date not null,
    CHECK ( until >= job_start(job_id)),
    CHECK ( until <= job_end(job_id))
);

create or replace function alterSalaries() returns trigger AS $alterSalaries$
begin
  insert into historical_salaries values (old.job_id,old.salary,now());
  return new;
end;
$alterSalaries$ LANGUAGE plpgsql;

create trigger alterSalaries before update on jobs
FOR EACH ROW EXECUTE PROCEDURE alterSalaries();

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
    CHECK ( end_of_search >= start_of_search )
);
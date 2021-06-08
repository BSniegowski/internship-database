drop table if exists cities cascade;
drop table if exists people cascade;
drop table if exists residences cascade;
drop table if exists historical_residences cascade;
drop table if exists companies cascade;
drop table if exists universities cascade;
drop table if exists fields_of_study cascade;
drop table if exists majors cascade;
drop table if exists educations cascade;
drop table if exists emails cascade;
drop table if exists positions cascade;
drop table if exists roles cascade;
drop table if exists work_places cascade;
drop table if exists historical_work_places cascade;
drop table if exists jobs cascade;
drop table if exists historical_salaries cascade;
drop table if exists recommendations cascade;
drop table if exists job_offers cascade;
drop table if exists open_close_hours cascade;


create table cities (
    id integer constraint pk_cit primary key,
    name varchar(100) NOT NULL
);

create or replace function delFromCities() returns trigger AS $delFromCities$
begin
  delete from companies where companies.headquarters = old.id;
  delete from residences where residences.city_id = old.id;
  delete from historical_residences where historical_residences.city_id = old.id;
  delete from work_places where work_places.city_id = old.id;
  return old;
end;
$delFromCities$ LANGUAGE plpgsql;

create trigger delFromCities before delete on cities
FOR EACH ROW EXECUTE PROCEDURE delFromCities();

create table people (
	id integer constraint pk_ppl primary key,
	name varchar(100) NOT NULL
);

create or replace function delFromPeople() returns trigger AS $delFromPeople$
begin
  delete from jobs where employee = old.id;
  delete from educations where student_id = old.id;
  delete from emails where person_id = old.id;
  delete from recommendations where recommender = old.id OR recommended = old.id;
  delete from residences where residences.person_id = old.id;
  delete from historical_residences where historical_residences.person_id = old.id;
  return old;
end;
$delFromPeople$ LANGUAGE plpgsql;

create trigger delFromPeople before delete on people
FOR EACH ROW EXECUTE PROCEDURE delFromPeople();



create table residences (
    person_id integer constraint fk_res_ppl references people(id) unique not null,
    city_id integer constraint fk_res_cit references cities(id),
    street varchar(100) not null,
    dwelling_number int2 not null,
    flat_number int2
    CHECK (street ~ '^([\dA-Za-z''\.]+\s)*[\dA-Za-z''\.]+$')
);

create table historical_residences (
    person_id integer references people(id),
    city_id integer references cities(id),
    street varchar(100),
    dwelling_number int2 NOT NULL,
    flat_number int2,
    lived_until date
    CHECK (street ~ '^([\dA-Za-z''\.]+\s)*[\dA-Za-z''\.]+$')
);

create or replace function alterResidences() returns trigger AS $alterResidences$
begin
  insert into historical_residences values (old.person_id,old.city_id,old.street,old.dwelling_number,old.flat_number,now());
  return new;
end;
$alterResidences$ LANGUAGE plpgsql;

create trigger alterResidences after update on residences
FOR EACH ROW EXECUTE PROCEDURE alterResidences();

create table universities (
    id integer constraint pk_uni primary key,
    name varchar(100) NOT NULL unique
);

create or replace function delFromUni() returns trigger AS $delFromUni$
begin
  delete from majors where majors.university_id = old.id;
  return old;
end;
$delFromUni$ LANGUAGE plpgsql;

create trigger delFromUni before delete on universities
FOR EACH ROW EXECUTE PROCEDURE delFromUni();

create table fields_of_study (
    id integer constraint pk_fie primary key,
    name varchar(100) NOT NULL unique
);

create or replace function delFromFields() returns trigger AS $delFromFields$
begin
  delete from majors where majors.field_id = old.id;
  return old;
end;
$delFromFields$ LANGUAGE plpgsql;

create trigger delFromFields before delete on fields_of_study
FOR EACH ROW EXECUTE PROCEDURE delFromFields();

create table majors (
    id integer constraint pk_maj primary key,
    university_id integer constraint fk_maj_uni references universities(id),
    field_id integer constraint fk_maj_fie references fields_of_study(id),
    unique (university_id,field_id)
);

create or replace function delFromMajors() returns trigger AS $delFromMajors$
begin
  delete from educations where educations.major_id = old.id;
  return old;
end;
$delFromMajors$ LANGUAGE plpgsql;

create trigger delFromMajors before delete on majors
FOR EACH ROW EXECUTE PROCEDURE delFromMajors();

create table educations (
    student_id integer constraint fk_e_ppl references people(id),
    major_id integer constraint fk_e_maj references majors(id),
    unique (student_id,major_id),
    degree varchar(8),
    start_of_studying date NOT NULL default now(),
    end_of_studying date default null,
    CHECK ( degree = 'none' OR degree = 'bachelor' OR degree = 'master' OR degree = 'PhD'),
    CHECK ( end_of_studying > start_of_studying )
);

create or replace function defaultEduEnd() returns trigger AS $defaultEduEnd$
begin

    if new.end_of_studying is not null then
        return new;
    end if;

    case
        when new.degree = 'none' then new.end_of_studying = new.start_of_studying + 3 * interval '1 year';
        when new.degree = 'bachelor' OR new.degree = 'master' then new.end_of_studying = new.start_of_studying + 5 * interval '1 year';
        else new.end_of_studying = new.start_of_studying + 9 * interval '1 year';
    end case;
    return new;
end;
$defaultEduEnd$ LANGUAGE plpgsql;
create trigger defaultEduEnd before insert on educations
FOR EACH ROW EXECUTE PROCEDURE defaultEduEnd();

create table companies (
	id integer constraint pk_com primary key,
	company_name varchar(100) not null unique,
	headquarters integer constraint fk_com_cit references cities(id),
	annual_revenue numeric(9,2)
);


create or replace function delFromCompanies() returns trigger AS $delFromCompanies$
begin
  delete from roles where roles.company_id = old.id;
  delete from work_places where work_places.company_id = old.id;
  return old;
end;
$delFromCompanies$ LANGUAGE plpgsql;

create trigger delFromCompanies before delete on companies
FOR EACH ROW EXECUTE PROCEDURE delFromCompanies();

create table positions (
    id integer constraint pk_pos primary key,
    name varchar(100) unique
);

create or replace function delFromPositions() returns trigger AS $delFromPositions$
begin
  delete from roles where roles.position_id = old.id;
  return old;
end;
$delFromPositions$ LANGUAGE plpgsql;

create trigger delFromPositions before delete on positions
FOR EACH ROW EXECUTE PROCEDURE delFromPositions();

create table roles (
    role_id integer constraint pk_r primary key,
    salary_range_min numeric(9,2),
    salary_range_max numeric(9,2),
    hours_per_week int2 NOT NULL,
    company_id integer constraint fk_r_com references companies(id) not null,
    position_id integer constraint fk_r_pos references positions(id),
    unique (company_id,position_id),
    CHECK ( salary_range_max >= salary_range_min ),
    CHECK ( hours_per_week > 0 AND hours_per_week <= 80 )
);

create or replace function updateSalary() returns trigger as $updateSalary$
begin
    update jobs
    set salary = greatest(least(salary,new.salary_range_max),new.salary_range_min)
    where role_id = old.role_id AND (ending_date >= now() OR ending_date IS NULL);
return new;
end;
$updateSalary$ LANGUAGE plpgsql;

create trigger updateSalary after update on roles
FOR EACH ROW EXECUTE PROCEDURE updateSalary();

create or replace function delFromRoles() returns trigger AS $delFromRoles$
begin
  delete from jobs where jobs.role_id = old.role_id;
  delete from recommendations where recommendations.role_id = old.role_id;
  delete from job_offers where job_offers.role_id = old.role_id;
  return old;
end;
$delFromRoles$ LANGUAGE plpgsql;

create trigger delFromRoles before delete on roles
FOR EACH ROW EXECUTE PROCEDURE delFromRoles();

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
    company_id integer constraint fk_wp_com references companies(id) not null,
    street varchar(100),
    street_number int2 not null
    CHECK (street ~ '^([\dA-Za-z''\.]+\s)*[\dA-Za-z''\.]+$') 
);

create or replace function delFromPlaces() returns trigger AS $delFromPlaces$
begin
  delete from jobs where jobs.location_id = old.id;
  delete from historical_work_places where historical_work_places.place_id = old.id;
  delete from open_close_hours where open_close_hours.location_id = old.id;
  return old;
end;
$delFromPlaces$ LANGUAGE plpgsql;

create trigger delFromPlaces before delete on work_places
FOR EACH ROW EXECUTE PROCEDURE delFromPlaces();

create table open_close_hours (
    location_id integer constraint fk_och_wp references work_places unique not null,
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

create or replace function minRangeForRole(role integer)
    returns numeric(9,2) as
$$
begin
    return
        (select salary_range_min
        from roles
        where role_id = role);
end;
$$
language plpgsql;

create or replace function maxRangeForRole(role integer)
    returns numeric(9,2) as
$$
begin
    return
        (select salary_range_max
        from roles
        where role_id = role);
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

     CHECK ( ending_date >= starting_date),
     CHECK ( isInRange(salary,role_id) ),
     CHECK ( companyOfRole(role_id) = companyOfWorkPlace(location_id) )
);

create or replace function oneCompanyOneJob()
    returns trigger as
$$
begin
    if
        0 != (
            select count(*)
            from jobs x
            where
                  x.employee = new.employee
                AND companyOfRole(x.role_id) = companyofrole(new.role_id)
                AND x.starting_date < new.ending_date
                AND x.ending_date > new.starting_date
            )
    then RAISE EXCEPTION 'one company one job';
    end if;
    return new;
end;
$$
language plpgsql;
create trigger oneCompanyOneJob before insert on jobs
FOR EACH ROW EXECUTE PROCEDURE oneCompanyOneJob();

create or replace function jobChange() returns trigger AS $jobChange$
begin
    update jobs
    set ending_date = new.starting_date
    where employee = new.employee AND companyofrole(role_id) = companyofrole(new.role_id) AND starting_date <= new.starting_date AND ending_date >= new.starting_date;
    if 0 < (select count(*) from jobs where jobs.employee = new.employee AND starting_date <= new.ending_date AND new.starting_date <= ending_date)
    then new = null;
    end if;
  return new;
end;
$jobChange$ LANGUAGE plpgsql;

create trigger jobChange before insert on jobs
FOR EACH ROW EXECUTE PROCEDURE jobChange();

create or replace function delFromJobs() returns trigger AS $delFromJobs$
begin
  delete from historical_work_places where historical_work_places.job_id = old.job_id;
  delete from historical_salaries where historical_salaries.job_id = old.job_id;
  return old;
end;
$delFromJobs$ LANGUAGE plpgsql;

create trigger delFromJobs before delete on jobs
FOR EACH ROW EXECUTE PROCEDURE delFromJobs();

create table historical_work_places (
    job_id integer references jobs(job_id),
    place_id integer references work_places(id),
    worked_here_till date
);
create or replace function alter_place_of_job() returns trigger as $alter_place_of_job$
begin
    if old.location_id != new.location_id
    then insert into historical_work_places values (old.job_id,old.location_id,now());
    end if;
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
    until date
);

create or replace function alterSalaries() returns trigger AS $alterSalaries$
begin
    if old.salary != new.salary
    then insert into historical_salaries values (old.job_id,old.salary,now());
    end if;
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
    constraint reco1 unique (recommender,recommended,role_id,time_of_recommendation),
    constraint reco2 CHECK ( recommender != recommended ),

    constraint reco3 CHECK ( notEmployedThen(time_of_recommendation,recommended,role_id)),
    constraint reco4 CHECK ( employedThen(time_of_recommendation,recommender,role_id) )

);

create or replace function ignoreBadInsertsInReco()
    returns trigger as
$$
begin
    if
        new.recommender is null OR new.role_id is null OR new.recommender = new.recommended
    then return null;
    end if;
    return new;
end;
$$
language plpgsql;
create trigger ignoreBadInsertsInReco before insert on recommendations
FOR EACH ROW EXECUTE PROCEDURE ignoreBadInsertsInReco();

create table job_offers (
    id integer constraint pk_emp primary key,
    role_id integer constraint fk_emp_r references roles(role_id),
    work_place_id integer references work_places(id),
    start_of_search date NOT NULL,
    end_of_search date NOT NULL,
    CHECK ( end_of_search >= start_of_search )
);

create table emails (
    person_id integer constraint fk_c_ppl references people(id),
    email varchar(100) unique not null,
    CHECK ( email ~ '^[^@]+@[^@\.]+\.[^@\.][^@]*$' )
);

create or replace function addCorporateMail() returns trigger AS $addCorporateMail$
declare name1 varchar(100);
declare name2 varchar(100);
declare emaill varchar(100);
begin
    name1 = (select name
    from people
    where id = new.employee);
    name2 = (select company_name
    from companies
    where id = companyOfRole(new.role_id));
    name1 = replace(name1,' ','.');
    name2 = replace(name2,' ','-');
    name2 = replace(name2,'.','-');
    emaill = concat(name1,'@',name2,'.com');
    insert into emails select new.employee,emaill where not exists ( select * from emails x where x.email = emaill);
    return new;
end
$addCorporateMail$ LANGUAGE plpgsql;

create trigger addCorporateMail after insert on jobs
FOR EACH ROW EXECUTE PROCEDURE addCorporateMail();

create or replace function universityOfMajor(major integer)
	returns integer as
$$
begin
	return
        (select university_id
        from majors
        where id = major
        );
end;
$$
language plpgsql;

create or replace function addUniversityMail() returns trigger AS $addUniversityMail$
declare name1 varchar(100);
declare name2 varchar(100);
declare emaill varchar(100);
begin
    name1 = (select name
    from people
    where id = new.student_id);
    name2 = (select name
    from universities
    where id = universityOfMajor(new.major_id));
    name1 = replace(name1,' ','.');
    name2 = replace(name2,' ','.');
    emaill = concat(name1,'@',name2,'.edu');
    insert into emails select new.student_id,emaill where not exists ( select * from emails x where x.email = emaill);
    return new;
end;
$addUniversityMail$ LANGUAGE plpgsql;

create trigger addUniversityMail after insert on educations
FOR EACH ROW EXECUTE PROCEDURE addUniversityMail();


create index idx_work_places_city_id on work_places(city_id);
create index idx_jobs_location_id on jobs(location_id);
create index idx_residences_city_id on residences(city_id);
create index idx_job_offers on job_offers(role_id);
create index idx_salary_range on roles(salary_range_min, salary_range_max);

drop view if exists recommended;
create view recommended as
	select recommended, time_of_recommendation
		from recommendations;

drop view if exists bachelors;
create view bachelors as
	select id, name
		from people join educations on (id=student_id)
		where degree='bachelor' and end_of_studying<current_date;

drop view if exists masters;
create view masters as
	select id, name
		from people join educations on (id=student_id)
		where degree='master' and end_of_studying<current_date;

drop view if exists doctorals;
create view doctorals as
	select id, name
		from people join educations on (id=student_id)
		where degree='doctoral' and end_of_studying<current_date;

drop view if exists workingEmployees_positions;
create view workingEmployees_positions as
	select employee as id, people.name, positions.name as position
		from jobs join roles using (role_id)
					join positions on (position_id=positions.id)
					join people on (employee=people.id)
		where ending_date<current_date;

drop view if exists job_offers_info;
create view job_offers_info as
	select positions.name as position, cities.name as city, companies.company_name as company,
			salary_range_min as "min salary", salary_range_max as "max salary", hours_per_week
		from job_offers join roles using (role_id)
						join positions on (positions.id=position_id)
						join companies on (company_id=companies.id)
						join work_places on (work_place_id=work_places.id)
						join cities on (cities.id=work_places.id);

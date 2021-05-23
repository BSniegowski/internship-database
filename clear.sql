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

drop function if exists isInRange(salary numeric(9,2), id integer);
drop function if exists notEmployedThen(time_of_rec date, recommended integer, role integer);
drop function if exists companyOfRole(role integer);
drop function if exists employedThen(time_of_rec date, recommender integer, role integer);
drop function if exists job_start(id integer);
drop function if exists job_end(id integer);
drop function if exists oneCompanyOneJob(employee_new integer,company_id_new integer,start_of_new_job date, end_of_new_job date);


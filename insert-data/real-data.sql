----
insert into people (id, name) values ( (select coalesce(max(id),0)+1 from people), 'Jędrzej Kula' );
insert into universities (id, name, city) values ( (select coalesce(max(id), 0)+1 from universities), 'Jagiellonian University', 'Cracow');
insert into majors (id, university_id, field_id) values ( (select coalesce(max(id), 0)+1 from majors), (select max(id) from universities), 1);
insert into education (student_id, major_id, degree, start_of_studying, end_of_studying) values ( (select max(id) from people), (select max(id) from majors), 'master', to_date('2017', 'YYYY'), to_date('2022', 'YYYY') );
insert into contacts (id, linkedin) values ( (select max(id) from people), 'https://www.linkedin.com/in/j%C4%99drzej-kula-563679195/' );
insert into work_places (id, city, street) values ( (select coalesce(max(id),0)+1 from work_places), 'London', 'Rathbone Square' ); 
insert into companies (id, name, main_country) values ( (select coalesce(max(id),0)+1 from companies), 'Facebook', 'USA');
insert into roles (role_id, role_name, company_id) values ( (select coalesce(max(role_id),0)+1 from roles), 'Software Engineer', (select max(id) from companies) );
insert into jobs (role_id, employee, location_id, job_id, starting_date, ending_date) values ( (select max(id) from roles), (select max(id) from people), (select max(id) from work_places) , (select coalesce(max(job_id),0)+1 from jobs), to_date('201906', 'YYYYMM'), to_date('201910', 'YYYYMM'));

----
insert into people (id, name) values ( (select coalesce(max(id),0)+1 from people), 'Michał Jaglarz' );
insert into education (student_id, major_id, degree, start_of_studying, end_of_studying) values ( (select max(id) from people), (select max(id) from majors), 'bachelor', to_date('2017', 'YYYY'), to_date('2020', 'YYYY') );
insert into fields_of_study (id, name) values ( (select coalesce(max(id),0)+1 from fields_of_study), 'Computer Game Design and Development')
insert into majors (id, university_id, field_id) values ( (select coalesce(max(id), 0)+1 from majors), (select max(id) from universities), (select max(id) from fields_of_study));
insert into education (student_id, major_id, degree, start_of_studying, end_of_studying) values ( (select max(id) from people), (select max(id) from majors), 'master', to_date('2020', 'YYYY'), to_date('2022', 'YYYY') );
insert into contacts (id, linkedin) values ( (select max(id) from people), 'https://www.linkedin.com/in/mjaglarz/' );
insert into work_places (id, city, street) values ( (select coalesce(max(id),0)+1 from work_places), 'Chicago', 'Monroe Street' ); 
--insert into companies (id, name, main_country) values ( (select coalesce(max(id),0)+1 from companies), 'Motorola ', 'USA');
insert into roles (role_id, role_name, company_id) values ( (select coalesce(max(role_id),0)+1 from roles), 'Software Developer', (select id from companies where name='Motorola Solutions') );
insert into jobs (role_id, employee, location_id, job_id, starting_date, ending_date) values ( (select max(id) from roles), (select max(id) from people), (select max(id) from work_places) , (select coalesce(max(job_id),0)+1 from jobs), to_date('201906', 'YYYYMM'), to_date('202007', 'YYYYMM'));

----
insert into people (id, name) values ( (select coalesce(max(id),0)+1 from people), 'Rafał Brożek' );
insert into fields_of_study (id, name) values ( (select coalesce(max(id),0)+1 from fields_of_study), 'Informatics' )
insert into majors (id, university_id, field_id) values ( (select coalesce(max(id), 0)+1 from majors), (select max(id) from universities), (select max(id) from fields_of_study));
insert into education (student_id, major_id, degree, start_of_studying, end_of_studying) values ( (select max(id) from people), (select max(id) from majors), 'bachelor', to_date('2017', 'YYYY'), to_date('2020', 'YYYY') );
insert into fields_of_study (id, name) values ( (select coalesce(max(id),0)+1 from fields_of_study), 'Software Engineering')
insert into majors (id, university_id, field_id) values ( (select coalesce(max(id), 0)+1 from majors), (select max(id) from universities), (select max(id) from fields_of_study));
insert into education (student_id, major_id, degree, start_of_studying, end_of_studying) values ( (select max(id) from people), (select max(id) from majors), 'master', to_date('2020', 'YYYY'), to_date('2022', 'YYYY') );

insert into contacts (id, linkedin) values ( (select max(id) from people), 'https://www.linkedin.com/in/rafa%C5%82-bro%C5%BCek-2651361a6/' );
insert into work_places (id, city, street) values ( (select coalesce(max(id),0)+1 from work_places), 'Cracow', 'Pawia' ); 
insert into companies (id, name, main_country) values ( (select coalesce(max(id),0)+1 from companies), 'Qualtrics ', 'USA');
insert into roles (role_id, role_name, company_id) values ( (select coalesce(max(role_id),0)+1 from roles), 'Software Engineer', (select max(id) from companies) );
insert into jobs (role_id, employee, location_id, job_id, starting_date, ending_date) values ( (select max(id) from roles), (select max(id) from people), (select max(id) from work_places) , (select coalesce(max(job_id),0)+1 from jobs), to_date('202101', 'YYYYMM'), NULL);

----
insert into people (id, name) values ( (select coalesce(max(id),0)+1 from people), 'Jakub Gadawski' );
--insert into majors (id, university_id, field_id) values ( (select coalesce(max(id), 0)+1 from majors), (select max(id) from universities), (select max(id) from fields_of_study));
insert into education (student_id, major_id, degree, start_of_studying, end_of_studying) values ( (select max(id) from people), (select max(id) from majors), 'bachelor', to_date('2018', 'YYYY'), to_date('2021', 'YYYY') );

insert into contacts (id, linkedin) values ( (select max(id) from people), 'https://www.linkedin.com/in/jakub-gadawski-5775421a3/' );
insert into work_places (id, city, street) values ( (select coalesce(max(id),0)+1 from work_places), 'Cracow', 'Jana Pawła II' ); 
insert into companies (id, name, main_country) values ( (select coalesce(max(id),0)+1 from companies), 'Comarch ', 'Poland');
insert into roles (role_id, role_name, company_id) values ( (select coalesce(max(role_id),0)+1 from roles), 'Software Developer', (select max(id) from companies) );
insert into jobs (role_id, employee, location_id, job_id, starting_date, ending_date) values ( (select max(id) from roles), (select max(id) from people), (select max(id) from work_places) , (select coalesce(max(job_id),0)+1 from jobs), to_date('202010', 'YYYYMM'), NULL);

----
insert into people (id, name) values ( (select coalesce(max(id),0)+1 from people), 'Bartłomiej Mzyk' );
--insert into majors (id, university_id, field_id) values ( (select coalesce(max(id), 0)+1 from majors), (select max(id) from universities), (select max(id) from fields_of_study));
insert into education (student_id, major_id, degree, start_of_studying, end_of_studying) values ( (select max(id) from people), (select max(id) from majors), 'bachelor', to_date('2018', 'YYYY'), to_date('2021', 'YYYY') );

insert into contacts (id, linkedin) values ( (select max(id) from people), 'https://www.linkedin.com/in/bart%C5%82omiej-mzyk-8a4b56195/' );
insert into roles (role_id, role_name, company_id) values ( (select coalesce(max(role_id),0)+1 from roles), 'Junior Java Developer', (select max(id) from companies) );
insert into jobs (role_id, employee, location_id, job_id, starting_date, ending_date) values ( (select max(id) from roles), (select max(id) from people), (select max(id) from work_places) , (select coalesce(max(job_id),0)+1 from jobs), to_date('202010', 'YYYYMM'), to_date('202101', 'YYYYMM'));

----
insert into people (id, name) values ( (select coalesce(max(id),0)+1 from people), 'Gabriela Czarska' );
insert into education (student_id, major_id, degree, start_of_studying, end_of_studying) values ( (select max(id) from people), (select id from majors where university_id=(select id from universities where name='Jagiellonian University') and field_id=1), 'bachelor', to_date('2015', 'YYYY'), to_date('2018', 'YYYY') );
insert into contacts (id, linkedin) values ( (select max(id) from people), 'https://www.linkedin.com/in/gabriela-czarska-b8a03b104/' );
insert into companies (id, name, main_country) values ( (select coalesce(max(id),0)+1 from companies), 'Crossword Cybersecurity', 'United Kingdom' )
insert into roles (role_id, role_name, company_id) values ( (select coalesce(max(role_id),0)+1 from roles), 'Software Developer', (select max(id) from companies) );
insert into work_places (id, city, street) values ( (select coalesce(max(role_id),0)+1 from work_places), 'Cracow', 'Olszańska' )
insert into jobs (role_id, employee, location_id, job_id, starting_date, ending_date) values ( (select max(id) from roles), (select max(id) from people), (select max(id) from work_places) , (select coalesce(max(job_id),0)+1 from jobs), to_date('201804', 'YYYYMM'), to_date('201905', 'YYYYMM'));
insert into jobs (role_id, employee, location_id, job_id, starting_date, ending_date) values ( (select id from roles where role_name='Software Engineer' and company_id=(select id from companies where name='Qualtrics')), (select max(id) from people), (select max(location_id) from jobs where employee=(select max(id) from people where name='Rafał Brożek')) , (select coalesce(max(job_id),0)+1 from jobs), to_date('201906', 'YYYYMM'), NULL);


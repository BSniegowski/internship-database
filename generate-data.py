from internship_database import *
import random
import numpy as np
from faker import Faker

fake = Faker()

initializeDatabase()
with open("generated-data.sql", "w") as clear_up:
    clear_up.write("")


def generate_people(amount):
    max_id = getQueryResult('select max(id) from people;')
    max_id = max_id[0][0]

    with open("first-names.txt", "r") as f_names, open("last-names.txt", "r") as l_names:
        first_names = [f_names.readline().strip() for i in range(1000)]
        last_names = [l_names.readline().strip() for i in range(1000)]

    def getRandomName():
        return first_names[random.randrange(len(first_names))] + ' ' + \
               last_names[random.randrange(len(last_names))]

    with open("insert_people.sql", "a") as gd:
        for i in range(amount):
            max_id += 1
            gd.write("insert into people (id, name) values (" + str(max_id) + ", '" + getRandomName() + "');\n")


countries = open("countries.txt", "r").read().split('\n')


def randomCountry():
    return countries[random.randrange(len(countries))]


def randomRevenue():
    return round(np.random.uniform(0, 1) * 100000.0, 4)


def add_companies():
    id = 0
    with open("generated-data.sql", "a") as gd:
        for company in open("companies.txt", "r").read().split('\n'):
            gd.write("insert into companies (id, company_name, main_country, annual_revenue) values ("
                     + str(id) + ", '" + company.replace("'", "") + "', '" + randomCountry() + "', " +
                     str(randomRevenue()) + ");\n")
            id += 1


def getRandomDate(start='-30y'):
    return fake.date_between(start_date=start, end_date='today')


def randomListValue(list):
    return list[random.randrange(len(countries))]


def add_roles(amount):
    role_names = []
    for name in open("role_names.txt", "r").read().split('\n'):
        role_names.append(name)
    possible_hours = [20, 30, 40, 60]
    company_ids = getQueryResult('select id from companies;')

    with open("insert_jobs.sql", "a") as roles:
        for id in range(amount):
            role_name = randomListValue(role_names)
            hours = randomListValue(possible_hours)
            salary_min = randomRevenue()
            salary_max = randomRevenue()
            if salary_min > salary_max:
                salary_min, salary_max = salary_max, salary_min

            roles.write("insert into roles (role_id, role_name, company_id, hours, salary_range_min, salary_range_max)"
                        "values (%s, %s, %s, %s, %s, %s)" % id, role_name, company_ids, hours, salary_min, salary_max)


add_companies()

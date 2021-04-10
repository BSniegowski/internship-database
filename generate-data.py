from internship_database import *
import random
import numpy as np

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

    with open("generated-data.sql", "a") as gd:
        for i in range(amount):
            max_id += 1
            gd.write("insert into people (id, name) values (" + str(max_id) + ", '" + getRandomName() + "');\n")


countries = open("countries.txt", "r").read().split('\n')


def randomCountry():
    return countries[random.randrange(len(countries))]


def randomRevenue():
    return round(np.random.uniform(0, 1) * 100000.0, 4)


def add_companies():
    # companies = getQueryResult('select * from companies;')
    id = 0
    with open("generated-data.sql", "a") as gd:
        for company in open("companies.txt", "r").read().split('\n'):
            gd.write("insert into companies (id, company_name, main_country, annual_revenue) values ("
                     + str(id) + ", '" + company.replace("'", "") + "', '" + randomCountry() + "', " +
                     str(randomRevenue()) + ");\n")
            id += 1


add_companies()

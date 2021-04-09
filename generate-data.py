from internship_database import *
import random

initializeDatabase()


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
            max_id = max_id + 1
            gd.write("insert into people (id, name) values (" + str(max_id) + ", '" + getRandomName() + "');\n")


generate_people(1)

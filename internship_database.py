import psycopg2
from tkinter import *
import pandas as pd
import random


class DatabaseAccess:
    def __init__(self):
        self.conn = psycopg2.connect(dbname='pankin610', user='pankin610',
                                     password='12zuhabo67ZOURUG@')
        self.cursor = self.conn.cursor()
        self.cursor.execute(open("create.sql", "r").read())
        generate_files = ["insert_cities.sql",
                          "insert_companies.sql",
                          "insert_places.sql", "insert_fields.sql", "insert_universities.sql",
                          "insert_majors.sql",
                          "insert_people.sql", "insert_positions.sql", "insert_roles.sql",
                          "insert_educations.sql",
                          "insert_hours.sql", "insert_job_offers.sql",
                          "insert_residences.sql",
                          "jobs.sql"]
        generate_files = ["inserts/" + i for i in generate_files]
        for file in generate_files:
            gd = open(file).read()
            if len(gd) > 0:
                self.cursor.execute(gd)

    def getCursor(self):
        return self.cursor


class DatabaseGui:
    def __init__(self):
        self.cursor = DatabaseAccess().getCursor()
        root = Tk()
        Label(root, text="The internship database.").grid(row=0)
        Label(root, text="Type a custom SQL query and press 'Execute' ").grid(row=1)
        self.output_label = Label(root, text="")
        self.output_label.grid(row=2)
        Button(root, text="Execute", command=self.read_query).grid(row=3, column=1)
        self.query_input = Entry(root, width=40)
        self.query_input.grid(row=3)

        Label(root, text="Give us info about you.").grid(row=1, column=2)
        Label(root, text="Your school:").grid(row=2, column=2)
        self.school_input = Entry(root, width=18)
        self.school_input.grid(row=2, column=3)
        Label(root, text="Your company:").grid(row=3, column=2)
        self.company_input = Entry(root, width=18).grid(row=3, column=3)
        Label(root, text="Your position:").grid(row=4, column=2)
        self.position_input = Entry(root, width=18).grid(row=4, column=3)

        Button(root, text="Info", command=self.getInfo).grid(row=1, column=3)
        Button(root, text="Analyze", command=self.getInfo).grid(row=2, column=4)
        Button(root, text="Analyze", command=self.getInfo).grid(row=3, column=4)
        Button(root, text="Analyze", command=self.getInfo).grid(row=4, column=4)

        Button(root, text="Add new person", command=self.showAdderWindow).grid(row=5, column=0)
        Button(root, text="Find person", command=self.showFinderWindow).grid(row=5, column=1)

        root.mainloop()

    def showFinderWindow(self):
        self.finder = Toplevel()

        Label(self.finder, text="Name").grid(row=0)
        self.name_input = Entry(self.finder, width=10)
        self.name_input.grid(row=1)

        Button(self.finder, text="Get info", command=self.getPerson).grid(row=2)


    def getPerson(self):
        Label(self.finder, text="Jobs:").grid(row=3)
        output = Label(self.finder)
        output.grid(row=4)

        output.config(text=str(self.getQueryResult("select * from jobs where employee=(select id from people where name='" +
                                                   self.name_input.get() + "');")))


    def showAdderWindow(self):
        adder = Toplevel()

        Label(adder, text="Name").grid(row=0)
        self.add_name = Entry(adder, width=10)
        self.add_name.grid(row=1)

        Label(adder, text="Major ID").grid(row=2)
        self.add_school = Entry(adder, width=10)
        self.add_school.grid(row=3)

        Label(adder, text="Role ID").grid(row=4)
        self.add_work = Entry(adder, width=10)
        self.add_work.grid(row=5)

        Button(adder, text="OK", command=self.addNewPerson).grid(row=6)

    def addNewPerson(self):
        major_id = self.add_school.get()
        role_id = self.add_work.get()
        name = self.add_name.get()

        person_id = random.randrange(5001, 2000000000)
        job_id = random.randrange(10000, 2000000000)

        with open("inserts/insert_people.sql", 'a') as insert_people:
            insert_people.write("insert into people (id, name) values (" + str(person_id) + ", '" + name + "');\n")
        with open("inserts/insert_jobs.sql", 'a') as insert_jobs:
            insert_jobs.write("insert into jobs (job_id, role_id, employee) values (" +
                              str(job_id) + ", " + str(role_id) + ", " + str(person_id) + ");\n")
        with open("inserts/insert_educations.sql", 'a') as insert_educations:
            insert_educations.write("insert into educations (student_id, major_id) values (" +
                                    str(person_id) + ", " + str(major_id) + ");\n")


    def getInfo(self):
        res = ''
        res += "Studied at the same school: "
        res += str(len(self.getQueryResult("select * from universities where name='" + self.school_input.get() + "';")))
        self.output_label.config(text=res)

    def getQueryResult(self, query):
        self.cursor.execute(query)
        return self.cursor.fetchall()

    def read_query(self):
        query = self.query_input.get()
        self.cursor.execute(query)
        res = pd.DataFrame(self.cursor.fetchall())
        self.output_label.config(text=res)
        self.query_input.delete(0, END)


def __main__():
    gui = DatabaseGui()


if __name__ == '__main__':
    __main__()

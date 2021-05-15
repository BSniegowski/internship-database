import psycopg2
from tkinter import *
import pandas as pd


class DatabaseGui:
    def __init__(self):
        self.initializeDatabase()
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

        root.mainloop()

    def getInfo(self):
        res = ''

        res += "Studied at the same school: "
        res += str(len(self.getQueryResult("select * from universities where name='" + self.school_input.get() + "';")))
        self.output_label.config(text=res)


    def initializeDatabase(self):
        self.conn = psycopg2.connect(dbname='pankin610', user='pankin610',
                                     password='12zuhabo67ZOURUG@')
        self.cursor = self.conn.cursor()
        self.cursor.execute(open("create.sql", "r").read())
        generate_files = ["insert-data/insert_people.sql", "insert-data/insert_companies.sql",
                          "insert-data/insert_fields.sql", "insert-data/insert_universities.sql",
                          "insert-data/insert_roles.sql"]
        for file in generate_files:
            gd = open(file).read()
            if len(gd) > 0:
                self.cursor.execute(gd)
        return self.cursor

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

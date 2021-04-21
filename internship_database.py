import psycopg2
from tkinter import *


def initializeDatabase():
    global conn
    global cursor
    conn = psycopg2.connect(dbname='pankin', user='pankin',
                            password='12zuhabo')
    cursor = conn.cursor()
    cursor.execute(open("create.sql", "r").read())
    generate_files = ["insert-data/insert_people.sql", "insert-data/insert_companies.sql",
                      "insert-data/insert_fields.sql", "insert-data/insert_universities.sql",
                      "insert-data/insert_roles.sql"]
    for file in generate_files:
        gd = open(file).read()
        if len(gd) > 0:
            cursor.execute(gd)
    return cursor


def getQueryResult(query):
    cursor.execute(query)
    return cursor.fetchall()


def read_query():
    query = query_input.get()
    cursor.execute(query)
    output_label.config(text=cursor.fetchall())
    query_input.delete(0, END)


# read_queries()
def __main__():
    initializeDatabase()
    root = Tk()
    Label(root, text="The internship database.").grid(row=0)
    Label(root, text="Type an SQL query and press 'Execute' ").grid(row=1)
    output_label = Label(root, text="")
    output_label.grid(row=2)
    Button(root, text="Execute", command=read_query).grid(row=1, column=1)
    query_input = Entry(root, width=70)
    query_input.grid(row=3)
    root.mainloop()

import psycopg2
from tkinter import *


def initialize_database():
    global conn
    global cursor
    conn = psycopg2.connect(dbname='pankin', user='pankin',
                            password='12zuhabo')
    cursor = conn.cursor()
    cursor.execute(open("db-init.sql", "r").read())
    return cursor


def read_query():
    query = query_input.get()
    cursor.execute(query)
    output_label.config(text=cursor.fetchall())
    query_input.delete(0, END)


# read_queries()
initialize_database()
root = Tk()
Label(root, text="The internship database.").grid(row=0)
Label(root, text="Type an SQL query and press 'Execute' ").grid(row=1)
output_label = Label(root, text="")
output_label.grid(row=2)
Button(root, text="Execute", command=read_query).grid(row=1, column=1)
query_input = Entry(root, width=70)
query_input.grid(row=3)
root.mainloop()

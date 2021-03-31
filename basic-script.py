import psycopg2
def initialize_database():
    global conn
    global cursor
    conn = psycopg2.connect(dbname='pankin', user='pankin',
                            password='12zuhabo')
    cursor = conn.cursor()
    cursor.execute(open("db-init.sql", "r").read())
    return cursor

initialize_database()
while True:
    print("Type an SQL query or 'q' to quit.")
    query = input()
    if query == 'q':
        break
    cursor.execute(query)
    print(cursor.fetchall())

cursor.close()
conn.close()

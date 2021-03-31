import psycopg2
conn = psycopg2.connect(dbname='pankin', user='pankin',
                        password='12zuhabo')
cursor = conn.cursor()
cursor.execute(open("db-init.sql", "r").read())

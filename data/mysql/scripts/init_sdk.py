import os
import mysql.connector
from mysql.connector import Error

MYSQL_HOST = os.getenv("MYSQL_HOST", "mysql")
MYSQL_USER = os.getenv("MYSQL_USER", "root")
MYSQL_PASSWORD = os.getenv("MYSQL_PASSWORD", "rootpass")
MYSQL_DB = os.getenv("MYSQL_DB", "db_workbench")
MYSQL_PORT = int(os.getenv("MYSQL_PORT", 3306))

connection = None
cursor = None

try:
    print(f"Connecting to MySQL at {MYSQL_HOST}:{MYSQL_PORT}...")

    connection = mysql.connector.connect(
        host=MYSQL_HOST,
        user=MYSQL_USER,
        password=MYSQL_PASSWORD,
        database=MYSQL_DB,
        port=MYSQL_PORT
    )

    if connection.is_connected():
        cursor = connection.cursor(buffered=True)

        print(f"Connected to MySQL version {connection.server_info}")
        print("\n||| MySQL SDK Python CLI |||")
        print("Objects available:")
        print("    - conn")
        print(f"    - cursor\n")


        import code
        conn = connection  # unify naming
        code.interact(local=globals())

except Error as e:
    print(f"Error connecting to MySQL: {e}")
    exit(1)

finally:
    if cursor:
        cursor.close()
    if connection and connection.is_connected():
        connection.close()
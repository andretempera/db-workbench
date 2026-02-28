import os
import mysql.connector
from mysql.connector import Error

MARIADB_HOST = os.getenv("MARIADB_HOST", "mariadb")
MARIADB_USER = os.getenv("MARIADB_USER", "root")
MARIADB_PASSWORD = os.getenv("MARIADB_ROOT_PASSWORD", "rootpass")
MARIADB_DB = os.getenv("MARIADB_DB", "db_workbench")
MARIADB_PORT = int(os.getenv("MARIADB_PORT", 3306))

connection = None
cursor = None

try:
    print(f"Connecting to MariaDB at {MARIADB_HOST}:{MARIADB_PORT}...")

    connection = mysql.connector.connect(
        host=MARIADB_HOST,
        user=MARIADB_USER,
        password=MARIADB_PASSWORD,
        database=MARIADB_DB,
        port=MARIADB_PORT
    )

    if connection.is_connected():
        cursor = connection.cursor(buffered=True)

        print(f"Connected to MariaDB version {connection.server_info}")
        print("||| MariaDB SDK Python CLI |||")
        print("\nObjects available:")
        print(" - conn")
        print(" - cursor")

        import code
        conn = connection  # unify naming
        code.interact(local=globals())

except Error as e:
    print(f"Error connecting to MariaDB: {e}")
    exit(1)

finally:
    if cursor:
        cursor.close()
    if connection and connection.is_connected():
        connection.close()
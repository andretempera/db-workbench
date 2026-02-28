import os
import psycopg2
from psycopg2 import Error

# Environment variables
POSTGRES_HOST = os.getenv("POSTGRES_HOST", "localhost")
POSTGRES_USER = os.getenv("POSTGRES_USER", "postgres")
POSTGRES_PASSWORD = os.getenv("POSTGRES_PASSWORD", "rootpass")
POSTGRES_DB = os.getenv("POSTGRES_DB", "db_workbench")
POSTGRES_PORT = int(os.getenv("POSTGRES_PORT", 5432))

connection = None
cursor = None

try:
    print(f"Connecting to PostgreSQL at {POSTGRES_HOST}:{POSTGRES_PORT}...")

    connection = psycopg2.connect(
        host=POSTGRES_HOST,
        user=POSTGRES_USER,
        password=POSTGRES_PASSWORD,
        dbname=POSTGRES_DB,
        port=POSTGRES_PORT
    )

    cursor = connection.cursor()

    print(f"Connected to PostgreSQL version: {connection.server_version}")
    print("||| PostgreSQL SDK Python CLI |||")
    print("\nObjects available:")
    print(" - conn")
    print(" - cursor")

    # Launch interactive console
    import code
    conn = connection  # unify naming
    code.interact(local=globals())

except Error as e:
    print(f"Error connecting to PostgreSQL: {e}")
    exit(1)

finally:
    if cursor:
        cursor.close()
    if connection:
        connection.close()
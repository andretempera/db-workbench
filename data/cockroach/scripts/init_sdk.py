import os
import psycopg2

COCKROACH_HOST = os.getenv("COCKROACH_HOST", "cockroach")
COCKROACH_PORT = int(os.getenv("COCKROACH_PORT", 26257))
COCKROACH_USER = os.getenv("COCKROACH_USER", "root")
COCKROACH_DB = os.getenv("COCKROACH_DB", "db_workbench")

conn = None
cursor = None

try:
    print(f"Connecting to CockroachDB at {COCKROACH_HOST}:{COCKROACH_PORT}...")

    conn = psycopg2.connect(
        host=COCKROACH_HOST,
        port=COCKROACH_PORT,
        user=COCKROACH_USER,
        dbname=COCKROACH_DB,
        sslmode="disable"
    )

    cursor = conn.cursor()

    cursor.execute("SELECT version();")
    version = cursor.fetchone()[0]

    print(f"Connected to CockroachDB")
    print(version)

    print("\n||| CockroachDB SDK Python CLI |||")
    print("Objects available:")
    print("    - conn")
    print("    - cursor\n")

    import code
    code.interact(local=globals())

except Exception as e:
    print(f"Error connecting to CockroachDB: {e}")
    exit(1)

finally:
    if cursor:
        cursor.close()
    if conn:
        conn.close()
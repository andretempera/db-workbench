import os
import duckdb

# Project root
BASE_DIR = os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))))
DATA_DIR = os.path.join(BASE_DIR, "data", "duckdb", "db")
os.makedirs(DATA_DIR, exist_ok=True)

db_path = os.path.join(DATA_DIR, "database.duckdb")

# Connect (creates DB if it doesn't exist)
conn = duckdb.connect(db_path)

# Optional test table
conn.execute("CREATE TABLE IF NOT EXISTS test(id INTEGER, name VARCHAR);")

print(f"DuckDB database ready: {db_path}")
print("Entering interactive DuckDB Python session. Type SQL queries or 'exit' to quit.")

while True:
    query = input("SQL> ")
    if query.strip().lower() in ("exit", "quit"):
        break
    try:
        result = conn.execute(query).fetchall()
        print(result)
    except Exception as e:
        print("Error:", e)

conn.close()
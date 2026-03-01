import os
import sqlite3
import code

# Environment variables
SQLITE_DB_PATH = os.getenv("SQLITE_DB_PATH", "./data/sqlite/db_workbench.db")

# Connect
conn = sqlite3.connect(SQLITE_DB_PATH)

# Optional: create a cursor if you want to match SQL SDK style
cursor = conn.cursor()

# Prints for user orientation
print(f"Connected to SQLite database at {SQLITE_DB_PATH}")
print("\n||| SQLite SDK Python CLI |||")
print("Objects available:")
print("    - conn")
print(f"    - cursor\n")

# Launch interactive shell
code.interact(local=globals())
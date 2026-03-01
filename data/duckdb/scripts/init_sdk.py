import os
import duckdb
import code
import pandas as pd

# Environment variables
DUCKDB_DB_PATH = os.getenv("DUCKDB_DB_PATH", "./data/duckdb/db_workbench.duckdb")

# Connect
conn = duckdb.connect(DUCKDB_DB_PATH)

# Optional: create a cursor if you want to match SQL SDK style
cursor = conn.cursor()

# Prints for user orientation
print(f"Connected to DuckDB database at {DUCKDB_DB_PATH}")
print("\n||| DuckDB SDK Python CLI |||")
print("Objects available:")
print("    - conn")
print("    - cursor")
print(f"    - pd (pandas)\n")

# Launch interactive shell
code.interact(local=globals())
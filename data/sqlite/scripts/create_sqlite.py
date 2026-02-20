import os
import sqlite3
import subprocess

# Resolve project root dynamically
BASE_DIR = os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))))
DATA_DIR = os.path.join(BASE_DIR, "data", "sqlite", "db")

def ensure_folder(path):
    os.makedirs(path, exist_ok=True)

def sqlite_up(db_name="database.db"):
    ensure_folder(DATA_DIR)
    db_path = os.path.join(DATA_DIR, db_name)

    conn = sqlite3.connect(db_path)
    conn.execute("CREATE TABLE IF NOT EXISTS test (id INTEGER, name TEXT);")
    conn.commit()
    conn.close()

    print(f"SQLite database ready: {db_path}")

    print("Launching SQLite CLI...")
    subprocess.run(["sqlite3", db_path])

if __name__ == "__main__":
    sqlite_up()
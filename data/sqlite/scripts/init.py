import sqlite3
from pathlib import Path


# Resolve project root dynamically
BASE_DIR = Path(__file__).resolve().parents[3]
DATA_DIR = BASE_DIR / "data" / "sqlite" / "db"


def ensure_folder(path):
    path.mkdir(parents=True, exist_ok=True)


def init():
    ensure_folder(DATA_DIR)

    DB_PATH = DATA_DIR / "db_workbench.db"

    with sqlite3.connect(DB_PATH) as conn:
        conn.execute("""
            CREATE TABLE IF NOT EXISTS test (
                id INTEGER PRIMARY KEY,
                name TEXT,
                project TEXT
            );
        """)

        conn.execute("""
            INSERT INTO test (id, name, project)
            VALUES (1, 'Andre', 'db-workbench')
            ON CONFLICT (id) DO NOTHING;
        """)


if __name__ == "__main__":
    init()

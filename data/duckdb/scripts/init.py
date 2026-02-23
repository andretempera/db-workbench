import os
import duckdb

# Resolve project root dynamically
BASE_DIR = os.path.dirname(
    os.path.dirname(
        os.path.dirname(
            os.path.dirname(os.path.abspath(__file__))
        )
    )
)

DATA_DIR = os.path.join(BASE_DIR, "data", "duckdb", "db")


def ensure_folder(path):
    os.makedirs(path, exist_ok=True)


def init():
    ensure_folder(DATA_DIR)

    conn = duckdb.connect(os.path.join(DATA_DIR, "db_workbench.duckdb"))

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

    conn.close()


if __name__ == "__main__":
    init()
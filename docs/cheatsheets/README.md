# DB Workbench Cheatsheets

This folder contains reference cheatsheets for all databases included in **`db-workbench`**. Each cheatsheet is designed to provide quick-start commands, mental models, and notes for local experimentation.


## Structure
- `file/` – Cheatsheets for file-based databases (SQLite, DuckDB)
- `sql/` – Cheatsheets for SQL databases (PostgreSQL, MySQL, MariaDB)
- `nosql/` – Cheatsheets for NoSQL databases (MongoDB, Redis, Cassandra, Elasticsearch, ClickHouse, Couchbase)


## Notes
- Each cheatsheet assumes a default workspace (`db_workbench` or `db_workbench.duckdb`) pre-created by the project.
- Commands reflect local, containerized, or CLI usage; some databases have multiple CLI options (e.g., DuckDB Python vs Docker CLI).
- These cheatsheets are intended for **learning, testing, and experimentation** — not production deployment.


## How to Use
1. Navigate to the folder for your database type.
2. Open the corresponding markdown file.
3. Follow the commands to connect, create structures, insert/query data, and reset experiments.
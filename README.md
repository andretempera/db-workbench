# DB Workbench

`db-workbench` is a **plug-and-play, lightweight, local database playground and library** for experimenting with multiple SQL and NoSQL engines in isolation.

Designed for **learning, testing, and hands-on experimentation**, it spins up containers or file-based databases quickly and safely, removing the friction of manual setup.

It provides a **unified, user-friendly interface** for starting databases, connecting via CLI or GUI, resetting environments, and testing ideas without needing to remember long Docker commands or database-specific configuration steps.

This project is built for convenient, isolated local experimentation. It intentionally avoids orchestration and cross-database interaction, and it is not a production-ready infrastructure setup.


## Requirements

- Docker Engine  
  - Docker Desktop (macOS/Windows)  
  - Docker Engine + Compose plugin (Linux)
- Python 3.10+
- `make`
- Optional: DBeaver (or any other DB client)


## Quick Start
```bash
git clone https://github.com/andretempera/db-workbench.git
cd db-workbench
cp .env.example .env

python3 -m venv .venv
source .venv/bin/activate      # macOS/Linux
# or
venv\Scripts\activate         # Windows

pip install -r requirements.txt

make up-postgres
```

Then connect via:
- `make cli-postgres`
- pgAdmin at http://localhost:5050 (default)
- DBeaver (Or any other DB client)

After `make up-<database_name>`, you can query the `db_workbench` workspace (database, bucket, or index) to find a pre-populated test row for quick verification.

This quickstart example refers to `postgres`, but you can use any other database the same way via `make` commands.


## Philosophy

`db-workbench` is built around a simple idea: make spinning up and experimenting with databases frictionless. The project intentionally avoids over-engineering and complex orchestration in favor of transparent Docker configurations and predictable local file structures.

Designed to provide quick, functional access to multiple databases, `db-workbench` abstracts the repetitive parts of setup behind a consistent `make` interface. Starting or resetting an engine feels the same whether you're using PostgreSQL, MongoDB, or Redis. At the same time, everything remains transparent: Docker configurations, volumes, environment variables, and full commands are always available and inspectable.

Each database runs independently and is treated as its own controlled environment. There is no orchestration layer and no cross-database interaction by design. The focus is depth, not connectivity, and the ability to explore one engine at a time, safely, predictably, and while keeping the process frictionless.

`db-workbench` is meant to be disposable, reproducible, and practical. Start it, experiment, break things, reset, and repeat. It is a workbench, not a platform.


## Databases

### Currently Supported:

| Type           | Database         | Web GUI           | Default Workspace   |
|----------------|------------------|-------------------|---------------------|
| File-Based     | SQLite           | —                 | db_workbench.db     |
| File-Based     | DuckDB           | —                 | db_workbench.duckdb |
| SQL            | PostgreSQL       | pgAdmin           | db_workbench        |
| SQL            | MySQL            | phpMyAdmin        | db_workbench        |
| SQL            | MariaDB          | phpMyAdmin        | db_workbench        |
| NoSQL          | MongoDB          | Mongo Express     | db_workbench:       |
| NoSQL          | Redis            | RedisInsight      | db_workbench        |
| NoSQL          | Cassandra        | —                 | db_workbench        |
| NoSQL          | Elasticsearch    | —                 | db_workbench        |
| NoSQL          | ClickHouse       | ClickHouse Web UI | db_workbench        |
| NoSQL          | Couchbase        | Couchbase Console | db_workbench        |  

### Technical Overview:

| Database      | Model        | Storage Style | Typical Use Case       |
|---------------|--------------|---------------|------------------------|
| SQLite        | Relational   | Row-based     | Lightweight apps       |
| DuckDB        | Relational   | Columnar      | Analytics / OLAP       |
| PostgreSQL    | Relational   | Row-based     | OLTP / Production apps |
| MySQL         | Relational   | Row-based     | Web applications       |
| MariaDB       | Relational   | Row-based     | MySQL-compatible apps  |
| MongoDB       | Document     | BSON          | Flexible schemas       |
| Redis         | Key-Value    | In-memory     | Caching / fast lookup  |
| Cassandra     | Wide-column  | Distributed   | High write throughput  |
| Elasticsearch | Search index | Inverted      | Full-text search       |
| ClickHouse    | Columnar     | Column-based  | Large-scale analytics  |
| Couchbase     | Document     | JSON          | Distributed apps       |



## Project Structure
```text
db-workbench/
├── Makefile
├── docker-compose.yaml
├── .env.example
├── .gitignore
├── README.md
├── LICENSE
├── SDK/
├── docs/
│   ├── CONTRIBUTING.md
│   ├── SETUP.md
│   └── cheatsheets/
│       ├── README.md
│       ├── file/
│       ├── sql/
│       └── nosql/
└── data/
    ├── postgres/
    ├── mysql/       
    ├── mariadb/
    ├── mongo/
    ├── redis/
    ├── cassandra/
    ├── elasticsearch/
    ├── clickhouse/
    ├── couchbase/
    ├── sqlite/
    └── duckdb/
```

Each database may include:
- `scripts/` → initialization or test scripts
- `schemas/` → schema definitions
- `backups/` → backups
- `logs/` → experimentation logs


## Features
**Project Highlights**
- Plug-and-play simplicity: spin up, access, and reset databases with a single command via the Makefile.
- Persistent local storage: Docker volumes for containerized databases and local files for SQLite/DuckDB.
- Organized per-database folder structure for scripts, schemas, backups, and logs.
- Unified configuration through `.env` for ports, users, and passwords.
- Single `docker-compose.yaml` file defining all included databases, simplifying startup and maintenance while still allowing per-engine CLI access.
- File-based databases integrated seamlessly into the same workflow.
- Clean `.gitignore` preserving project structure but ignoring database files.

**Data Persistence Model**
- Containerized databases use Docker named volumes.
- File-based databases store data inside `data/<database_name>/db/`.
- Backups should be created using proper dump/export tools.
- Raw engine files are intentionally not exposed to simplify usage and avoid permission issues.

**Additional Features**
- GUI support - built-in web GUIs for quick inspection.
- SDK support - built-in access to Python SDK CLI
- Full data sharing between access modes (CLI, SDK and GUI)
- Initialization scripts - pre-populated idempotent test tables to verify database functionality immediately.
- Safe experimentation - each database can be reset individually without affecting others.
- Extensible - adding new engines is straightforward via the unified compose file and folder structure.
- Comprehensive documentation and cheatsheets - each database has a ready-to-use reference for commands, workflows, and mental models to accelerate learning and experimentation.


## Makefile Commands
Each database may support:
```bash
make up-<database_name>       # Initializes database environment (container or file-based)
make down-<database_name>     # Stops Docker container
make cli-<database_name>      # Connects to database CLI
make sdk-<database_name>      # Connects to SDK Python CLI
make gui-<database_name>      # Connects to Web UI
make reset-<database_name>    # Removes all data in db/ folder and removes Docker container
```
On `make up-<database_name>` the initialization is automatic and no separate `make init` command is required.

**Warning:** Reset commands permanently delete database containers, volumes, and/or files. Use with caution.  

Databases can also be grouped by type: `file`, `sql`, `nosql` or `all`:
```bash
make up-<database_type>       # Initializes all databases of selected type
make down-<database_type>     # Stops all databases of selected type
make reset-<database_type>    # Resets all databases of selected type
```
**Warning:** Some databases (Cassandra, Elasticsearch, Couchbase) require more RAM. Running multiple heavy databases simultaneously may impact performance.  

For a quick reference of available commands, you can use the following:
```bash
make help                     # Shows all help commands
make help-<database_type>     # Shows help commands for all databases of selected type
make help-<database_name>     # Shows individual database help commands
```
A special `make doctor` command is also included to run a quick check for any issues with Docker, `.env`, `.venv` and ports.


## Initialization Scripts
Most databases include `init.*`  scripts to help you verify that the database is working properly. These scripts are optional, but they provide a minimal test table with one queryable row so you can confirm everything is functioning. 

**Key points:**
- Each database initializes a **default workspace called `db_workbench`** (or a similarly named bucket/index for NoSQL engines).
- The scripts automatically create a minimal test table/collection/bucket (`test`) inside `db_workbench` if it does not exist.
- A single test row is inserted for consistency: `id = 1`, `name = Andre`, `project = db-workbench`
- All scripts are idempotent - running them multiple times will not duplicate the test row.
- Scripts are automatically executed when you run `make up-<database_name>` for some engines or on CLI access for others.
- Location: `data/<database_name>/scripts/` (extensions vary: `.sql`, `.py`, `.js`, etc.)


## Setup
**1. Install Required Tools**
- Docker and Docker Compose
- Python 3
- Make

**2. Clone Repository**
```bash
git clone https://github.com/andretempera/db-workbench.git
cd db-workbench
```

**3. Create `.env`**
```bash
cp .env.example .env
```

You can customize ports, usernames and passwords.  
Defaults are safe for local experimentation.

**4. Create Virtual Environment (Required for SQLite & DuckDB)**
```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

## Connecting to Databases
**Using CLI**

The `make cli-<database_name>` commands provide access to each database CLI in a simple and direct way.  
Some examples:
```bash
make cli-sqlite
make cli-duckdb

make cli-postgres
make cli-mysql

make cli-cassandra
make cli-mongo
```

**Using SDK**

The `make sdk-<database_name>` commands allow access to each database SDK Python CLI for additional functionalities.  
Some examples:
```bash
make sdk-sqlite
make sdk-duckdb

make sdk-postgres
make sdk-mysql

make sdk-cassandra
make sdk-mongo
```

**Using Web GUIs**

A `make gui-<database_name>` command is included for convenience. Web GUIs, when available, are accessed through localhost and respective port:
- MariaDB → `http://localhost:<PHPMYADMIN_MARIADB_PORT>`
- MySQL → `http://localhost:<PHPMYADMIN_MYSQL_PORT>`
- PostgreSQL → `http://localhost:<PGADMIN_PORT>`
- Clickhouse →  `http://localhost:<CLICKHOUSE_PORT>`
- Couchbase →  `http://localhost:<COUCHBASE_PORT>/ui/index.html`
- MongoDB → `http://localhost:<MONGOEXPRESS_PORT>`
- Redis → `http://localhost:<REDISINSIGHT_PORT>`

**Using DBeaver (or similar DB clients)**
- Host: `localhost`
- Ports, usernames & passwords: defined in `.env`

DuckDB can connect directly to DBeaver by pointing it to the location of the `db_workbench.duckdb` in this project.  
For SQLite, it is not possible to access the same database file simultaneously from Windows and WSL. Use either:
- DBeaver inside WSL (recommended for scripts running in WSL), or
- Move, copy or create a new `*.db*` file to a Windows path and access it from Windows only.

While Community Edition works very well for SQL databases, connections to most NoSQL databases are only available in the PRO version


## Troubleshooting
- Use `make doctor` special command for a quick check before runnning a database.
- Ensure Docker is running before executing database `make` commands.
- Make sure you have copied `.env.example` to `.env`.
- Make sure you are running the database from `.venv`.
- If a port is already in use, modify it in `.env`.
- Check container logs:
```bash
docker compose logs <service_name>
```


## Roadmap – Future Additions
The current version focuses on lightweight, Docker-friendly databases suitable for local experimentation.  
As the project evolves, the following may be added:
- [ ] Neo4j – Graph database with official Docker image and web UI  
- [ ] InfluxDB – Time-series database with built-in UI  
- [ ] CockroachDB – Distributed SQL, easy single-node setup  
- [ ] ArangoDB – Multi-model database  
- [ ] OpenSearch – Elasticsearch-compatible search engine  
- [ ] TimescaleDB – PostgreSQL-based time-series extension  
- [ ] ScyllaDB – Cassandra-compatible high-performance database  
- [ ] Apache Solr – Search platform  
- [ ] YugabyteDB – Distributed PostgreSQL-compatible system  
- [ ] Microsoft SQL Server (Developer Edition)  
- [ ] IBM Db2 Community Edition  
- [ ] Oracle Database XE  


## Summary
DB Workbench is:
- Simple
- Reproducible
- Engine-focused
- Disposable
- Practical

It is an extensible database laboratory designed for local hands-on experimentation - not orchestration.

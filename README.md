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

Test any other database using the `make` commands.


## Philosophy

`db-workbench` is built around a simple idea: make spinning up and experimenting with databases frictionless. The project intentionally avoids over-engineering and complex orchestration in favor of transparent Docker configurations and predictable local file structures.

Designed to provide quick, functional access to multiple databases, `db-workbench` abstracts the repetitive parts of setup behind a consistent `make` interface. Starting or resetting an engine feels the same whether you're using PostgreSQL, MongoDB, or Redis. At the same time, everything remains transparent: Docker configurations, volumes, environment variables, and full commands are always available and inspectable.

Each database runs independently and is treated as its own controlled environment. There is no orchestration layer and no cross-database interaction by design. The focus is depth, not connectivity, and the ability to explore one engine at a time, safely, predictably, and while keeping the process frictionless.

`db-workbench` is meant to be disposable, reproducible, and practical. Start it, experiment, break things, reset, and repeat. It is a workbench, not a platform.


## Currently Supported Databases

| Type           | Database         | Web GUI         |
|----------------|------------------|-----------------|
| File-Based     | SQLite           | —               |
| File-Based     | DuckDB           | —               |
| SQL            | PostgreSQL       | pgAdmin         |
| SQL            | MySQL            | phpMyAdmin      |
| SQL            | MariaDB          | phpMyAdmin      |
| NoSQL          | MongoDB          | Mongo Express   |
| NoSQL          | Redis            | RedisInsight    |
| NoSQL          | Cassandra        | —               |
| NoSQL          | Elasticsearch    | —               |
| NoSQL          | ClickHouse       | —               |
| NoSQL          | Couchbase        | —               |


## Project Structure
```text
db-workbench/
├── Makefile
├── docker-compose.yaml
├── .env.example
├── .gitignore
├── README.md
├── LICENSE
├── docs/
│   ├── CONTRIBUTING.md
│   └── SETUP.md
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
- Initialization scripts - pre-populated test tables to verify database functionality immediately.
- Safe experimentation - each database can be reset individually without affecting others.
- Extensible - adding new engines is straightforward via the unified compose file and folder structure.


## Makefile Commands
Each database supports:
```bash
make up-<database_name>       # Initializes database environment (container or file-based)
make down-<database_name>     # Stops Docker container
make cli-<database_name>      # Connects to database CLI
make reset-<database_name>    # Removes all data in db/ folder and removes Docker container
```
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


## Initialization Scripts
Most databases include `init.*`  scripts to help you verify that the database is working properly. These scripts are optional, but they provide a minimal test table with one queryable row so you can confirm everything is functioning.

**Location**  
When available, init scripts are always located in `data/<database_name>/scripts/` folder. They can have several different extensions (`.py`, `.sql`, `.js`, etc.) depending on the database.

**Purpose**
- The script automatically creates a small test table (`test`) if it does not exist
- It inserts a single row with known values without duplicating it across multiple runs
- It provides a minimal setup for testing queries and GUI connections via `SELECT * FROM test;` statement or equivalent


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
**Using DBeaver (or similar DB clients)**
- Host: `localhost`
- Ports, usernames & passwords: defined in `.env`

**Using Web GUIs**
- PostgreSQL → `http://localhost:<PGADMIN_PORT>`
- MySQL/MariaDB → `http://localhost:<PHPMYADMIN_PORT>`
- MongoDB → `http://localhost:<MONGOEXPRESS_PORT>`
- Redis → `http://localhost:<REDISINSIGHT_PORT>`

**Using CLI (Examples)**
```bash
make cli-sqlite
make cli-duckdb-python
make cli-duckdb-docker

make cli-postgres
make cli-mysql

make cli-mongo
make cli-cassandra
```


## Troubleshooting
- Ensure Docker is running before executing `make` commands.
- If a port is already in use, modify it in `.env`.
- Check container logs:
```bash
docker compose logs <service_name>
```


## Roadmap – Future Database Additions
The current version focuses on lightweight, Docker-friendly databases suitable for local experimentation.  
As the project evolves, the following may be added (roughly ordered by feasibility):
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

It is an extensible database laboratory designed for local hands-on experimentation — not orchestration.

# DB Workbench

![Docker](https://img.shields.io/badge/docker-required-blue)
![Python](https://img.shields.io/badge/python-3.10+-blue)
![License](https://img.shields.io/badge/license-MIT-green)

> **A plug-and-play local database playground for experimenting with SQL and NoSQL engines using simple `make` commands.**

`db-workbench` is a lightweight local database playground for experimenting with multiple SQL and NoSQL engines in isolation.  
Designed for **learning, testing, and hands-on experimentation**, it spins up containerized or file-based databases quickly and safely, removing the friction of manual setup.

It provides a **unified interface** for starting databases, connecting via CLI or GUI tools, resetting environments, and testing ideas without needing to remember long Docker commands or database-specific configuration steps.

This project is built for **convenient, isolated local experimentation**. It intentionally avoids orchestration and cross-database interaction, and it is **not intended as a production infrastructure setup**.


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
source .venv/bin/activate

pip install -r requirements.txt

make up-postgres
make cli-postgres
```

You should now be connected to the PostgreSQL CLI.  
Test it using: `SELECT * FROM test;`


## Architecture Overview
```txt
                 User
                  │
          make <command>
                  │
                  ▼
             Makefile
                  │
                  ▼
           docker-compose
        ┌─────────┼─────────┐
        ▼         ▼         ▼
   Databases     SDKs     Web GUIs
 (Postgres,      Python    pgAdmin
  Mongo...)    containers  RedisInsight
        │
        ▼
   Persistent Storage
   ├─ Docker Volumes
   └─ data/<database>/
      (SQLite, DuckDB)
```
- `make` provides a unified interface for running database workflows
- `docker-compose` manages containerized databases and web GUIs
- File-based databases run locally through the Python environment
- Data persists via Docker volumes or local files


## Philosophy

`db-workbench` is built around a simple idea: make spinning up and experimenting with databases frictionless. The project intentionally avoids over-engineering and complex orchestration in favor of transparent Docker configurations and predictable local file structures.

To provide quick, functional access to multiple databases, `db-workbench` abstracts repetitive setup behind a consistent `make` interface. Starting or resetting an engine feels the same whether you're using PostgreSQL, MongoDB, or Redis. While the Makefile offers a convenient interface for common workflows, it is simply a thin layer over standard Docker, CLI, and database commands. Users are always free to interact directly with the underlying tools if they prefer.

Each database runs independently and is treated as its own controlled environment. There is no orchestration layer and no cross-database interaction by design. The focus is depth, not connectivity - exploring one engine at a time in a predictable and isolated way. At the same time, everything remains transparent: Docker configurations, volumes, environment variables, and full commands are always available and inspectable.

`db-workbench` is meant to be disposable, reproducible, and practical. Start it, experiment, break things, reset, and repeat. It is a workbench, not a platform.


## Non-Goals

This project intentionally does **not** aim to be:

- A production infrastructure platform
- A database orchestration system
- A benchmarking or performance testing framework
- A multi-database integration layer

Each database runs independently so you can explore and experiment with every engine in isolation.


## Databases

### Currently Supported:
| Type  | Database        | Web GUI           | Default Workspace   |
|-------|-----------------|-------------------|---------------------|
| File  | `DuckDB`        | —                 | `db_workbench.duckdb` |
| File  | `SQLite`        | —                 | `db_workbench.db`     |
| SQL   | `MariaDB`       | phpMyAdmin        | `db_workbench`        |
| SQL   | `MySQL`         | phpMyAdmin        | `db_workbench`        |
| SQL   | `PostgreSQL`    | pgAdmin           | `db_workbench`        |
| NoSQL | `Cassandra`     | —                 | `db_workbench`        |
| NoSQL | `ClickHouse`    | ClickHouse Web UI | `db_workbench`        |
| NoSQL | `Couchbase`     | Couchbase Console | `db_workbench`        |  
| NoSQL | `Elasticsearch` | Kibana            | `db_workbench`        |
| NoSQL | `MongoDB`       | Mongo Express     | `db_workbench`        |
| NoSQL | `Redis`         | RedisInsight      | `db_workbench`        |

### Technical Overview:
| Database        | Model       | Storage      | Typical Use Case       |
|-----------------|-------------|--------------|------------------------|
| `DuckDB`        | Relational  | Columnar     | Analytics / OLAP       |
| `SQLite`        | Relational  | Row-based    | Lightweight apps       |
| `MariaDB`       | Relational  | Row-based    | MySQL-compatible apps  |
| `MySQL`         | Relational  | Row-based    | Web applications       |
| `PostgreSQL`    | Relational  | Row-based    | OLTP / production apps |
| `Cassandra`     | Wide-column | Distributed  | High write throughput  |
| `ClickHouse`    | Columnar    | Column-based | Large-scale analytics  |
| `Couchbase`     | Document    | JSON         | Distributed apps       |
| `Elasticsearch` | Search      | Inverted     | Full-text search       |
| `MongoDB`       | Document    | BSON         | Flexible schemas       |
| `Redis`         | Key-Value   | In-memory    | Caching / fast lookup  |


## Project Structure

- `Makefile` → centralized commands to start/connect/reset databases  
- `docker-compose.yaml` → container definitions  
- `SDK/` → Python CLI Dockerfiles for all databases  
- `data/` → per-database folders for scripts, schemas, backups, and logs
- `docs/cheatsheets` → quick-start documentation with basic commands for all databases

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
make gui-<database_name>      # Connects to Web UI
make sdk-<database_name>      # Connects to SDK Python CLI
make reset-<database_name>    # Removes all data and containers
```
The implementation of initialization scripts is automatic and no separate `make init` command is required.

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
All databases include **initialization scripts** to help you verify that the database is working properly.

**Key points:**
- Each database creates a **default workspace** called `db_workbench` (or a similarly named bucket/index for NoSQL engines).
- A minimal test table/collection/bucket named `test` is automatically created if it doesn’t exist.
- A single test row is inserted consistently: `id = 1`, `name = Andre`, `project = db-workbench`.
- Scripts are **idempotent** — running them multiple times will not duplicate the test row.
- Scripts are automatically executed when running `make up-<database_name>` or on CLI/GUI/SDK access, depending on the engine.

**Location:**  
`data/<database_name>/scripts/` — extensions vary by engine (e.g., `.sql`, `.py`, `.js`).

These scripts make it easy to **verify functionality immediately**, allowing users to query pre-existing test data.


## Setup
**1. Install Required Tools**
- Docker and Docker Compose
- Python 3
- Make

> These tools are necessary for containerized databases, CLI commands, and running the SDK.

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
```

Activate the virtual environment:
- macOS/Linux:
```bash
source .venv/bin/activate
```

- Windows (PowerShell):
```bash
.\venv\Scripts\Activate.ps1
```

- Windows (Command Prompt):
```bash
venv\Scripts\activate.bat
```

Install the required Python packages:
```bash
pip install -r requirements.txt
```

**Note:** Once setup is complete, you can start a database quickly using the Makefile commands, e.g.:
```bash
make up-postgres
```


## Connecting to Databases

After starting databases with the `make up-<database_name>` command, you will need to connect in order to work with them.  
You can interact with databases in four main ways: **CLI**, **Web GUI**, **SDK**, or **external clients** like DBeaver.

**1. Using CLI**

Access each database CLI via the Makefile:
```bash
# Examples
make cli-duckdb
make cli-sqlite

make cli-mysql
make cli-postgres

make cli-cassandra
make cli-mongo
```
Once inside, you can query the pre-populated `test` table/collection/bucket in the `db_workbench` workspace.

**2. Using Web GUIs**
Some databases provide web GUIs for easier inspection. When available, are accessible through the `make gui-<database_name>` command or directly clicking on the service port link in Docker Desktop.
| Database      | GUI               | URL                                               |
|---------------|-------------------|---------------------------------------------------|
| MariaDB       | phpMyAdmin        | `http://localhost:<PHPMYADMIN_MARIADB_PORT>`      |
| MySQL         | phpMyAdmin        | `http://localhost:<PHPMYADMIN_MYSQL_PORT>`        |
| PostgreSQL    | pgAdmin           | `http://localhost:<PGADMIN_PORT>`                 |
| ClickHouse    | ClickHouse UI     | `http://localhost:<CLICKHOUSE_PORT>`              |
| Couchbase     | Couchbase Console | `http://localhost:<COUCHBASE_PORT>/ui/index.html` |
| Elasticsearch | Kibana            | `http://localhost:<KIBANA_PORT>`                  |
| MongoDB       | Mongo Express     | `http://localhost:<MONGOEXPRESS_PORT>`            |
| Redis         | RedisInsight      | `http://localhost:<REDISINSIGHT_PORT>`            |

**3. Using SDK**

The `make sdk-<database_name>` commands allow access to each database SDK Python CLI for additional functionalities.  
```bash
# Examples
make sdk-duckdb
make sdk-sqlite

make sdk-mysql
make sdk-postgres

make sdk-cassandra
make sdk-mongo
```
Each SDK runs in a dedicated container with the database workspace pre-configured.

**4. Using DBeaver (or similar DB clients)**
- Host: `localhost`
- Ports, usernames & passwords: defined in `.env`

Notes:
- DuckDB: point DBeaver directly to the db_workbench.duckdb file
- SQLite: cannot simultaneously access the same file from Windows and WSL — choose one environment
- Community Edition works well for SQL databases; NoSQL databases may require Pro version


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
While `db-workbench` currently focuses on lightweight, Docker-friendly databases, future directions may include:
- Enhanced SDK functionality across all engines
- Additional example workflows and tutorials
- More pre-populated datasets for learning and experimentation
- Improved cross-platform support (Windows, macOS, Linux/WSL)
- Optional GUI enhancements for file-based engines
- Support for additional database engine types (SQL, NoSQL, time-series, graph, search)


## Summary
`db-workbench` is a **simple, reproducible, and engine-focused local database playground**.  

It is designed for **hands-on experimentation**, learning, and testing, providing:

- **Independent, isolated environments** for each database
- **Quick start and reset workflows** via the Makefile or direct CLI/SDK commands
- **Pre-populated test data** for immediate verification
- **Support for multiple SQL and NoSQL engines** in one unified workspace

`db-workbench` is **disposable, practical, and extensible** — start it, experiment, break things, reset, and repeat. It is a **workbench, not a platform**, focused on enabling exploration, not production orchestration.

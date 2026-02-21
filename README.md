# Local Databases

A lightweight, self-contained **local database playground** for experimenting with multiple SQL and NoSQL databases. 

Designed for **learning, testing, and experimentation** - spin up containers or file-based databases quickly and safely.

You don’t need to know Docker or database CLI syntax to get started - just use `make up-*` and `make cli-*` commands.

> This project is intended for convenient local experimentation and learning.  
> It is **not** a production-ready infrastructure setup.

## Quick Start

```bash
git clone https://github.com/andretempera/local-databases.git
cd local-databases
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
- DBeaver
- Or any database client

Test any other database using the `make` commands.

## Requirements

- Docker Engine  
  - Docker Desktop (macOS/Windows)  
  - Docker Engine + Compose plugin (Linux)
- Python 3.10+
- `make`
- Optional: DBeaver (or any DB client)

## Philosophy

`local-databases` is built around a simple idea: make spinning up and experimenting with databases frictionless. The project intentionally avoids over-engineering and complex orchestration in favor of transparent Docker configurations and predictable local file structures.

`local-databases` is designed to provide quick, functional access to multiple databases. It is not intended to teach Docker usage or the specifics of database CLI commands. Most of the setup and long commands are abstracted via the Makefile to let you focus on experimenting, learning, and testing databases rather than infrastructure details.

It is not meant to replicate production environments or provide hardened infrastructure. Instead, it serves as a practical sandbox for exploring SQL and NoSQL systems, testing schema designs, learning engine-specific behavior, and comparing tooling across ecosystems.

Simplicity and reproducibility take precedence over feature completeness.  
If a database can be launched, inspected, modified, and discarded easily, it fits the spirit of this project.

## Features

### Data Persistence Model

- Containerized databases use Docker named volumes
- File-based databases store files inside data/
- Backups should be created using dump/export tools
- Raw container engine files are not exposed intentionally

### Supported Databases

**SQL**
- PostgreSQL  
- MySQL  
- MariaDB  

**NoSQL**
- MongoDB  
- Redis  
- Cassandra  
- Elasticsearch  
- ClickHouse  
- Couchbase  

**File-Based**
- SQLite  
- DuckDB  

### Web GUIs

- PostgreSQL → pgAdmin  
- MySQL / MariaDB → phpMyAdmin  
- MongoDB → Mongo Express  
- Redis → RedisInsight  

### Project Highlights

- Persistent local storage via Docker volumes
- Organized per-database folder structure
- One-command startup/shutdown via Makefile
- `.env` configuration for ports, users, and passwords
- File-based databases integrated into the same workflow
- Clean `.gitignore` preserving structure but ignoring DB files

## Project Structure

```text
local-databases/
├── Makefile
├── docker-compose.yaml
├── .env.example
├── .gitignore
├── README.md
├── CONTRIBUTING.md
├── LICENSE
├── docs/
│   ├── CONTRIBUTING.md
│   └── SETUP.md
└── data/
    ├── postgres/
    │   ├── scripts/
    │   ├── schemas/
    │   ├── backups/
    │   └── logs/
    ├── mysql/
    ├── mariadb/
    ├── mongo/
    ├── redis/
    ├── cassandra/
    ├── elasticsearch/
    ├── clickhouse/
    ├── couchbase/
    ├── sqlite/
    │   ├── db/               # database.db
    │   └── scripts/
    └── duckdb/
        ├── db/               # database.duckdb
        └── scripts/
```

Each database has:

- `scripts/` → initialization or test scripts
- `schemas/` → schema definitions
- `backups/` → backups
- `logs/` → experimentation logs

For containerized databases, actual engine data is stored in Docker-managed volumes.

For file-based databases (SQLite, DuckDB), the `db/` folder contains the database files.

## Setup

### 1. Install Required Tools

- Docker and Docker Compose
- Python 3
- Make

### 2. Clone Repository

```bash
git clone https://github.com/andretempera/local-databases.git
cd local-databases
```

### 3. Create `.env`

```bash
cp .env.example .env
```

You can customize:
- Ports
- Usernames
- Passwords

Defaults are safe for local experimentation.

### 4. Create Virtual Environment (Required for SQLite & DuckDB)

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

## 🛠 Makefile Usage

### Individual Databases

```bash
make up-postgres
make down-postgres

make up-mysql
make down-mysql

make up-mongo
make down-mongo

make up-sqlite
make down-sqlite

make up-duckdb
make down-duckdb
```

### Web GUIs

```bash
make up-pgadmin
make down-pgadmin

make up-phpmyadmin
make down-phpmyadmin

make up-mongo-express
make down-mongo-express

make up-redis-insight
make down-redis-insight
```

### Grouped Databases

```bash
make up-sql
make down-sql

make up-nosql
make down-nosql
```

> **Note:** Some databases (Cassandra, Elasticsearch, Couchbase) require more RAM.  
Running multiple heavy databases simultaneously may impact performance.

## Connecting to Databases

### Using DBeaver

- Host: `localhost`
- Port: defined in `.env`
- Username & password: defined in `.env.example`

### Using Web GUIs

- PostgreSQL → `http://localhost:<PGADMIN_PORT>`
- MySQL/MariaDB → `http://localhost:<PHPMYADMIN_PORT>`
- MongoDB → `http://localhost:<MONGOEXPRESS_PORT>`
- Redis → `http://localhost:<REDISINSIGHT_PORT>`

## File-Based Databases

- SQLite → `data/sqlite/db/database.db`
- DuckDB → `data/duckdb/db/database.duckdb`

SQLite is created automatically via `make up-sqlite`.

DuckDB can be created using:
```bash
make up-duckdb        # start DuckDB (Docker CLI session or Python script)
make duckdb-python    # open DuckDB via Python API
make duckdb-docker    # open DuckDB via Docker CLI
```

## Resetting Databases

If you want to start fresh, you can remove containers, volumes, or file-based database files:
```bash
# Individual Databases
make reset-postgres
make reset-mysql
make reset-mariadb
make reset-mongo
make reset-redis
make reset-cassandra
make reset-elasticsearch
make reset-clickhouse
make reset-couchbase
make reset-sqlite
make reset-duckdb

# Grouped Resets
make reset-file     # Reset all file based databases
make reset-sql      # Reset all SQL databases
make reset-nosql    # Reset all NoSQL databases
make reset-all      # Reset everything
```

**Warning:** These commands permanently delete database containers, volumes, and/or files. Use with caution.

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

## 📜 License

MIT License

## Contributing

At this stage, this is a personal learning project and pull requests are not being accepted.

However, feedback, ideas, and bug reports are welcome via GitHub Issues.

## Summary

`local-databases` is a plug-and-play local database playground:

- Clone repo  
- Copy `.env`  
- `make up-<database_name>`  
- Connect via GUI or client  
- Experiment freely  

Containerized databases use Docker-managed volumes for reliable cross-platform persistence without any filesystem permission issues.
File-based databases (SQLite, DuckDB) store data in `data/<database_name>/db/`.

Simple. Reproducible. Disposable.
# Local Databases

A lightweight, self-contained **local database playground** for experimenting with multiple SQL and NoSQL databases. Designed for **learning, testing, and experimentation** — spin up containers or file-based databases quickly and safely.

This project is intended for convenience, local experimentation and learning. It is not a production-ready infrastructure.

## 🚀 Quick Start

```bash
git clone https://github.com/andretempera/local-databases.git
cd local-databases
cp .env.example .env
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
make up-postgres
```

## Features

- Includes major SQL and NoSQL databases:
  - **SQL:** PostgreSQL, MySQL, MariaDB  
  - **NoSQL:** MongoDB, Redis, Cassandra, Elasticsearch, ClickHouse, Couchbase  
  - **File-based:** SQLite, DuckDB
- Web GUIs for easier interaction:
  - PostgreSQL → pgAdmin  
  - MySQL/MariaDB → phpMyAdmin  
  - MongoDB → Mongo Express  
  - Redis → RedisInsight
- Persistent local storage via Docker volumes (`data/<database>/db`) or file-based DBs (`database.db`, `database.duckdb`)  
- Organized structure per database:
  - `db/` → actual database or Docker volume  
  - `scripts/` → initialization or test scripts  
  - `schemas/` → schema definitions  
  - `backups/` → backups  
  - `logs/` → logs for experimentation
- Makefile for **one-command startup/shutdown** of individual or grouped databases  
- `.env.example` for customizable ports, passwords, and usernames  

## Project Structure

```text
local-databases/
├── Makefile                  # Commands to start/stop DBs
├── docker-compose.yaml       # Docker Compose definitions
├── .gitignore                # Ignores DB files but preserves folder structure
├── .env.example              # Template for configurable env variables
├── README.md                 # This file
└── data/
    ├── postgres/
    │   ├── db/
    │   ├── scripts/
    │   ├── schemas/
    │   ├── backups/
    │   └── logs/
    ├── mysql/
    │   └── ...
    ├── mariadb/
    │   └── ...
    ├── mongo/
    │   └── ...
    ├── redis/
    │   └── ...
    ├── cassandra/
    │   └── ...
    ├── elasticsearch/
    │   └── ...
    ├── clickhouse/
    │   └── ...
    ├── couchbase/
    │   └── ...
    ├── sqlite/
    │   ├── db/               # database.db
    │   └── scripts/          # create_db.py
    └── duckdb/
        ├── db/               # database.duckdb
        └── scripts/          # create_db.py
```

## Setup

**1. Install required tools:**

- Docker and Docker Compose

- Python 3 (for SQLite and DuckDB)

- Optional: DBeaver for connecting to all DBs

**2. Clone the repository:**
```bash
git clone https://github.com/andretempera/local-databases.git
cd local-databases
```

**3. Create your .env from the example:**

`cp .env.example .env`

- `.env` defines ports, passwords, and usernames for each database.

- Defaults are safe for local experimentation.

**4. Create a Python virtual environment and install requirements:**
```bash
python3 -m venv .venv
source .venv/bin/activate      # macOS/Linux
# or
venv\Scripts\activate         # Windows

pip install -r requirements.txt
```

The virtual environment is required to run the SQLite and DuckDB scripts (make up-sqlite and make up-duckdb).

## Makefile Usage
**Individual databases**
```bash
make up-postgres      # start PostgreSQL
make down-postgres    # stop PostgreSQL

make up-mysql         # start MySQL
make down-mysql       # stop MySQL

make up-mongo         # start MongoDB
make down-mongo       # stop MongoDB

make up-sqlite        # create SQLite DB file
make down-sqlite      # file-based, no container to stop

make up-duckdb        # create DuckDB file
make down-duckdb      # file-based, no container to stop
```

**Web GUIs**
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

**Grouped databases**
```bash
make up-sql           # start all SQL databases
make down-sql         # stop all SQL databases

make up-nosql         # start all NoSQL databases
make down-nosql       # stop all NoSQL databases
```

## Connecting to Databases

- DBeaver: connect to any database using the host localhost and the ports in .env.

- Web GUIs:

  - PostgreSQL → http://localhost:<PGADMIN_PORT>

  - MySQL/MariaDB → http://localhost:<PHPMYADMIN_PORT>

  - MongoDB → http://localhost:<MONGOEXPRESS_PORT>

  - Redis → http://localhost:<REDISINSIGHT_PORT>

Default credentials for experimentation are safe (root / password or rootpass) and defined in .env.example.

## Notes

- SQLite & DuckDB are file-based: data/sqlite/db/database.db and data/duckdb/db/database.duckdb.

- All other databases run in Docker containers.

- Folders `scripts/`, `schemas/`, `backups/`, and `logs/` are per-database and not versioned in Git (except .gitkeep to preserve structure).

- You can customize ports, users, and passwords via .env without editing docker-compose.yaml.

# Git & Versioning

- `.gitignore` is set to ignore all database files (`db/`), logs, and backups but keeps folder structure.

- You can safely commit scripts, schemas, and Docker configuration files.

## Summary

`local-databases` is a plug-and-play local DB playground:

- Clone repo → copy .env

- make up-<database> → start containers or create DB files

- Connect via web GUI or DBeaver

- Experiment freely; all data is persisted in data/<database>/db/

Perfect for learning SQL/NoSQL, testing queries, or exploring multiple DB engines simultaneously.


## 🗺️ Roadmap – Future Database Additions

The current version focuses on lightweight, Docker-friendly databases suitable for local experimentation.

As time permits and the project evolves, the following additional databases may be added (ordered roughly by feasibility):

- [ ] **Neo4j** – Popular graph database with official Docker image and web UI.
- [ ] **InfluxDB** – Time-series database, Docker-friendly with built-in UI.
- [ ] **CockroachDB** – Distributed SQL database, easy single-node Docker setup.
- [ ] **ArangoDB** – Multi-model (document + graph + key-value), lightweight and Docker-ready.
- [ ] **OpenSearch** – Elasticsearch-compatible search engine, moderate resource usage.
- [ ] **TimescaleDB** – PostgreSQL-based time-series extension, simple Docker integration.
- [ ] **ScyllaDB** – High-performance Cassandra-compatible database, requires more RAM.
- [ ] **Apache Solr** – Java-based search platform, needs JVM tuning.
- [ ] **YugabyteDB** – Distributed PostgreSQL-compatible system, multi-service architecture.
- [ ] **Microsoft SQL Server (Developer Edition)** – Enterprise RDBMS, heavier resource requirements.
- [ ] **IBM Db2 Community Edition** – Enterprise database, large image and license configuration.
- [ ] **Oracle Database XE** – Enterprise database, large image and more complex setup.
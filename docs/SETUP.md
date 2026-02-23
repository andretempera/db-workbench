# Setup

This guide walks you through installing requirements, starting databases, verifying initialization, and connecting to the engines included in **db-workbench**.

> All usernames, passwords, and ports referenced below use the defaults from `.env.example`.  
> If you modify `.env`, adjust values accordingly.


## Requirements
### Docker
Required for all containerized databases.  
Install:
- Windows / macOS → Docker Desktop
- Linux → Docker Engine + Compose plugin via your package manager

Verify:
```bash
docker --version
docker compose version
```

### Python 3.10+
Required for:
- File-based databases (SQLite, DuckDB)
- Initialization scripts

Install:
- Windows / macOS → python.org
- Linux → `apt install python3 python3-venv` (or equivalent)

Verify:
```bash
python3 --version
pip3 --version
```

### Git
Required to clone the repository.  
Verify:
```bash
git --version
```

### Make
Used to run all project commands via the Makefile.  
Verify:
```bash
make --version
```

Install:
- Windows → Chocolatey or WSL
- macOS → `brew install make`
- Linux → `apt install make` (or equivalent)

### Optional: DBeaver
Universal database GUI client.  
Download: https://dbeaver.io/download/  
Community Edition is sufficient.


## Installation
### 1. Clone Repository
```bash
git clone https://github.com/andretempera/db-workbench.git
cd db-workbench
```

### 2. Create `.env`
```bash
cp .env.example .env
```
Defaults are safe for local experimentation.    
You may customize ports, usernames, and passwords if needed.


### 3. Create Python Virtual Environment
Required for SQLite and DuckDB support.
```bash
python3 -m venv .venv
```
macOS / Linux:
```bash
source .venv/bin/activate
```
Windows:
```bash
.venv\Scripts\activate
```
Then install dependencies:
```bash
pip install -r requirements.txt
```

## Starting Databases
Start an individual database:
```bash
make up-postgres
make up-mongo
make up-sqlite
make up-duckdb
```
When you run `make up-<database_name>`, initialization scripts are executed automatically. No separate `make init` step is required.

Start all databases by type:
```bash
make up-sql
make up-nosql
make up-file
make up-all
```
Stop databases:
```bash
make down-postgres
make down-sql
make down-all
```
Reset databases:
```bash
make reset-postgres
make reset-nosql
make reset-all
```
**Warning:** This is a destructive operation. Reset commands permanently delete containers, volumes, and/or database files.

Special command:
```bash
make doctor
```
This will check for issues with Docker, `.env`, `.venv` and ports.

### Quick Verification
After `make up-<database_name>` you can now run:
```bash
# SQL example
SELECT * FROM test;

# MongoDB example
db.test.find();

# Redis example
GET db_workbench:test:1;

# Elasticsearch example
GET /test/_doc/1;

# Couchbase example
collection.get("test:1")
```

### Cheatsheets
If you need help getting started with any database, you can find cheatsheets for all databases in `docs/cheatsheets` containing the most common commands.


## Initialization Scripts (What to Expect)
Most databases include a minimal initialization script that runs on first startup of the container or database file.    
It will:
- Default to a workspace called `db_workbench`** (or a similarly named bucket/index for NoSQL engines).
- Automatically create a table/collection/bucket named `test` (if it does not exist).
- Insert a single test row: `id = 1`, `name = Andre`, `project = db-workbench`
- Avoid duplicate inserts across repeated runs.
- Automatically execute on `make up-<database_name>`.

This allows you to immediately verify the database is functioning correctly.

Example (SQL engines):
```bash
make cli-postgres
SELECT * FROM test;
```

Expected output:
```
 id | name  |     project
----+-------+---------------
  1 | Andre | db-workbench
(1 row)
```

Example (DuckDB Python CLI):
```bash
make cli-duckdb-python
conn.execute("SELECT * FROM test").fetchall()
```
Expected output:
```
[(1, 'Andre', 'db-workbench')]
```
If the row exists, the database is working properly.


## CLI Access
Access database shells directly:
```bash
make cli-postgres       # defaults to db_workbench database
make cli-mysql          # defaults to db_workbench database
make cli-mongo          # defaults to db_workbench database/bucket
make cli-redis          # defaults to db_workbench key prefix
make cli-sqlite
make cli-duckdb-python
make cli-duckdb-docker
```
**Note:** All databases initialize a default workspace called db_workbench (or equivalent for NoSQL engines) with a minimal test row already present.

## Web GUI Connections
Ensure:
- Docker is running
- The relevant database container is started

### PostgreSQL / pgAdmin
`http://localhost:<PGADMIN_PORT>`

Login: `admin@admin.com / rootpass`

Inside pgAdmin:
Create → Server → Connection:
- Host: `postgres`
- Port: `5432`
- Username: `postgres`
- Password: `rootpass`

### MySQL / MariaDB / phpMyAdmin
`http://localhost:<PHPMYADMIN_MYSQL_PORT>`
or
`http://localhost:<PHPMYADMIN_MARIADB_PORT>`

Login: `root / rootpass`

### MongoDB / Mongo Express
`http://localhost:<MONGOEXPRESS_PORT>`

Login: `root / rootpass`

### Redis / RedisInsight
`http://localhost:<REDISINSIGHT_PORT>`

Use password defined in `.env`.

### ClickHouse / ClickHouse Web UI
`http://localhost:<CLICKHOUSE_PORT>`

Login not required.  
The default workspace `db_workbench` is pre-created with a test row.

### Couchbase / Couchbase Console
`http://localhost:<COUCHBASE_PORT>`

Login: `Administrator / rootpass`

Default bucket: `db_workbench`

## Working with Local Databases in the Project
### 1. File-Based Databases (SQLite & DuckDB)
These databases live as files (`db_workbench.db` for SQLite, `db_workbench.duckdb` for DuckDB).  
Initialization & CLI: Use Makefile commands (e.g., `make up-sqlite`, `make cli-sqlite`).

DBeaver can connect to DuckDB by creating a new connection and pointing to the `db_workbench.duckdb` file.  
SQLite uses file-level locking. If the database file is accessed from WSL, it cannot safely be opened simultaneously from Windows. It is only possible to connect DBeaver to SQLite when both DBeaver and the `db_workbench.db` file are running on the same system:
- If project's `db_workbench.db` is on WSL then DBeaver needs to also run in WSL
```bash
sudo snap install dbeaver-ce
dbeaver-ce
```
- If DBeaver is installed on Windows, then the `db_workbench.db` file needs to be on Windows


### 2. SQL Databases (Postgres, MySQL, MariaDB)
Initialization & CLI: Use Makefile commands (e.g., `make up-postgres`, `make cli-postgres`).  

DBeaver can connect using the corresponding `.env` variables (e.g., `POSTGRES_*`, `MYSQL_*`, `MARIADB_*`).

All SQL databases are server-based, so concurrent access is safe.

### 3. NoSQL Databases (MongoDB, Redis, Cassandra, Elasticsearch, ClickHouse, Couchbase)

Initialization & CLI: Use Makefile commands (e.g., `make up-mongo`, `make cli-mongo`).

Connect via DBeaver or the respective GUI if supported (MongoDB, Redis).

### 4. General Recommendations

**File-Based DBs:** For SQLite, use the included CLI only (recommended). For DuckDB, use either the CLI (Python/Docker) or DBeaver.

**Server-Based DBs (SQL / NoSQL):** Safe to access from DBeaver, Python scripts, and Docker simultaneously.

**Documentation Tip:** Always include `.env` credentials and ports to make client connections straightforward.


## Makefile Help
The Makefile is self-documenting.  
Show all commands:
```bash
make help
```
Show grouped commands:
```bash
make help-file
make help-sql
make help-nosql
```
Show commands for a specific database:
```bash
make help-<database_name>
```

## Troubleshooting
You should use the `make doctor` special command for a quick check before running a database. If a warning is triggered:
- Ensure Docker is running
- Ensure you have copied `.env.example` to `.env`
- Ensure you are running from `.venv` and have installed requirements
- Ensure required ports in `.env` are not already in use
- Check container logs:
```bash
docker compose logs <service_name>
```
- Ensure you are using the correct commands:
```bash
make help-<database_name>
```

If a container fails to start, it is usually due to:
- Port conflicts
- Insufficient RAM (Cassandra, Elasticsearch, Couchbase are heavier)
- Docker not running

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


## Initialization Scripts (What to Expect)
Most databases include a minimal initialization script that runs on first startup of the container or database file.    
It will:
- Create a table named `test` (if it does not exist)
- Insert a single row:
  - `id = 1`
  - `name = 'Andre'`
  - `project = 'db-workbench'`
- Avoid duplicate inserts across repeated runs

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
make cli-postgres
make cli-mysql
make cli-mongo
make cli-redis
make cli-sqlite
make cli-duckdb-python
make cli-duckdb-docker
```
CLI commands initialize on the default database when possible.

## Web GUI Connections
Ensure:
- Docker is running
- The relevant database container is started

### PostgreSQL / pgAdmin
`http://localhost:<PGADMIN_PORT>`

Default login:
```
admin@admin.com
rootpass
```

Inside pgAdmin:
Create → Server → Connection:
- Host: postgres
- Port: 5432
- Username: postgres
- Password: rootpass

### MySQL / MariaDB / phpMyAdmin
`http://localhost:<PHPMYADMIN_PORT>`

Login:
```
root / rootpass
```

### MongoDB / Mongo Express
`http://localhost:<MONGOEXPRESS_PORT>`

Login:
```
root / rootpass
```

### Redis / RedisInsight
`http://localhost:<REDISINSIGHT_PORT>`

Use password defined in `.env`.

### Couchbase
`http://localhost:<COUCHBASE_PORT>`

Login:
```
Administrator / rootpass
```

## Connecting via DBeaver (or Other Clients)

For containerized databases:
- Host: `localhost`
- Port, username & password: defined in `.env`

For file-based databases:
- SQLite → `data/sqlite/db/database.db`
- DuckDB → `data/duckdb/db/database.duckdb`

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
If something does not work:
- Ensure Docker is running
- Ensure required ports in `.env` are not already in use
- Check container logs:
```bash
docker compose logs <service_name>
```
- Confirm available commands:
```bash
make help-<database_name>
```

If a container fails to start, it is usually due to:
- Port conflicts
- Insufficient RAM (Cassandra, Elasticsearch, Couchbase are heavier)
- Docker not running

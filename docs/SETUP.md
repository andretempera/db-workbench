# Setup

This guide walks you through setting up the **local-databases** project, installing required software, using CLI commands, running init scripts, and connecting to all included databases via Web GUIs and DBeaver.

> All referenced usernames, passwords, and ports below are **defaults from `.env.example`**.  
> If you change anything in `.env`, update accordingly.


## Requirements

### Docker
Docker is required to run all containerized databases.

**Installation:**

- Windows / macOS: Docker Desktop  
- Linux: Install Docker Engine + Compose plugin via your distro’s package manager

**Verify installation:**

`docker --version`

`docker compose version`


### Python 3.10+
Python is required for:
- File-based databases (SQLite, DuckDB)
- Initialization scripts

**Install:**
- Windows / macOS: python.org downloads
- Linux: apt install python3 python3-venv (or equivalent)

**Verify installation:**

`python3 --version`

`pip3 --version`


### Git
Required to clone the repository.

**Verify installation:**

`git --version`


### Make
Used to run all database commands via the Makefile.

**Verify installation:**

`make --version`

**Install:**
- Windows: via Chocolatey or WSL
- macOS: brew install make
- Linux: apt install make (or equivalent)


### Optional: DBeaver
Universal database GUI client.

**Download:**

https://dbeaver.io/download/

Community Edition is sufficient.


## Setup Steps
1. Clone Repository
```bash
git clone https://github.com/andretempera/local-databases.git
cd local-databases
```


2. Create .env file
```bash
cp .env.example .env
```

Defaults are safe for local experimentation.


3. Create Python Virtual Environment (Required for SQLite & DuckDB)
```bash
python3 -m venv .venv
```

&nbsp; &nbsp; &nbsp; macOS/Linux:
```bash
source .venv/bin/activate
```

&nbsp; &nbsp; &nbsp; Windows:
```bash
.venv\Scripts\activate

pip install -r requirements.txt
```


## Makefile Help Commands
The Makefile includes built-in help commands.

Show everything:
```bash
make help
```

Show grouped commands:
```bash
make help-file
make help-sql
make help-nosql
```

Show individual database commands:
```bash
make help-sqlite
make help-duckdb
make help-postgres
make help-mysql
make help-mariadb
make help-mongo
make help-redis
make help-cassandra
make help-elasticsearch
make help-clickhouse
make help-couchbase
```

Each individual help command shows:
- up-<database_name>
- cli-<database_name>
- down-<database_name>
- reset-<database_name>


## Starting Databases
Individual examples:
```bash
make up-postgres
make up-mongo
make up-sqlite
make up-duckdb
```

Grouped examples:
```bash
make up-sql
make up-nosql
make up-file
make up-all
```

Stopping:
```bash
make down-postgres
make down-mongo
make down-sql
make down-nosql
make down-all
```

Resetting (DANGEROUS):
```bash
make reset-postgres
make reset-mongo
make reset-sql
make reset-nosql
make reset-file
make reset-all
```

**WARNING:** Reset commands permanently delete containers, volumes, and/or database files.


## CLI Usage
You can access database shells directly. Here are a few examples:

PostgreSQL: &nbsp; `make cli-postgres`

MySQL: &nbsp; `make cli-mysql`

MongoDB: &nbsp; `make cli-mongo`

Redis: &nbsp; `make cli-redis`

SQLite: &nbsp; `make cli-sqlite`

DuckDB (Python CLI): &nbsp; `make cli-duckdb-python`

DuckDB (Docker CLI): &nbsp; `make cli-duckdb-docker`


## Init Scripts (Quick Test Tables)
Most databases include simple initialization scripts that:
- Create a simple table named "test"
- Insert a single row
- Avoid duplicate inserts on repeated runs

These are meant to verify the database is working properly.

**Table Structure and Content:**

id       |   name   |   project
---------|----------|--------------------
INTEGER  |   TEXT   | TEXT 
1        |   Andre  | local-databases

## Test Examples

SQLite:
```bash
make cli-sqlite
SELECT * FROM test;
```
Expected output:

1|Andre|local-databases

DuckDB (Python CLI):
```bash
make cli-duckdb-python
conn.execute("SELECT * FROM test").fetchall()
```
Expected output:

[(1, 'Andre', 'local-databases')]

PostgreSQL:
```bash
make cli-postgres
SELECT * FROM test;
```

Expected output:
```text
 id | name  |     project     
----+-------+-----------------
  1 | Andre | local-databases
(1 row)
```

If the row exists, your database is working correctly.


## Web GUI Connections
Make sure:
- Docker is running
- Relevant containers are up

### PostgreSQL / pgAdmin
http://localhost:5050

admin@admin.com / rootpass

Create server -> Connections:
- Host: postgres
- Port: 5432
- Database: postgres
- User: postgres
- Password: rootpass


### MySQL / MariaDB / phpMyAdmin

http://localhost:5080

Login: root / rootpass


### MongoDB / Mongo Express
http://localhost:8081

Login: root / rootpass


### Redis / RedisInsight
http://localhost:8001

Use password from .env


### Couchbase
http://localhost:8091

Administrator / rootpass


### DBeaver Connections (Applicable to other DB clients)
**Example: PostgreSQL**
- Host: localhost
- Port: 5432
- Database: postgres
- Username: postgres
- Password: rootpass

Repeat similarly for other databases using ports defined in `.env`.

**File-based databases:**

SQLite: Open `data/sqlite/db/database.db`

DuckDB: Open `data/duckdb/db/database.duckdb`


## Troubleshooting
If something does not work:
- Ensure Docker is running
- Check container logs with `docker compose logs <service_name>`
- Ensure correct port in `.env`
- Run `make help-<database_name>` to confirm available commands

# Setup

This guide walks you through setting up the **local-databases** project, installing required software, and connecting to all included databases via Web GUIs and DBeaver.  

> All referenced usernames, passwords, and ports below are **defaults from `.env.example`**.  
> If you change anything in `.env`, update accordingly.


## Requirements

### Docker

Docker is required to run all containerized databases.  

**Installation:**

- **Windows / macOS:** [Docker Desktop](https://www.docker.com/products/docker-desktop/)  
- **Linux:** Install Docker Engine + Compose plugin via your distro’s package manager.

Verify installation:

```bash
docker --version
docker compose version
```

### Python 3.10+

Python is required for file-based databases (SQLite, DuckDB) and scripts.

**Installation:**

- Windows / macOS: Python.org Downloads
- Linux: Use your distro’s package manager (apt install python3 python3-venv)

Verify installation:
```bash
python3 --version
pip3 --version
``` 

### Git

Required to clone the repository.

`git --version`

**Install:**

- Windows / macOS: Git Downloads

- Linux: Use your package manager (apt install git or yum install git)

### Make

Used to run the pre-defined commands for starting/stopping databases.

Verify:

`make --version`

**Install:**

- Windows: via Chocolatey or WSL

- macOS: brew install make

- Linux: apt install make or equivalent

### Optional: DBeaver

A universal database GUI client.

Download: https://dbeaver.io/download/

Free Community Edition is sufficient.


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

You can change ports, usernames, and passwords if you want, but defaults are safe.

3. Create Python Virtual Environment (for SQLite & DuckDB)
```bash
python3 -m venv .venv
```
```bash
source .venv/bin/activate   # macOS/Linux
```
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; or
```bash
.venv\Scripts\activate   # Windows
```
```bash
pip install -r requirements.txt
```


## Connections

Make sure:

- Docker is running

- Relevant containers are up (make up-<database_name>)

### Web GUIs

**PostgreSQL / pgAdmin**

- Open pgAdmin in your browser (http://localhost:5050)
- Create a new server:
- General: Name → Any name
- Connection:
    - Host → postgres
    - Port → 5432
    - Maintenance database → postgres
    - Username → postgres
    - Password → rootpass
    - Save password → Optional

**MySQL / MariaDB / phpMyAdmin**

- Access via browser: http://localhost:5080 (default PHPMYADMIN_PORT)
- Login credentials: root / password from .env.example

**MongoDB / Mongo Express**

- Access via browser: http://localhost:8081 (default MONGOEXPRESS_PORT)
- Admin user / password: root / rootpass (from .env.example)

**Redis / RedisInsight**

- Access via browser: http://localhost:8001
- Connect using password from .env.example

**Cassandra**

- No web GUI included by default
- Connect using CQL shell: docker compose exec -it cassandra cqlsh

**Elasticsearch**

- Access via browser: http://localhost:9200
- Username / password: from .env.example
- Use CLI: docker compose exec -it elasticsearch /bin/bash

**ClickHouse**

- Connect via CLI: docker compose exec -it clickhouse clickhouse-client --user ${CLICKHOUSE_USER} --password

**Couchbase**

- Access via browser: http://localhost:8091

- Admin user / password: from .env.example

### DBeaver (or any DB client)

**PostgreSQL Example**

- Click New Database Connection → PostgreSQL → Next

- Fill in connection settings:

    - Host → localhost

    - Port → 5432

    - Database → postgres

    - Username → postgres

    - Password → rootpass

- Download drivers if prompted → Finish  

<br />

Repeat similar steps for:

| Database      | Host      | Port  | Username      | Password |
| ------------- | --------- | ----- | ------------- | -------- |
| MySQL         | localhost | 3306  | root          | rootpass |
| MariaDB       | localhost | 3306  | root          | rootpass |
| MongoDB       | localhost | 27017 | root          | rootpass |
| Redis         | localhost | 6379  | —             | rootpass |
| Cassandra     | localhost | 9042  | —             | —        |
| Elasticsearch | localhost | 9200  | elastic       | rootpass |
| ClickHouse    | localhost | 8123  | default       | rootpass |
| Couchbase     | localhost | 8091  | Administrator | rootpass |


File-based databases (SQLite & DuckDB) use the .db files in data/<database>/db/. You can open them in DBeaver or Python.

## Make commands
```bash
# Start Databases
make up-postgres   # Individual examples
make up-mongo

make up-sql   # Group examples
make up-nosql
make up-all

# Stop Databases
make down-postgres   # Individual examples
make down-mongo

make down-sql   # Group examples
make down-nosql
make down-all

# Reset Databases
make reset-postgres   # Individual examples
make reset-mongo

make reset-sql   # Group examples
make reset-nosql
make reset-all
```

**Warning:** Reset commands permanently delete database containers, volumes, and/or files.
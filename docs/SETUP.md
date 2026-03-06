# Setup

This guide walks you through getting db-workbench up and running locally. By the end, you’ll have:
- All required tools installed and configured
- A working environment with Python and Docker
- One or more databases running in isolated containers or file-based setups
- Pre-populated test data to verify everything is working
- Access to databases via CLI, Web GUI, SDK, or external clients

**Note:** All default usernames, passwords, and ports come from `.env.example`. If you customize your own `.env` file, adjust accordingly when connecting.

`db-workbench` is designed to make database experimentation frictionless and predictable. You don’t need deep knowledge of Docker, SQL, or NoSQL - the Makefile commands handle container startup, initialization scripts, and workspace creation automatically.


## Requirements

Before starting db-workbench, make sure the following tools are installed and working.

### 1. Docker
Required for all containerized databases (PostgreSQL, MongoDB, Redis, etc.).

Install:
- Windows/macOS: [Docker Desktop](https://www.docker.com/products/docker-desktop/)
- Linux: Docker Engine + Compose plugin via your package manager (apt, dnf, etc.)

Verify installation:
```bash
docker --version
docker compose version
```

**Tip:** Docker Desktop includes Docker Compose by default. On Linux, ensure docker and docker-compose are in your PATH.

### 2. Python 3.10+
Required for file-based databases (SQLite, DuckDB) and initialization scripts.

Install:
- Windows/macOS: python.org
- Linux: sudo apt install python3 python3-venv (or equivalent for your distro)

Verify installation:
```bash
python3 --version
pip3 --version
```

**Tip:** Make sure python3 points to version 3.10 or higher.

### 3. Make
Used to run all project workflows via the Makefile.

Install:
- Windows: via [Chocolatey](https://chocolatey.org/) or WSL
- macOS: `brew install make`
- Linux: `sudo apt install make` (or equivalent)

Verify installation:
```bash
make --version
```

### 4. Git
Required to clone the repository.

Verify installation:
```bash
git --version
```

### 5. Optional: DBeaver
Universal database GUI client. Helps inspect databases without the CLI.  
Install: https://dbeaver.io/download/
- Community Edition: Works for SQL databases
- Pro version: Needed for most NoSQL databases

### Requirements Checklist
✅ Docker installed and running  
✅ Python 3.10+ installed  
✅ Make installed  
✅ Git installed  
✅ Optional: DBeaver installed  


## Installation
Follow these steps to get db-workbench up and running.

### 1. Clone the Repository
```bash
git clone https://github.com/andretempera/db-workbench.git
cd db-workbench
```

This copies the project files to your local machine and switches into the project directory.

### 2. Create .env File
```bash
cp .env.example .env
```

This creates your own local environment file, which defines ports, usernames, and passwords for all databases.

- Defaults are safe for local experimentation.
- You may modify values if they conflict with other services on your machine.

**Tip:** Keep `.env` private as it contains credentials.

### 3. Create a Python Virtual Environment
Required for file-based databases (SQLite, DuckDB) and SDK scripts.
```bash
python3 -m venv .venv
```

Activate the virtual environment:

- macOS / Linux
```bash
source .venv/bin/activate
```

- Windows (PowerShell)
```bash
.\venv\Scripts\Activate.ps1
```

- Windows (Command Prompt)
```bash
.\venv\Scripts\activate.bat
```

Once activated, your shell prompt will indicate the environment is active. All Python packages will now be installed locally to this project.

### 4. Install Required Python Packages
```bash
pip install -r requirements.txt
```

This installs dependencies needed to interact with file-based databases and run initialization scripts.

**Tip:** Make sure you are inside the .venv when running these commands. If you see ModuleNotFoundError later, the virtual environment may not be active.

### 5. Verify Setup
Check that the basic tools and Python dependencies are working:
```bash
docker --version
docker compose version
python3 --version
pip --version
make --version
```

If all commands succeed, your system is ready to start databases using the Makefile commands.

### 6. Quick Start Example
After installation, you can test a database immediately:
```bash
make up-postgres
make cli-postgres
```

Once inside the PostgreSQL CLI, you can query the pre-populated test table:
```sql
SELECT * FROM test;
```

You should see a single row with:
```txt
 id | name  |     project
----+-------+---------------
  1 | Andre | db-workbench
(1 row)
```

This confirms the database is running correctly and the initialization scripts worked.

### Installation Checklist
✅ Clone the repository  
✅ Create `.env` file  
✅ Create `.venv`   
✅ Install Python packages  
✅ Verify setup  
✅ Optional: Quick-start test 


## Working with Databases
`db-workbench` provides a unified Makefile interface for managing all databases. You can start, connect, and reset databases using simple commands — no need to memorize Docker commands.

### 1. Start a Database
```bash
make up-<database_name>
```
```bash
# Examples
make up-postgres
make up-mongo
make up-duckdb
```
This command will:
- Start the database container (or file-based database)
- Automatically run initialization scripts (on most databases), creating:
  - A default workspace called `db_workbench` (or equivalent for NoSQL)
  - A test table/collection/bucket named test with a single row: `id = 1, name = Andre, project = db-workbench`
- Make the database ready for CLI, SDK, or GUI access

**Tip:** You can also start multiple databases by type:
```bash
make up-file       # Starts DuckDB and SQLite
make up-sql        # Starts MariaDB, MySQL, PostgreSQL
make up-nosql      # Starts Cassandra, MongoDB, Redis, etc.
make up-all        # Starts all databases
```

### 2. Connect to a CLI
```bash
make cli-<database_name>
```
```bash
# Examples
make cli-postgres
make cli-mongo
make cli-duckdb
```
- Opens the native database CLI inside a Docker container or local Python environment
- Initialization scripts have already run; the test data is ready to query
- Examples:
```bash
SELECT * FROM test;          # SQL engines
db.test.find();              # MongoDB
GET db_workbench:test:1;     # Redis
```

### 3. Connect to a Web GUI
Some databases provide web-based GUIs for easier inspection:
```bash
make gui-<database_name>
```
| Database      | GUI               |
|---------------|-------------------|
| MariaDB       | phpMyAdmin        |
| MySQL         | phpMyAdmin        |
| PostgreSQL    | pgAdmin           |
| ClickHouse    | ClickHouse UI     |
| Couchbase     | Couchbase Console |
| Elasticsearch | Kibana            |
| MongoDB       | Mongo Express     |
| Redis         | RedisInsight      |

- The command will:
  - start the GUI container, 
  - open necessary port automatically,
  - run an init script (required by some databases),
  - provide a link with the correct URL in terminal.
- Login credentials and URLs are defined in `.env`.
- The default workspace `db_workbench` with a test row is pre-created.
- Some GUIs (like Kibana) may require extra steps to connect to and visualize the test data.
- Make command to access GUI is preferable, direct URL or Docker Desktop service port link possible.

### 4. Connect via SDK
```bash
make sdk-<database_name>
```
```bash
# Examples
make sdk-duckdb
make sdk-postgres
make sdk-mongo
```
- Starts a Python CLI pre-configured for the selected database
- Connects to the `db_workbench` workspace automatically
- Useful for running scripts or testing SDK features

**Note:** You may need to use `sudo chown <USER> <file_path>` to manually change file permissions for file-based databases when switching between CLI and SDK.

### 5. Stop a Database
```bash
make down-<database_name>
```
- Stops the database container but preserves all data
- Useful if you want to free up system resources temporarily

You can also stop multiple databases at once:
```bash
make down-file
make down-sql
make down-nosql
make down-all
```

### 6. Reset a Database
```bash
make reset-<database_name>
```
- Stops the database container and removes all data, volumes, and files
- Resets the database to a clean state
- Initialization scripts will re-run on the next `make up-<database-name>`

**Warning:** This is destructive - all data in the database will be lost.

### 7. Quick Verification
Once a database is running, you can verify the test row exists:
- SQL example (PostgreSQL):
```sql
SELECT * FROM test;
```
- MongoDB example:
```bash
db.test.find();
```
- Redis example:
```bash
GET db_workbench:test:1
```
If you see the test row containing (id = 1, name = Andre, project = db-workbench), the database is ready.

### 8. Makefile Help Commands
The Makefile is self-documenting. Use these commands to explore all available functionality:
```bash
make help                    # Shows all commands
make help-file               # Shows commands for file-based DBs
make help-sql                # Shows commands for SQL DBs
make help-nosql              # Shows commands for NoSQL DBs
make help-<database_name>    # Shows commands for a specific database
```
**Tip:** Always run make help if you are unsure of a command or workflow.

### 9. Cheatsheets
Additional information with common commands or workflows, cheatsheets are available for all databases in `docs/cheatsheets/`
- SQL, NoSQL, and file-based engines each have their own folder
- Contains quick-reference commands, example queries, and initialization notes
- Ideal for beginners or for a quick reminder while experimenting


## Connecting via Web GUI
Ensure:
- Docker is running
- The relevant database container is started

You can access the GUI by entering the URL in a browser or clicking the service port in Docker Desktop. Using `make gui-<database_name>` is recommended, as some databases run initialization scripts when launched via `make`.

### MariaDB - phpMyAdmin
URL: `http://localhost:<PHPMYADMIN_MARIADB_PORT>`

**Login:**
- Username: `root`
- Password: `rootpass`

1. Verify test data:
- Select the `db_workbench` database from the left panel.
- Click on the test table → browse data.
- You should see the default test row:
```txt
id | name  | project
---+-------+---------------
 1 | Andre | db-workbench
 ```
2. Run queries:
- 

### MySQL - phpMyAdmin
URL: `http://localhost:<PHPMYADMIN_MYSQL_PORT>`

**Login:**
- Username: `root`
- Password: `rootpass`

1. Verify test data:
- Select the `db_workbench` database from the left panel.
- Click on the test table → browse data.
- You should see the default test row:
```txt
id | name  | project
---+-------+---------------
 1 | Andre | db-workbench
 ```
2. Run queries:
- 

### PostgreSQL - pgAdmin
URL: `http://localhost:<PGADMIN_PORT>`

**Login:**
- Username: `admin@admin.com`
- Password: `rootpass`

1. Connect to the database:
- Create → Server → Connection:
- Host: `postgres`
- Port: `5432`
- Username: `postgres`
- Password: `rootpass`

2. Verify test data:
- Expand Servers → Postgres Workbench → Databases → `db_workbench` .
- Open the test table → click View/Edit Data → All Rows.
- Confirm the default test row exists.

3. Run queries:
-

### ClickHouse / ClickHouse Web UI
URL: `http://localhost:<CLICKHOUSE_PORT>`

**Login** not required.

1. Verify and query data:
- Select the `db_workbench` database.
- Open the test table.
- Query the table (via web UI query editor):
```txt
 1 | Andre | db-workbench
 ```

### Couchbase / Couchbase Console
URL: `http://localhost:<COUCHBASE_PORT>/ui/index.html`

**Login:**
- Username: `Administrator`
- Password: `rootpass`

1. Verify test data:
- Default bucket: db_workbench. Click to open.
- Access documents → look for key test:1.
- You should see JSON:
```json
{
  "id": 1,
  "name": "Andre",
  "project": "db-workbench"
}
```
2. Run queries:
-

### Elasticsearch / Kibana
URL: `http://localhost:<KIBANA_PORT>`

**Login:**
- Username: `elastic`
- Password: `rootpass`

1. Create a Data View in Kibana:
  - Navigate to Management → Kibana → Data Views → Create Data View.
  - Name: `DB Workbench`
  - Index Pattern: `db_workbench`. (**Note:** You should see "Your index pattern matches 1 source.")
  - Click Save to create the data view.

2. Access the Data in Discover:
- Go to Discover → Elasticsearch → Click on All logs.
- Choose `DB Workbench` from the dropdown to view the test data.

3. Run Queries in Dev Tools:
- Go to Management → Dev Tools.
- Dev Tools → run query: `GET /db_workbench/_doc/1`
```json
{
  "_index": "db_workbench",
  "_id": "1",
  "_source": {
    "id": 1,
    "name": "Andre",
    "project": "db-workbench"
  }
}
```

### MongoDB / Mongo Express
URL: `http://localhost:<MONGOEXPRESS_PORT>`

**Login:**
- Username: `root`
- Password: `rootpass`

1. Verify test data:
- Open the db_workbench database.
- Select the test collection.
- Confirm the default document exists:
```json
{
  "id": 1,
  "name": "Andre",
  "project": "db-workbench"
}
```

### Redis / RedisInsight
URL: `http://localhost:<REDISINSIGHT_PORT>`

**Login** not required.

1. Connect to test data:
- Use connection string (with .env defaults): `redis://default:rootpass@redis:6379`
- Navigate to `db_workbench:test:1` key → confirm value:
```txt
id: 1
name: Andre
project: db-workbench
```

2. Run queries
- 

## Connecting via DBeaver
This is a quick-reference table to make establishing connections on DBeaver easier. This table uses `.env` defaults.

| Database Engine  | Server Host     | Port    | Database             | Username       | Password  |
|------------------|-----------------|---------|----------------------|----------------|-----------|
| SQLite           | Local file path | N/A     | db_workbench.db      | N/A            | N/A       |
| DuckDB           | Local file path | N/A     | db_workbench.duckdb  | N/A            | N/A       |
| MariaDB          | localhost       | 3307    | db_workbench         | root           | rootpass  |
| MySQL            | localhost       | 3306    | db_workbench         | root           | rootpass  |
| PostgreSQL       | localhost       | 5432    | db_workbench         | postgres       | rootpass  |
| Cassandra *      | localhost       | 9042    | db_workbench         | N/A            | N/A       |
| ClickHouse       | localhost       | 8123    | db_workbench         | root           | rootpass  |
| Couchbase *      | localhost       | 8091    | db_workbench         | N/A            | N/A       |
| Elasticsearch    | localhost       | 9200    | db_workbench         | N/A            | N/A       |
| MongoDB *        | localhost       | 27017   | db_workbench         | N/A            | N/A       |
| Redis *          | localhost       | 6379    | db_workbench         | N/A            | N/A       |

**Notes:**
- `Database Engine` is the database you are connecting to, chosen from "New Database Connection" list. If marked with `*`, requires Pro version to connect.
- `Server Host` should always be `localhost` (or `127.0.0.1`) when connecting from DBeaver through Docker. SQLite/DuckDB should point to the database file in your project root.
- `Database` sets the default database to use, `db_workbench` is the default for this project. Check "Show all databases" box if needed.
- Some databases may require going to Driver Properties and setting `allowPublicKeyRetrieval=TRUE`.
- Connection name defaults to the database name but can be renamed in DBeaver by right-clicking and selecting "Rename" or pressing "F2".
- Other DB clients may connect similarly, but they have not been tested in this project.


## Tips & Best Practices
**1. File-Based Databases (SQLite & DuckDB)**

- **DuckDB:** Can be accessed via CLI or DBeaver. CLI access is recommended for quick experiments, GUI access for inspection.
- **SQLite:** Due to file-level locking, avoid accessing the same database file simultaneously from Windows and WSL. Use the CLI within the same environment where the file resides.

Always ensure the database file is not open in another program while running commands.

**2. Server-Based Databases (SQL & NoSQL)**
- SQL databases (PostgreSQL, MySQL, MariaDB) and NoSQL databases (MongoDB, Redis, Cassandra, Elasticsearch, ClickHouse, Couchbase) are safe to access concurrently via CLI, SDK, DBeaver, or web GUI.
- Use `make up-<database_name>` to start the database before connecting.
- Use `make cli-<database_name>` or `make gui-<database_name>` for consistent and safe access.

**3. Connection Credentials & Ports**
- Always reference the `.env` file for correct usernames, passwords, and ports.
- When connecting with DBeaver or other external clients, use these values to avoid connection errors.
- For file-based databases, point the client directly to the .db or .duckdb file in the data/ folder.

**4. Initialization Scripts**
- All databases include pre-populated test data in a workspace called db_workbench.
- Running `make up-<database_name>` automatically executes these scripts - no separate initialization command is needed.
- Test your connection by querying the test table/collection/bucket. Example: SELECT * FROM test; for SQL engines.

**5. General Advice**
- Reset commands (`make reset-<database_name`>) are destructive. Use them only when you intend to delete data.
- For troubleshooting, always start with make doctor to verify Docker, ports, and virtual environment setup.
- When using multiple interfaces (CLI, SDK, GUI), ensure the database is started first via Makefile commands to avoid inconsistencies.


## Troubleshooting
Before running a database, you can perform a quick environment check:
```bash
make doctor
```
This command verifies that your local environment is ready to run `db-workbench`.

If a warning or error appears, check the following:

### 1. Docker Status
Ensure Docker is installed and running.
```bash
docker --version
docker compose version
```
### 2. Environment Configuration
Ensure the environment file exists:
```bash
cp .env.example .env
```
Verify that required variables and ports are configured correctly.

### 3. Python Environment
Ensure the virtual environment is active and dependencies are installed:
```bash
source .venv/bin/activate
pip install -r requirements.txt
```

### 4. Port Conflicts
If a container fails to start, a port may already be in use.

Check configured ports in `.env`, then verify:
```bash
lsof -i :<port>
```
If needed, change the port in .env and restart the service.

### 5. Check Container Logs
If a database fails to start or behaves unexpectedly, inspect logs:
```bash
docker compose logs <service_name>
```
```bash
# Examples
docker compose logs postgres
docker compose logs mongo
```
Logs often reveal issues such as configuration errors, memory limits, or failed initialization scripts.

**Tip:** If logs output too much information, try `docker compose logs <service_name> | grep error`.

### 6. Verify Commands
Ensure you are using the correct Makefile commands:
```bash
make help
make help-<database_name>
```
```bash
# Examples
make help-postgres
make help-mongo
```

### 7. Restart or Reset a Database
If a container is stuck or partially initialized, restart it:
```bash
make down-<database_name>
make up-<database_name>
```

If problems persist, reset the database completely:
```bash
make reset-<database_name>
```
**Warning:** This removes all database data and volumes.

### Common Causes of Startup Failures

Most issues fall into one of these categories:
- Docker not running
- Port conflicts
- Insufficient system memory
- Incorrect environment configuration

**Note:** Some databases require more RAM than others. The heaviest services in this stack are Cassandra, Elasticsearch and Couchbase.

If you encounter resource issues, try running fewer databases at once.
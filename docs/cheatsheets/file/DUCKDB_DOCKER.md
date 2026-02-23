# DuckDB Cheatsheet - CLI / Docker CLI

<table>
  <tr>
    <td width="90" style="vertical-align: middle; padding-right: 10px;">
      <img src="https://cdn.jsdelivr.net/gh/devicons/devicon@latest/icons/duckdb/duckdb-original.svg" width="75" />
    </td>
    <td style="vertical-align: middle;">
      DuckDB is an in-process, columnar analytical database designed for fast OLAP queries. It can be used via Python, R, or a CLI, and works with a single local database file.
    </td>
  </tr>
</table>

Default workspace: `db_workbench.duckdb`

## Mental Model
- DuckDB stores data in a **single file** (e.g., `db_workbench.duckdb`).
- Works in **columnar mode**, optimized for analytical queries.
- Supports SQL syntax similar to PostgreSQL for DML and DDL.
- Python API allows programmatic access with `duckdb.connect()`.
- CLI / Docker mode allows direct SQL execution from terminal or container.

## Commands

### 1. Connect
```bash
make cli-duckdb-docker
# or directly
duckdb data/duckdb/db_workbench.duckdb
```

### 2. Show Current Workspace
```sql
PRAGMA database_list; -- Shows attached databases
```

### 3. List Workspaces (Databases)
In DuckDB, each database is a file. Default for this project is `db_workbench.duckdb`.  
There is no concept of multiple databases in the same session, but multiple files can be attached using `ATTACH`.

### 4. Switch Workspace
Not applicable in DuckDB; connect to a different file instead.
```sql
ATTACH 'example.duckdb' AS example; -- attach another database file
SELECT * FROM example.users; -- Query table from attached database
``` 

### 5. Create Workspace
From system shell, use `duckdb data/duckdb/example.duckdb`. It will create the file if needed and enter DuckDB shell automatically.

### 6. List Structures (Tables)
```sql
SHOW TABLES; -- Lists tables in current database
```

### 7. Create Structure (Table)
```sql
CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    name VARCHAR,
    age INTEGER
); -- Creates a new table
```

### 8. Describe Structure
```sql
DESCRIBE users; -- Shows column info
```

### 9. Insert Data
```sql
INSERT INTO users (id, name, age)
VALUES (1, 'Alice', 30);
```

### 10.  Query All Data
```sql
SELECT * FROM users;
```

### 11.  Query With Condition
```sql
SELECT * FROM users
WHERE age > 25;
```

### 12.  Update Data
```sql
UPDATE users
SET age = 31
WHERE name = 'Alice';
```

### 13.  Delete Data
```sql
DELETE FROM users
WHERE name = 'Alice';
```

### 14.  Drop Structure
```sql
DROP TABLE users;
```

### 15.  Exit
```sql
.quit
```

---

**Notes:**
- Workspace = file; db_workbench.duckdb is pre-created by default.
- Columnar storage makes analytical queries fast; row-level inserts/updates are slower.
- SQL syntax is largely PostgreSQL-compatible, but some features differ.
- CLI / Docker CLI and Python CLI can access the same database file; changes persist across sessions.
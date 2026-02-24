# DuckDB Cheatsheet

<table>
  <tr>
    <td width="90" style="vertical-align: middle; padding-right: 10px;">
      <img src="https://cdn.jsdelivr.net/gh/devicons/devicon@latest/icons/duckdb/duckdb-original.svg" width="75" />
    </td>
    <td style="vertical-align: middle;">
      DuckDB is an in-process, columnar analytical database designed for fast OLAP queries. It can be used via Python, R, or a CLI, and works with a single local database file. <br>
      Visit <a>https://duckdb.org/</a> for more information.
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
**Python CLI:**  
```bash
make cli-duckdb-python
```
```python
# or directly
import duckdb
conn = duckdb.connect('data/duckdb/db_workbench.duckdb')  # Connect to database file
```

### 2. Show Current Workspace
```python
conn.execute("PRAGMA database_list").fetchall()  # Shows attached databases
```

### 3. List Workspaces (Databases)
Each database is a file. Default for this project is db_workbench.duckdb.
You can attach additional files if needed:
```python
conn.execute("ATTACH 'example.duckdb' AS example")
```

### 4. Switch Workspace
Not applicable in DuckDB; connect to a different file instead.
```python
conn.execute("ATTACH 'example.duckdb' AS example")
# Query tables with alias:
conn.execute("SELECT * FROM example.users").fetchall()
``` 

### 5. Create Workspace
```python
# Connect to a new file; it is created automatically
conn = duckdb.connect('data/duckdb/example.duckdb')
```

### 6. List Structures (Tables)
```python
conn.execute("SHOW TABLES").fetchall()  # Lists tables in current database
```

### 7. Create Structure (Table)
```python
conn.execute("""
CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    name VARCHAR,
    age INTEGER
);
""")
```

### 8. Describe Structure
```python
conn.execute("DESCRIBE users").fetchall()
```

### 9. Insert Data
```python
conn.execute("INSERT INTO users (id, name, age) VALUES (1, 'Alice', 30)")
```

### 10.  Query All Data
```python
conn.execute("SELECT * FROM users").fetchall()
```

### 11.  Query With Condition
```python
conn.execute("SELECT * FROM users WHERE age > 25").fetchall()
```

### 12.  Update Data
```python
conn.execute("UPDATE users SET age = 31 WHERE name = 'Alice'")
```

### 13.  Delete Data
```python
conn.execute("DELETE FROM users WHERE name = 'Alice'")
```

### 14.  Drop Structure
```python
conn.execute("DROP TABLE users")
```

### 15.  Exit
```python
conn.close()
```

---

**Notes:**
- Workspace = file; db_workbench.duckdb is pre-created by default.
- Columnar storage makes analytical queries fast; row-level inserts/updates are slower.
- SQL syntax is largely PostgreSQL-compatible, but some features differ.
- CLI / Docker CLI and Python CLI can access the same database file; changes persist across sessions.
- Python CLI supports returning query results as Pandas DataFrames by using `df = conn.execute("SELECT * FROM users").fetchdf()`. That feature is included in make `cli-duckdb-python` command.

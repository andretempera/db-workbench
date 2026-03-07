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


## Mental Model
```txt
Database (single file or in-memory)
 └── Schema (logical grouping)
      └── Table (grouping)
           └── Data (stored in rows/records)
```
- DuckDB is serverless, there is no separate server, schema or cluster processes.
- A **database** is a single file on disk (e.g., `db_workbench.duckdb`) or run entirely in-memory.
- A schema contains tables, views, and other objects.
- A **table** is the grouping that organizes data
- **Data** is stored as **rows** (records) and **columns** (fields).
- DuckDB uses strongly-typed SQL (each column has a defined data type).


## Basic Commands & Workflow
### 1. Start Environment
- Open DuckDB CLI:
```bash
  make cli-duckdb
```

### 2. Inspect Existing Setup
- Show all databases:
```sql
  .databases
```

- Show tables:
```sql
  .tables
```

- Show table structure:
```sql
  .schema test
```

- Query all data in the `test` table:
```sql
  SELECT * FROM test;
```

### 3. Insert a Row
- Insert a new row into the `test` table:
```sql
  INSERT INTO test (id, name, project)
  VALUES (2, 'Paula', 'new-project');
```

- Check the data after insertion:
```sql
  SELECT * FROM test;  -- View the table to see the new row added
```

### 4. Update Data
- Update data in the `test` table:
```sql
  UPDATE test
  SET project = 'updated-project'
  WHERE id = 2;  -- Updates row based on id number
```

- Check the data after update:
```sql
  SELECT * FROM test;  -- View the table again to check the updated row
```

### 5. Delete Data
- Delete a row from the `test` table:
```sql
  DELETE FROM test
  WHERE id = 2;  -- Deletes row based on id number
```

- Check the data after deletion:
```sql
  SELECT * FROM test;  -- Table should have just one entry again
```

### 6. Create a New Database
- Create a new database:
```sql
  ATTACH 'new_database.duckdb' AS new_database; -- new database file is created and attached to main, not independent
```

- List all databases again:
```sql
  .databases  -- Newly created database should be visible
```

### 7. Add a New Table
- Create a new table:
```sql
  CREATE TABLE IF NOT EXISTS new_database.top_secret (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    organization TEXT,
    country TEXT,
    years_active INTEGER);
```

- List tables again:
```sql
  .tables  -- Newly created table should be visible
```

- List tables per database:
```sql
SHOW ALL TABLES;  -- find which tables belong to which database
```

- Insert data into the new table:
```sql
  INSERT INTO new_database.top_secret
  VALUES(1,'James','MI6','UK',20),
    (2,'Ethan','IMF','USA',30),
    (3,'Nikita','Section One','Russia',8),
    (4,'Jason','CIA','USA',12),
    (5,'Sydney','SD-6','USA',10);
```

- Check the new table's data:
```sql
  SELECT * FROM new_database.top_secret;
```

### 8. Conditional queries
- Match criteria:
```sql
  SELECT * FROM new_database.top_secret
  WHERE organization = 'CIA';
```

- Find MAX value in entire table:
```sql
  SELECT MAX(years_active)
  FROM new_database.top_secret; -- also works with MIN()
```

- Threshold criteria:
```sql
  SELECT * FROM new_database.top_secret
  WHERE years_active < 15;  -- also works with <=, > and >=
```

- Multiple criteria:
```sql
  SELECT * FROM new_database.top_secret
  WHERE years_active > 10 AND
  name LIKE 'J%';  -- matching names that start with "J"
```

### 9. Aggregation queries
- Count number of rows:
```sql
  SELECT COUNT(*)
  FROM new_database.top_secret
  WHERE years_active > 15;  -- also works with >=, < and <=
```

- Using average and grouping:
```sql
  SELECT country, AVG(years_active)
  FROM new_database.top_secret
  WHERE country = 'USA'
  GROUP BY country;   -- also works with SUM()
```

- Find MIN within a group:
```sql
  SELECT country, MIN(years_active)
  FROM new_database.top_secret
  GROUP BY country; -- also works with MAX()
```
	
### 10. Cleanup
- Delete table:
```sql
  DROP TABLE new_database.top_secret;
```

- List tables again:
```sql
  .tables  -- Verify that the "top_secret" table was deleted
```

- Delete database:
```sql
  DETACH DATABASE new_database;  -- only detaches from main database, file must be deleted outside SQLite CLI environment
```

- List all databases again:
```sql
  .databases -- Verify that the "new_database" database was removed from the list
```

### 11. Exit Environment
- Exit DuckDB CLI:
```sql
  .exit
```


### Notes:
- Workspace = database file; `db_workbench.duckdb` is pre-created by default.
- Commands like `.tables`, `.schema`, and `.exit` are DuckDB CLI client commands, not standard SQL.
- Columnar storage makes analytical queries (aggregations, scans) very fast; row-by-row transactional workloads are less optimal.
- SQL syntax is largely PostgreSQL-compatible, but some features differ.
- DuckDB can run entirely in memory without creating a file; data disappears when the session ends.
- DuckDB can query external data files (CSV, Parquet, JSON) directly without importing them into tables.
- The same `.duckdb` file can be accessed from Docker CLI and Python SDK; all changes persist to the file.
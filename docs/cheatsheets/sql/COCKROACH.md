# PostgreSQL Cheatsheet

<table>
  <tr>
    <td width="90" style="vertical-align: middle; padding-right: 10px;">
      <img src="https://static.cdnlogo.com/logos/c/98/cockroachdb.svg" width="75" />
    </td>
    <td style="vertical-align: middle;">
      CockroachDB is a distributed, cloud-native SQL database designed for high availability, scalability, and strong consistency. It is PostgreSQL-compatible and follows a relational model using <b>databases</b>, <b>schemas</b>, <b>tables</b>, and <b>rows</b>. <br>
      Visit <a>https://www.cockroachlabs.com/</a> for more information.
    </td>
  </tr>
</table>

## Mental Model
```txt
Cluster (single-node or multi-node)
 └── Database (workspace)
      └── Schema (logical grouping)
           └── Table (grouping)
                └── Data (stored in rows/records)
```
- A CockroachDB `cluster` can contain one or more nodes; even a single-node instance is treated as a cluster.
- A `database` is the primary logical workspace. CockroachDB supports multiple databases per cluster.
- A `schema` is a logical grouping inside a database (default is `public`).
- A `table` contains data organized in rows and columns.
- Data is stored as rows (records) and columns (fields).
- CockroachDB uses strongly-typed SQL (each column has a type).
- CockroachDB ensures transactional consistency across nodes, so data is always consistent even in distributed setups.


## Basic Commands & Workflow
### 1. Start Environment
- Open CockroachDB CLI:
```bash
  make cli-cockroach
```

### 2. Inspect Existing Setup
- Show all databases:
```sql
  \l
```

- Show tables:
```sql
  \dt
```

- Show table structure:
```sql
  \d test
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
  CREATE DATABASE new_database;
```

- List all databases again:
```sql
  \l  -- Newly created database should be visible
```

- Switch to the new database:
```sql
  \c new_database;
```

### 7. Add a New Table
- Create a new table:
```sql
  CREATE TABLE IF NOT EXISTS top_secret (
      id INT PRIMARY KEY,
      name TEXT NOT NULL,
      organization TEXT,
      country TEXT,
      years_active INT
  );
```

- List tables again:
```sql
  \dt  -- Newly created table should be visible
```

- List tables per database:
```sql
  SELECT 'db_workbench' AS db_name, table_name
  FROM db_workbench.information_schema.tables
  WHERE table_schema='public' AND table_type='BASE TABLE'
  UNION ALL
  SELECT 'new_database' AS db_name, table_name
  FROM new_database.information_schema.tables
  WHERE table_schema='public' AND table_type='BASE TABLE';  -- find which tables belong to which database
```

- Insert data into the new table:
```sql
  INSERT INTO top_secret (id, name, organization, country, years_active)
  VALUES (1, 'James', 'MI6', 'UK', 20),
    (2, 'Ethan', 'IMF', 'USA', 30),
    (3, 'Nikita', 'Section One', 'Russia', 8),
    (4, 'Jason', 'CIA', 'USA', 12),
    (5, 'Sydney', 'SD-6', 'USA', 10);
```

- Check the new table's data:
```sql
  SELECT * FROM top_secret;
```

### 8. Conditional queries
- Match criteria:
```sql
  SELECT * FROM top_secret
  WHERE organization = 'CIA';
```

- Find MAX value in entire table:
```sql
  SELECT MAX(years_active)
  FROM top_secret; -- also works with MIN()
```

- Threshold criteria:
```sql
  SELECT * FROM top_secret
  WHERE years_active < 15;  -- also works with <=, > and >=
```

- Multiple criteria:
```sql
  SELECT * FROM top_secret
  WHERE years_active > 10 AND
  name LIKE 'J%';  -- matching names that start with "J"
```

### 9. Aggregation queries
- Count number of rows:
```sql
  SELECT COUNT(*)
  FROM top_secret
  WHERE years_active > 15;  -- also works with >=, < and <=
```

- Using average and grouping:
```sql
  SELECT country, AVG(years_active)
  FROM top_secret
  WHERE country = 'USA'
  GROUP BY country;   -- also works with SUM()
```

- Find MIN within a group:
```sql
  SELECT country, MIN(years_active)
  FROM top_secret
  GROUP BY country; -- also works with MAX()
```
	
### 10. Cleanup
- Delete table:
```sql
  DROP TABLE top_secret;
```

- List tables again:
```sql
  \dt  -- Verify that the "top_secret" table was deleted
```

- Switch back to original database:
```sql
  \c db_workbench;
```

- Delete database:
```sql
  DROP DATABASE new_database;
```

- List all databases again:
```sql
  \l  -- Verify that the "new_database" database was deleted
```

### 11. Exit Environment
- Exit CockroachDB CLI:
```sql
  \q
```


### Notes:
- Workspace = database; `db_workbench` is pre-created by default.
- By default, tables are created in the `public` schema.
- Supports transactions, constraints, indexes, and other advanced SQL features.
- Commands are executed within transactions; changes can be committed or rolled back.
- Default superuser: `root`, default port: `26257`, no password required for insecure mode.
- Cluster runs inside Docker; stopping the container pauses the database but preserves data in the Docker volume.
- Commands like `\dt`, `\d <table>`, `\l`, and `\c <db>` are **psql** client commands, not standard SQL.
- Connection is persistent across CLI, SDK, and GUI sessions.

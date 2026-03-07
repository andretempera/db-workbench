# ClickHouse Cheatsheet

<table>
  <tr>
    <td width="90" style="vertical-align: middle; padding-right: 10px;">
      <img src="https://cdn.jsdelivr.net/gh/devicons/devicon@latest/icons/clickhouse/clickhouse-original.svg" width="75" />
    </td>
    <td style="vertical-align: middle;">
      ClickHouse is a high-performance, columnar database designed for analytical queries. Data is organized in <b>databases</b>, <b>tables</b>, and <b>columns</b>, optimized for OLAP workloads and aggregations on large datasets. <br>
      Visit <a>https://clickhouse.com/</a> for more information.
    </td>
  </tr>
</table>

## Mental Model
```txt
Cluster (optional)
 └── Database (logical grouping)
      └── Table (columnar storage)
           └── Data (stored in columns)
```
- A ClickHouse deployment can run as a single node or as a cluster of nodes.
- A **database** is the primary logical grouping and contains tables.
- A **table** belongs to a database and defines structure and storage engine.
- Data is stored in a columnar format (optimized for analytics).
- ClickHouse uses strongly-typed SQL (each column has a defined data type).
- Table engines (e.g., MergeTree) define how data is stored, indexed, and replicated.


## Basic Commands & Workflow
### 1. Start Environment
- Open ClickHouse CLI:
```bash
  make cli-clickhouse
```

### 2. Inspect Existing Setup
- Show all databases:
```sql
  SHOW DATABASES;
```

- Show tables:
```sql
  SHOW TABLES;
```

- Show table structure:
```sql
  DESCRIBE test;
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
  ALTER TABLE test
  UPDATE project = 'updated-project'
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
  SHOW DATABASES;  -- Newly created database should be visible
```

- Switch to the new database:
```sql
  USE new_database;
```

### 7. Add a New Table
- Create a new table:
```sql
  CREATE TABLE IF NOT EXISTS top_secret(
    id UInt32,
    name String,
    organization String,
    country String,
    years_active Int32)
  ENGINE = MergeTree
  ORDER BY id;  -- ClickHouse requires storage engine to be defined for tables
```

- List tables again:
```sql
  SHOW TABLES;  -- Newly created table should be visible
```

- List tables per database:
  ```sql
  SELECT database, name AS table_name 
  FROM system.tables 
  WHERE database NOT IN ('system', 'information_schema', 'INFORMATION_SCHEMA');  -- find which tables belong to which database
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
  SHOW TABLES;  -- Verify that the "top_secret" table was deleted
```

- Switch back to original database:
```sql
  USE db_workbench;
```

- Delete database:
```sql
  DROP DATABASE new_database;
```

- List all databases again:
```sql
  SHOW DATABASES;  -- Verify that the "new_database" database was deleted
```

### 11. Exit Environment
- Exit ClickHouse CLI:
```sql
  quit
```

### Notes:
- Workspace = database; `db_workbench` is pre-created by default.
- ClickHouse is a columnar, analytical database optimized for OLAP queries.
- Data is stored in columns; row-level operations (updates/deletes) are slower.
- Table engines (e.g., MergeTree) define storage, indexing, and replication behavior.
  - Use MergeTree or its derivatives for persistent tables.
  - Engines like Memory are temporary and do not persist after shutdown.
- Supports strongly-typed SQL; each column has a defined type.
- Updates and deletes are handled internally via merges, not like typical OLTP.
- Commands like `SHOW DATABASES`, `SHOW TABLES`, and `DESCRIBE TABLE` are ClickHouse client commands, not standard SQL.
- Multiple nodes can form a cluster; replication and distribution are managed per table engine.
- Tables and data persist across CLI, SDK, and GUI sessions.


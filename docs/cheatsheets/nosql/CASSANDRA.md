# Cassandra Cheatsheet

<table>
  <tr>
    <td width="90" style="vertical-align: middle; padding-right: 10px;">
      <img src="https://cdn.jsdelivr.net/gh/devicons/devicon@latest/icons/cassandra/cassandra-original.svg" width="75" />
    </td>
    <td style="vertical-align: middle;">
      Apache Cassandra is a distributed wide-column NoSQL database designed for high write throughput and horizontal scalability. Data is stored in <b>keyspaces</b>, which contain <b>tables</b>, and tables are optimized for fast writes and partitioned storage. <br>
      Visit <a>https://cassandra.apache.org/_/index.html</a> for more information.
    </td>
  </tr>
</table>

## Mental Model
```txt
Cluster
 └── Keyspace (logical grouping)
      └── Table (column family)
           └── Data (partitioned rows)
```
- A Cassandra cluster contains multiple nodes (machines).
- A **cluster** contains one or more keyspaces.
- A **keyspace** is the top-level logical grouping (similar to a database in relational systems). It defines replication settings (how data is distributed and copied across nodes).
- A **table** (formerly called a column family) lives inside a keyspace.
- Data is stored as rows, but distributed across nodes by partition key.


## Basic Commands & Workflow
### 1. Start Environment
- Open Cassandra CLI:
```bash
  make cli-cassandra
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
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    organization TEXT,
    country TEXT,
    years_active INTEGER);
```

- List tables again:
```sql
  \dt  -- Newly created table should be visible
```

- Insert data into the new table:
```sql
  INSERT INTO top_secret (name, organization, country, years_active)
  VALUES ('James', 'MI6', 'UK', 20),
    ('Ethan', 'IMF', 'USA', 30),
    ('Nikita', 'Section One', 'Russia', 8),
    ('Jason', 'CIA', 'USA', 12),
    ('Sydney', 'SD-6', 'USA', 10);
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
  name LIKE "J%";  -- matching names that start with "J"
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
- Exit Cassandra CLI:
```sql
  \q
```

### Notes:
- Workspace = keyspace; `db_workbench` is pre-created by default.
- Cassandra is a distributed, query-driven, wide-column NoSQL database; design tables around access patterns.
- Queries must include primary keys or indexed columns; full table scans are not supported.
- Uses CQL (Cassandra Query Language), which resembles SQL but lacks joins and some relational features.
- Supports tunable replication and consistency per keyspace.
- Commands like `DESCRIBE KEYSPACES`, `DESCRIBE TABLE <table>`, and `SELECT` are executed in cqlsh.
- Default connection: keyspace `db_workbench`, default port: `9042`, default user: `cassandra`/`cassandra`.
- Cluster can span multiple nodes; data is automatically partitioned and replicated.
- Tables and data persist across CLI, SDK, and GUI sessions.

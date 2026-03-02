# MySQL Cheatsheet

<table>
  <tr>
    <td width="90" style="vertical-align: middle; padding-right: 10px;">
      <img src="https://cdn.jsdelivr.net/gh/devicons/devicon@latest/icons/mysql/mysql-original.svg" width="75" />
    </td>
    <td style="vertical-align: middle;">
      MySQL is a widely-used, open-source relational database system known for reliability, ease of use, and broad ecosystem support. It follows a traditional relational model using <b>databases</b>, <b>schemas</b>, <b>tables</b>, and <b>rows</b>. <br>
      Visit <a>https://www.mysql.com/</a> for more information.
    </td>
  </tr>
</table>

## Mental Model
```txt
Server (instance)
 └── Database (workspace / schema)
      └── Table (grouping)
           └── Data (stored in rows/records)
```
- A MySQL server instance can contain multiple databases.
- A **database** is the primary logical grouping (acts as a schema) and contains tables.
- A **table** is the grouping that organizes data
- **Data** is stored as **rows** (records) and **columns** (fields).
- MySQL uses strongly-typed SQL (each column has a type).
- Commands like `SHOW TABLES` and `DESCRIBE` are MySQL client commands, not standard SQL.

**Note:** The default workspace for this project is `db_workbench`. 

## Basic Commands & Workflow
### 1. Start Environment
- Open MySQL CLI:
```bash
  make cli-mysql
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

	Check the data after deletion:
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
  CREATE TABLE IF NOT EXISTS top_secret (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    organization TEXT,
    country TEXT,
    years_active INTEGER);
```

- List tables again:
```sql
  SHOW TABLES;  -- Newly created table should be visible
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
- Exit MySQL CLI:
```sql
  QUIT
```

**Notes:**
- Workspace = database; `db_workbench` is pre-created by default.
- Relational model with strong typing.
- Supports transactions, constraints, indexes, and advanced SQL features.
- Commands are executed within transactions; changes can be committed or rolled back.
- MySQL client commands (e.g., `SHOW TABLES`, `DESCRIBE`) are client-only commands.
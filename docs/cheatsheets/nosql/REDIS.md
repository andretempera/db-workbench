# Redis Cheatsheet

<table>
  <tr>
    <td width="90" style="vertical-align: middle; padding-right: 10px;">
      <svg width="75" height="75" viewBox="0 0 75 75" xmlns="http://www.w3.org/2000/svg">
        <circle cx="37.5" cy="37.5" r="36" fill="#DC382D"/>
        <g transform="translate(37.5 37.5) scale(0.09) translate(-256 -256)">
          <path d="M479.14 279.864c-34.584 43.578-71.94 93.385-146.645 93.385-66.73 0-91.59-58.858-93.337-106.672 14.62 30.915 43.203 55.949 87.804 54.792C412.737 318.6 471.53 241.127 471.53 170.57c0-84.388-62.947-145.262-172.24-145.262-78.165 0-175.004 29.743-238.646 76.782-.689 48.42 26.286 111.369 35.972 104.452 55.17-39.67 98.918-65.203 141.35-78.01C175.153 198.58 24.451 361.219 6 389.85c2.076 26.286 34.588 96.842 50.496 96.842 4.841 0 8.993-2.768 13.835-7.61 45.433-51.046 82.472-96.816 115.412-140.933 4.627 64.658 36.42 143.702 125.307 143.702 79.55 0 158.408-57.414 194.377-186.767 4.149-15.911-15.22-28.362-26.286-15.22zm-90.616-104.449c0 40.81-40.118 60.87-76.782 60.87-19.596 0-34.648-5.145-46.554-11.832 21.906-33.168 43.59-67.182 66.887-103.593 41.08 6.953 56.449 29.788 56.449 54.555z" fill="white"/>
        </g>
      </svg>
    </td>
    <td style="vertical-align: middle;">
      Redis is an in-memory key-value data store used for caching, fast lookups, messaging, and lightweight data structures. It stores data as <b>keys</b> mapped to <b>values</b> and supports multiple native data types. <br>
      Visit <a>https://redis.io/open-source/</a> for more information.
    </td>
  </tr>
</table>

## Mental Model
```txt
Server (instance)
 └── Database (numbered namespace)
      └── Key
           └── Value (data structure)
```
- A Redis server instance contains multiple logical databases (numbered 0–15 by default).
- A **database** is a simple namespace for keys.
- A **key** is the primary identifier.
- A **value** is associated with a key and can be different data types.
- Data is stored primarily in memory (with optional persistence to disk).
- Redis is not relational — there are no tables or schemas.


## Basic Commands & Workflow
### 1. Start Environment
- Open Redis CLI:
```bash
  make cli-redis
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
- Exit Redis CLI:
```sql
  \q
```

### Notes:
- Workspace = logical database; the db_workbench workspace maps to Redis database 0 by default.
- Redis is a key-value store; there are no tables, schemas, or relational structures.
- Values can be different data types: strings, hashes, lists, sets, sorted sets, streams, etc.
- All commands are atomic, and most operations are in-memory, making Redis extremely fast.
- Data can optionally persist to disk (RDB snapshots or AOF), but primary storage is in memory.
- Commands like KEYS, FLUSHDB, and SELECT are Redis client commands, not standard SQL.
- Keys are unique within a database namespace; separate logical databases (0–15 by default) isolate keys.


# Elasticsearch Cheatsheet

<table>
  <tr>
    <td width="90" style="vertical-align: middle; padding-right: 10px;">
      <img src="https://cdn.jsdelivr.net/gh/devicons/devicon@latest/icons/elasticsearch/elasticsearch-original.svg" width="75" />
    </td>
    <td style="vertical-align: middle;">
      Elasticsearch is a distributed search and analytics engine. Data is stored in <b>indices</b>, which contain <b>documents</b> in JSON format. It is optimized for full-text search, aggregations, and near real-time analytics. <br>
      Visit <a>https://www.elastic.co/elasticsearch</a> for more information.
    </td>
  </tr>
</table>

## Mental Model
```txt
Cluster
 └── Index (logical grouping)
      └── Shard (data partition)
           └── Document (JSON data)
```
- An Elasticsearch **cluster** contains one or more nodes, and contains one or more indexes.
- An **index** is the primary logical grouping of data (similar to a database/table conceptually). It is split into **shards**, which distribute data across nodes.
- A **document** is a JSON object stored inside an index, and are automatically assigned to shards.
- Elasticsearch uses a REST-based JSON API (not SQL by default, though SQL support exists).



## Basic Commands & Workflow
### 1. Start Environment
- Elasticsearch does not provide a dedicated interactive CLI like SQL databases.
- Once the container or service is running, you can interact with it via HTTP requests using tools such as `curl`, `http`, `Postman`, or language-specific SDKs.
- The REST API allows you to query, insert, update, and delete documents immediately after the service is available.

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
- Elasticsearch does not have a CLI environment to exit.


### Notes:
- Workspace = index; `db_workbench` index is pre-created by default.
- Elasticsearch is a document-oriented NoSQL database; documents are stored as JSON.
- Schema-flexible: each document can have different fields, but mappings define data types and analyzers.
- Clusters can contain multiple nodes and indexes for high availability and scalability.
- Indexes are partitioned into shards; shards distribute data across nodes automatically.
- Documents are accessed via REST API or SDKs; SQL endpoint exists for convenience.
- Operations are index-centric; you specify the index for each query.
- Supports full-text search, filtering, aggregations, and analytics on JSON data.
- Commands like `GET`, `POST`, `PUT`, and `_search` are Elasticsearch API operations, not standard SQL.
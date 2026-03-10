# Couchbase Cheatsheet - Native CLI

<table>
  <tr>
    <td width="90" style="vertical-align: middle; padding-right: 10px;">
      <img src="https://cdn.jsdelivr.net/gh/devicons/devicon@latest/icons/couchbase/couchbase-original.svg" width="75" />
    </td>
    <td style="vertical-align: middle;">
      Couchbase is a distributed, document-oriented database that stores <b>JSON documents</b> in buckets. It supports key-value operations, N1QL (SQL-like query language), and indexes for efficient queries. <br>
      Visit <a>https://www.couchbase.com/</a> for more information.
    </td>
  </tr>
</table>

## Mental Model
```txt
Cluster
 └── Bucket (workspace)
      └── Scope (logical grouping)
           └── Collection (grouping)
                └── Document (JSON, flexible schema)
```
- A Couchbase **cluster** contains one or more nodes.
- A **bucket** is the primary data container (similar to a database) and contains scopes.
- A **scope** is a logical grouping of collections (similar to a schema).
- A **collection** stores documents (similar to a table in relational systems).
- A **document** is a JSON object identified by a unique key (similar to a row).
- Data is stored in flexible JSON format (schema optional).


## Basic Commands & Workflow
### 1. Start Environment
- Open Couchbase CLI:
```bash
  make cli-couchbase
```

### 2. Inspect Existing Setup
- Show all buckets:
```sql
  SELECT name FROM system:buckets;
```

- Show all collections:
```sql
  SELECT name FROM system:keyspaces WHERE name != `bucket`;
```

- Show document structure:
```sql
  SELECT META().id AS document_key,
  OBJECT_NAMES(`test`) AS fields
  FROM `db_workbench`.`_default`.`test`;
```

- Query all data in the collection:
```sql
  SELECT META().id AS id, test.name, test.project
  FROM `db_workbench`.`_default`.`test`;
```

### 3. Insert a Document
- Insert a new document:
```sql
  UPSERT INTO `db_workbench`.`_default`.`test` (KEY, VALUE)
  VALUES ("id:2", { "name": "Paula", "project": "new-project" });
```

- Check the data after insertion:
```sql
  SELECT META().id AS id, test.name, test.project
  FROM `db_workbench`.`_default`.`test`;  -- View the data to see the new document added
```

### 4. Update Data
- Update data in the `test` table:
```sql
  UPSERT INTO `db_workbench` (KEY, VALUE)
  VALUES ("test:2", { "id": 2, "name": "Paula", "project": "updated-project" });  -- Upserts row based on key
```

- Check the data after upsert:
```sql
  SELECT META().id AS id, test.name, test.project
  FROM `db_workbench`.`_default`.`test`;  -- View the data again to check the updated document
```

### 5. Delete Data
- Delete a row from the `test` table:
```sql
  DELETE FROM `db_workbench`.`_default`.`test`
  WHERE META().id = "id:2";  -- Deletes document based on key
```

- Check the data after deletion:
```sql
  SELECT META().id AS id, test.name, test.project
  FROM `db_workbench`.`_default`.`test`;  -- Collection should have just one entry again
```

### 6. Create a New Bucket
- Create a new bucket:
```sql
  CREATE BUCKET IF NOT EXISTS `new_bucket`;
```

- List all buckets again:
```sql
  SELECT name FROM system:buckets;  -- Newly created bucket should be visible
```

- Switch to the new bucket:
```sql
  -- Not required, buckets are always directly accessible
```

### 7. Add a New Collection
- Create a new table:
```sql
  CREATE COLLECTION `new_bucket`.`_default`.`top_secret` IF NOT EXISTS;
```

- List collections again:
```sql
  SELECT name FROM system:keyspaces WHERE name != `bucket`;  -- Newly created collection should be visible
```

- List collections per bucket:
```sql
  SELECT `bucket`, name FROM system:keyspaces
  WHERE name != `bucket`;  -- Find which collections belong to which bucket
```

- Insert data into the new table:
```sql
  UPSERT INTO `new_bucket`.`_default`.`top_secret` (KEY, VALUE)
  VALUES ("id:1", { "name": "James", "organization": "MI6", "country": "UK", "years_active": 20 }),
    ("id:2", { "name": "Ethan", "organization": "IMF", "country": "USA", "years_active": 30 }),
    ("id:3", { "name": "Nikita", "organization": "Section One", "country": "Russia", "years_active": 8 }),
    ("id:4", { "name": "Jason", "organization": "CIA", "country": "USA", "years_active": 12 }),
    ("id:5", { "name": "Sydney", "organization": "SD-6", "country": "USA", "years_active": 10 });
```

- Check the new table's data:
```sql
  SELECT META().id AS id, top_secret.name, top_secret.organization, top_secret.country, top_secret.years_active
  FROM `new_bucket`.`_default`.`top_secret` ORDER BY id;
```

### 8. Conditional queries
- Match criteria:
```sql
  SELECT META().id AS id, t.*
  FROM `new_bucket`.`_default`.`top_secret` AS t
  WHERE t.organization = "CIA";
```

- Find MAX value in entire collection:
```sql
  SELECT MAX(t.years_active) AS max_years
  FROM `new_bucket`.`_default`.`top_secret` AS t; -- also works with MIN()
```

- Threshold criteria:
```sql
  SELECT META().id AS id, t.*
  FROM `new_bucket`.`_default`.`top_secret` AS t
  WHERE t.years_active < 15;  -- also works with <=, > and >=
```

- Multiple criteria:
```sql
  SELECT META().id AS id, t.*
  FROM `new_bucket`.`_default`.`top_secret` AS t
  WHERE t.years_active > 10
  AND t.name LIKE "J%";  -- matching names that start with "J"
```


### 9. Aggregation queries
- Count number of documents:
```sql
  SELECT COUNT(*)
  FROM `new_bucket`.`_default`.`top_secret` AS t
  WHERE t.years_active > 15;  -- also works with >=, < and <=
```

- Using average and grouping:
```sql
  SELECT t.country, AVG(t.years_active)
  FROM `new_bucket`.`_default`.`top_secret` AS t
  WHERE t.country = 'USA'
  GROUP BY t.country;   -- also works with SUM()
```

- Find MIN within a group:
```sql
  SELECT t.country, MIN(t.years_active)
  FROM `new_bucket`.`_default`.`top_secret` AS t
  GROUP BY t.country; -- also works with MAX()
```
	
### 10. Cleanup
- Delete collection:
```sql
  DROP COLLECTION `new_bucket`.`_default`.`top_secret`;
```

- List collections again:
```sql
  SELECT name FROM system:keyspaces WHERE name != `bucket`;  -- Verify that the "top_secret" collection was deleted
```

- Delete bucket:
```sql
  DROP BUCKET `new_bucket`;
```

- List all buckets again:
```sql
  SELECT name FROM system:buckets;  -- Verify that the "new_bucket" bucket was deleted
```

### 11. Exit Environment
- Exit Couchbase CLI:
```sql
  \exit;
```

### Notes:
- Workspace = bucket; `db_workbench` is pre-created by default.
- Couchbase is a document-oriented NoSQL database; documents are stored as JSON.
- Schema-less: documents within a collection can have different structures.
- Buckets are top-level containers; scopes group collections within a bucket.
- Collections are optional; `_default` collection always exists.
- Each document has a unique key and is accessed via key-value operations or N1QL queries.
- N1QL (SQL++ for JSON) allows SQL-like querying over JSON documents.
- Supports clusters with multiple nodes for high availability and scalability.
- Commands like `SELECT`, `CREATE COLLECTION`, or `DESCRIBE BUCKET` are Couchbase client commands, not standard SQL.
- Changes persist across CLI, SDK, and Web UI sessions.
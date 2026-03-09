# Redis Cheatsheet

<table>
  <tr>
    <td width="90" style="vertical-align: middle; padding-right: 10px;">
      <img src="https://cdn.jsdelivr.net/gh/devicons/devicon@latest/icons/redis/redis-original.svg" width="75" />
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
 └── Database (numbered namespace from 0 to 15)
      └── Key
           └── Value (data structure)
```
- A Redis server instance contains multiple logical databases (numbered 0–15 by default).
- A **database** is a simple namespace for keys.
- A **key** is the primary identifier.
- A **value** is associated with a key and can be different data types.
- Data is stored primarily in memory (with optional persistence to disk).
- Redis is not relational - there are no tables or schemas.


## Basic Commands & Workflow
### 1. Start Environment
- Open Redis CLI:
```bash
  make cli-redis
```

### 2. Inspect Existing Setup
- Show all databases:
```sql
  INFO keyspace
```

- Show keys:
```sql
  KEYS *
```

- Show value structure of corresponding key:
```sql
  JSON.OBJKEYS db_workbench:test:1
```

- Query all data in the `db_workbench:test:1` key:
```sql
  JSON.GET db_workbench:test:1
```

### 3. Insert a Row
- Insert a new key-value pair into the database:
```sql
  JSON.SET db_workbench:test:2 $ '{"id":2,"name":"Paula","project":"new-project"}'
```

- Check the data after insertion:
```sql
  JSON.MGET db_workbench:test:1 db_workbench:test:2 $  -- View the keyspace values to see the new data added
```

### 4. Update Data
- Update data in the `db_workbench:test:2` key:
```sql
  JSON.SET db_workbench:test:2 $.project '"updated-project"'  -- Updates the values of a key based on a field
```

- Check the data after update:
```sql
  JSON.MGET db_workbench:test:1 db_workbench:test:2 $  -- View the keyspace values again to check the updated data
```

### 5. Delete Data
- Delete a keyspace from the database:
```sql
  DEL db_workbench:test:2  -- Deletes entire key-value pair
```

- Check the data after deletion:
```sql
  JSON.MGET db_workbench:test:1 db_workbench:test:2 $  -- Database should have just one entry again, even if querying both
```

### 6. Working With a New Database
- Create a new database:
```sql
  -- No concept of creating a database. Databases are numbered from 0 to 15 by default.
```

- Switch to a new database:
```sql
  SELECT 1
```

- List all databases again:
```sql
  INFO keyspace  -- Newly created database is empty and not yet visible
```

### 7. Add Data
- Insert data into the new database:
```sql
  JSON.MSET new_database:top_secret:1 . '{"id":1,"name":"James","organization":"MI6","country":"UK","years_active":20}' new_database:top_secret:2 . '{"id":2,"name":"Ethan","organization":"IMF","country":"USA","years_active":30}' new_database:top_secret:3 . '{"id":3,"name":"Nikita","organization":"Section One","country":"Russia","years_active":8}' new_database:top_secret:4 . '{"id":4,"name":"Jason","organization":"CIA","country":"USA","years_active":12}' new_database:top_secret:5 . '{"id":5,"name":"Sydney","organization":"SD-6","country":"USA","years_active":10}'
```

- List all databases again:
```sql
  INFO keyspace  -- By adding a keyspace, the created database is now visible
```

- Show keys again:
```sql
  KEYS * -- Newly created keys should be visible
``` 

- Check the new data:
```sql
  JSON.MGET new_database:top_secret:1 new_database:top_secret:2 new_database:top_secret:3 new_database:top_secret:4 new_database:top_secret:5 $
```

- Create indexes on fields:
```sql
  FT.CREATE idx:top_secret ON JSON PREFIX 1 "new_database:top_secret:"  -- Not possible to create indexes on this database
```

- Switch back to original database:
```sql
  SELECT 0
```

- Recreating data on db0:
```sql
  JSON.MSET new_database:top_secret:1 . '{"id":1,"name":"James","organization":"MI6","country":"UK","years_active":20}' new_database:top_secret:2 . '{"id":2,"name":"Ethan","organization":"IMF","country":"USA","years_active":30}' new_database:top_secret:3 . '{"id":3,"name":"Nikita","organization":"Section One","country":"Russia","years_active":8}' new_database:top_secret:4 . '{"id":4,"name":"Jason","organization":"CIA","country":"USA","years_active":12}' new_database:top_secret:5 . '{"id":5,"name":"Sydney","organization":"SD-6","country":"USA","years_active":10}'
```

### 8. Conditional queries
- Create indexes on fields:
```sql
  FT.CREATE idx:top_secret ON JSON PREFIX 1 "new_database:top_secret:" SCHEMA $.id AS id NUMERIC $.name AS name TEXT $.organization AS organization TEXT $.country AS country TEXT $.years_active AS years_active NUMERIC  -- Indexes are what enables filtering and aggregations
  ```
- List indexes:
``sql
  FT._LIST
```

- Match criteria:
```sql
  FT.SEARCH idx:top_secret "@organization:CIA"
```

- Find MAX value within keys:
```sql
  FT.AGGREGATE idx:top_secret * GROUPBY 0 REDUCE MAX 1 @years_active AS max_years  -- also works with MIN
```

- Threshold criteria:
```sql
  FT.SEARCH idx:top_secret "@years_active:[-inf 14]"  -- Equivalent to < 15
```

- Multiple criteria:
```sql
  FT.SEARCH idx:top_secret "@years_active:[11 +inf] @name: Ja*"  -- matching names that start with "Ja" (requires at least 2 characters)
```

### 9. Aggregation queries
- Count number of rows:
```sql
  FT.AGGREGATE idx:top_secret "@years_active:[16 +inf]" GROUPBY 0 REDUCE COUNT 0 AS count  -- Equivalent to > 15
```

- Using average and grouping:
```sql
  FT.AGGREGATE idx:top_secret "@country:USA" GROUPBY 1 @country REDUCE AVG 1 @years_active AS avg_years   -- also works with SUM
```

- Find MIN within a group:
```sql
  FT.AGGREGATE idx:top_secret "*" GROUPBY 1 @country REDUCE MIN 1 @years_active AS min_years -- also works with MAX()
```
	
### 10. Cleanup
- Switch back to db1:
```sql
  SELECT 1
```

- Delete all data in db1:
```sql
  DEL new_database:top_secret:1 new_database:top_secret:2 new_database:top_secret:3 new_database:top_secret:4 new_database:top_secret:5
```

- List keys in db1:
```sql
  KEYS * -- Verify that all data was deleted
```

- List all databases again:
```sql
  INFO keyspace  -- Verify that only db0 has data
```

- Switch back to original database:
```sql
  SELECT 0
```

- Delete index:
```sql
  FT.DROPINDEX idx:top_secret
```

- List indexes again:
```sql
  FT._LIST  -- Verify that the index was deleted
```

- Delete `new_database:top_secret` keys in db0:
```sql
  DEL new_database:top_secret:1 new_database:top_secret:2 new_database:top_secret:3 new_database:top_secret:4 new_database:top_secret:5
```

- List all databases again:
```sql
  KEYS *  -- Verify that only original key is left
```

- List all databases again:
```sql
  INFO keyspace  -- Verify that the db1 was deleted
```

### 11. Exit Environment
- Exit Redis CLI:
```sql
  quit
```

### Notes:
- Workspace = logical database; the `db_workbench` workspace maps to Redis database 0 by default.
- Redis is a key-value store; there are no tables, schemas, or relational structures.
- Values can be different data types: strings, hashes, lists, sets, sorted sets, streams, etc.
- All commands are atomic, and most operations are in-memory, making Redis extremely fast.
- Data can optionally persist to disk (RDB snapshots or AOF), but primary storage is in memory.
- Commands like KEYS, FLUSHDB, and SELECT are Redis client commands, not standard SQL.
- Keys are unique within a database namespace; separate logical databases (0–15 by default) isolate keys.

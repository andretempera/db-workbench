# Redis Cheatsheet

<table>
  <tr>
    <td width="90" style="vertical-align: middle; padding-right: 10px;">
      <img src="https://cdn.jsdelivr.net/gh/devicons/devicon@latest/icons/redis/redis-original.svg" width="75" />
    </td>
    <td style="vertical-align: middle;">
      Redis is an in-memory key-value data store used for caching, fast lookups, messaging, and lightweight data structures. It stores data as <b>keys</b> mapped to <b>values</b> and supports multiple native data types.
    </td>
  </tr>
</table>

Default workspace: `db_workbench`

## Mental Model
- Redis stores data as **key → value** pairs.
- Values can be different data types (string, list, set, hash, etc.).
- There are no tables or schemas.
- Redis uses numbered logical databases (0–15 by default).
- In `db-workbench`, the default logical database is **0**.
- Operations are command-based, not query-based.
- Data is typically accessed by exact key lookup.

## Commands
### 1. Connect
```bash
make cli-redis
```

### 2. Show Current Workspace
```redis
SELECT 0  # Redis uses logical database 0 by default
```

### 3. List Workspaces
```redis
INFO keyspace  # Shows logical databases and key counts
```

### 4. Switch Workspace
```redis
SELECT 0  # Switch to logical database 0
```
(Redis uses numeric databases instead of named workspaces.)

### 5. Create Workspace
Redis logical databases are predefined.  
No creation command is required.

### 6. Create Structure (Key)
```redis
SET user:1:name "Alice"  # Creates a string key
```

### 7. Insert Data (Hash Example)
```redis
HSET user:1 name "Alice" age 30  # Creates a hash structure
```

### 8. Query All Data (By Key)
```redis
GET user:1:name  # Retrieves string value
```
For hash:
```redis
HGETALL user:1  # Retrieves all fields in hash
```

### 9. Query With Condition
Redis does not support conditional queries like SQL.

Keys must be known in advance or discovered via pattern matching:
```redis
KEYS user:*  # Finds matching keys (avoid in large datasets)
```

### 10. Update Data
```redis
SET user:1:name "Bob"  # Overwrites existing value
```
For hash:
```redis
HSET user:1 age 31  # Updates field in hash
```

### 11. Delete Data
```redis
DEL user:1:name  # Deletes key
```
For hash:
```redis
DEL user:1  # Deletes entire hash
```

### 12. Drop Structure
```redis
FLUSHDB  # Deletes all keys in current logical database
```
(Use carefully — this removes everything.)

### 13. Exit
```bash
exit
```

---

**Notes:**
- Workspace = logical DB; db_workbench maps to logical DB 0 by default.
- Key-value storage only; values can be strings, hashes, lists, sets, sorted sets, or streams.
- No tables or rows—think in terms of keys and data types.
- Commands are atomic; many operations are in-memory and extremely fast.
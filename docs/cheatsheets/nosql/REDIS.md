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
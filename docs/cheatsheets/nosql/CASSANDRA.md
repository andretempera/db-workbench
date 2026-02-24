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

Default workspace: `db_workbench`

## Mental Model
- Cassandra organizes data into **keyspaces → tables → rows**.
- Each table has a **primary key** for partitioning and uniqueness.
- Wide-column model allows flexible columns per row.
- Queries require knowing **primary keys or indexed columns**.
- Data is eventually consistent in a cluster.
- `db_workbench` keyspace is pre-created for experimentation.

## Commands
### 1. Connect
```bash
make cli-cassandra
```

### 2. Show Current Workspace
```cql
DESCRIBE keyspace db_workbench;  -- Shows current keyspace info
```

### 3. List Workspaces (Keyspaces)
```cql
DESCRIBE KEYSPACES;  -- Lists all keyspaces
```

### 4. Switch Workspace (Keyspace)
```cql
USE db_workbench;  -- Switch to keyspace
```

### 5. Create Workspace (Keyspace)
```cql
CREATE KEYSPACE example_keyspace
WITH replication = {'class':'SimpleStrategy', 'replication_factor':1};
```

### 6. List Structures (Tables)
```cql
DESCRIBE TABLES;  -- Lists tables in current keyspace
```

### 7. Create Structure (Table)
```cql
CREATE TABLE users (
    id UUID PRIMARY KEY,
    name text,
    age int
);  -- Creates table in current keyspace
```

### 8. Insert Data
```cql
INSERT INTO users (id, name, age)
VALUES (uuid(), 'Alice', 30);
```

### 9. Query All Data
```cql
SELECT * FROM users;
```

### 10. Query With Condition
```cql
SELECT * FROM users WHERE id = some_uuid;  -- Must use PRIMARY KEY or indexed column
```

### 11. Update Data
```cql
UPDATE users
SET age = 31
WHERE id = some_uuid;  -- Must use PRIMARY KEY
```

### 12. Delete Data
```cql
DELETE FROM users
WHERE id = some_uuid;  -- Must use PRIMARY KEY
```

### 13. Drop Structure (Table)
```cql
DROP TABLE users;
```

### 14. Exit
```bash
exit
```

---

**Notes:**
- Workspace = keyspace; pre-created db_workbench is your default.
- Queries must use primary keys or indexed columns; no full table scans.
- Syntax is close to SQL but more restricted.
- Tables are more flexible (wide-column), but design is query-driven.
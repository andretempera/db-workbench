# ClickHouse Cheatsheet

<table>
  <tr>
    <td width="90" style="vertical-align: middle; padding-right: 10px;">
      <img src="https://cdn.jsdelivr.net/gh/devicons/devicon@latest/icons/clickhouse/clickhouse-original.svg" width="75" />
    </td>
    <td style="vertical-align: middle;">
      ClickHouse is a high-performance, columnar database designed for analytical queries. Data is organized in <b>databases</b>, <b>tables</b>, and <b>columns</b>, optimized for OLAP workloads and aggregations on large datasets.
    </td>
  </tr>
</table>

Default workspace: `db_workbench`

## Mental Model
- **Database** = workspace; `db_workbench` exists by default.
- **Table** = structure storing columns in a columnar layout.
- Optimized for **read-heavy analytics** rather than transactional workloads.
- SQL is mostly standard, but types and some functions differ.
- Columnar storage enables fast aggregation on large datasets.
- No strong enforcement of constraints like foreign keys.

## Commands

### 1. Connect
```bash
make cli-clickhouse
# Or using clickhouse-client:
clickhouse-client --host localhost --port 8123 --user default --password
```

### 2. Show Current Workspace (Database)
```sql
SELECT currentDatabase(); -- Shows active database
```

### 3. List Workspaces (Databases)
```sql
SHOW DATABASES;
```

### 4. Switch Workspace (Database)
```sql
USE db_workbench;
```

### 5. Create Workspace (Database)
```sql
CREATE DATABASE example_db;
```

### 6. List Structures (Tables)
```sql
SHOW TABLES;
```

### 7. Create Structure (Table)
```sql
CREATE TABLE users (
    id UInt32,
    name String,
    age UInt8
) ENGINE = MergeTree()
ORDER BY id; -- MergeTree requires an ORDER BY key
```

### 8. Describe Structure
```sql
DESCRIBE TABLE users;
```

### 9. Insert Data
```sql
INSERT INTO users (id, name, age) VALUES (1, 'Andre', 30);
```

### 10. Query All Data
```sql
SELECT * FROM users;
```

### 11. Query With Condition
```sql
SELECT * FROM users WHERE age > 25;
```

### 12. Update Data
ClickHouse does not support row-level UPDATE in MergeTree tables directly.  
You typically use an `ALTER TABLE ... UPDATE` statement:
```sql
ALTER TABLE users UPDATE age = 31 WHERE name = 'Andre';
```

### 13. Delete Data
ClickHouse deletes via `ALTER TABLE ... DELETE`
```sql
ALTER TABLE users DELETE WHERE name = 'Andre';
```

### 14. Drop Structure (Table)
```sql
DROP TABLE users;
```

### 15. Exit
```sql
EXIT; -- Or Ctrl+D in clickhouse-client
```

---

**Notes:**
- ClickHouse is **columnar**, so row-level operations are slower; best for bulk inserts and analytical queries.
- Updates and deletes are **not like typical OLTP databases**—they trigger merges internally.
- Use `MergeTree` engine or derivatives for persistent tables; simpler engines like `Memory` are temporary.
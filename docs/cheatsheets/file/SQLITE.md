# SQLite Cheatsheet

<table>
  <tr>
    <td width="90" style="vertical-align: middle; padding-right: 10px;">
      <img src="https://cdn.jsdelivr.net/gh/devicons/devicon@latest/icons/sqlite/sqlite-original.svg" width="75" />
    </td>
    <td style="vertical-align: middle;">
      SQLite is a lightweight, <b>file-based</b> relational database system. It stores data in a single file and supports standard SQL, transactions, and relational tables. Ideal for local experiments, development, and embedded applications. <br>
      Visit <a>https://sqlite.org/index.html</a> for more information.
    </td>
  </tr>
</table>

Default workspace: `db_workbench.db`

## Mental Model
- SQLite has no server; the **database is a single file**.  
- Tables are the main storage units, storing **rows and columns**.  
- No schemas or clusters; everything lives in the file.  
- SQL syntax is standard but some PostgreSQL-specific commands are not supported.  
- Changes are transactional by default (ACID-compliant).  

## Commands
### 1. Connect
```bash
make cli-sqlite
```
Opens the SQLite shell connected to `db_workbench.db`

### 2. Show Current Workspace
```sql
PRAGMA database_list; -- Shows attached databases (main = db_workbench.db)
```

### 3. List Workspaces (Databases)
```sql
.databases  -- Lists attached database files
```

### 4. Switch Workspace
```sql
ATTACH 'example.db' AS example_db; -- Attaches another database file
```

### 5. Create Workspace
From system shell, use `sqlite3 data/sqlite/example.db`. It will create the file if needed and enter SQLite shell automatically.

### 6. List Structures (Tables)
```sql
.tables  -- Lists tables in current database
```

### 7. Create Structure (Table)
```sql
CREATE TABLE users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    age INTEGER
); -- Creates a new table
```

### 8. Describe Structure
```sql
.schema users  -- Shows table structure
```

### 9. Insert Data
```sql
INSERT INTO users (name, age)
VALUES ('Alice', 30); -- Inserts one row
```

### 10. Query All Data
```sql
SELECT * FROM users; -- Returns all rows
```

### 11. Query With Condition
```sql
SELECT * FROM users
WHERE age > 25; -- Filters rows
```

### 12. Update Data
```sql
UPDATE users
SET age = 31
WHERE name = 'Alice'; -- Updates matching rows
```

### 13. Delete Data
```sql
DELETE FROM users
WHERE name = 'Alice'; -- Deletes matching rows
```

### 14. Drop Structure
```sql
DROP TABLE users; -- Permanently removes table
```

### 15. Exit
```sql
.exit  -- Exit SQLite shell
```

---

**Notes:**
- Workspace = database file; db_workbench.db is pre-created by default.
- Single-file database; no server, no schemas, no clusters.
- Fully ACID-compliant with standard SQL support; some advanced SQL features may differ from PostgreSQL.
- SQLite commands like .tables, .databases, .schema, and .exit are shell meta-commands, not standard SQL.
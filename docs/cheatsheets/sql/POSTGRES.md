# PostgreSQL Cheatsheet

<table>
  <tr>
    <td width="90" style="vertical-align: middle; padding-right: 10px;">
      <img src="https://cdn.jsdelivr.net/gh/devicons/devicon@latest/icons/postgresql/postgresql-original.svg" width="75" />
    </td>
    <td style="vertical-align: middle;">
      PostgreSQL is a powerful, open-source relational database system known for reliability, standards compliance, and advanced SQL features. It follows a traditional relational model using <b>databases</b>, <b>schemas</b>, <b>tables</b>, and <b>rows</b>. <br>
      Visit <a>https://www.postgresql.org/</a> for more information.
    </td>
  </tr>
</table>

Default workspace: `db_workbench`

## Mental Model
- A PostgreSQL **cluster** can contain multiple databases.
- A **database** contains schemas.
- A **schema** contains tables.
- Data is stored in **tables** (rows and columns).
- PostgreSQL uses strongly-typed SQL.
- Commands starting with `\` are **psql client commands**, not SQL.

## Commands
### 1. Connect
```bash
make cli-postgres
```

### 2. Show Current Workspace

```sql
SELECT current_database(); -- Shows active database
```

### 3. List Workspaces (Databases)
```sql
\l  -- Lists all databases
```

### 4. Switch Workspace
```sql
\c db_workbench  -- Connect to specific database
```

### 5. Create Workspace
```sql
CREATE DATABASE example_db; -- Creates new database
```

### 6. List Structures (Tables)
```sql
\dt  -- Lists tables in current schema
```

### 7. Create Structure (Table)
```sql
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    age INT
); -- Creates a new table
```

### 8. Describe Structure
```sql
\d users  -- Shows table structure
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
\q  -- Exit psql
```

---

**Notes:**
- Workspace = database; db_workbench is pre-created by default.
- Follows standard relational model with tables, rows, columns, and strong typing.
- Supports transactions, constraints, indexes, and advanced SQL features.
- SQL commands and psql client commands (\dt, \d, \c) are separate—\ commands are client-only.
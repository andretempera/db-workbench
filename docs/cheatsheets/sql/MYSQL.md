# MySQL Cheatsheet

<table>
  <tr>
    <td width="90" style="vertical-align: middle; padding-right: 10px;">
      <img src="https://cdn.jsdelivr.net/gh/devicons/devicon@latest/icons/mysql/mysql-original.svg" width="75" />
    </td>
    <td style="vertical-align: middle;">
      MySQL is a widely-used, open-source relational database system known for reliability, ease of use, and broad ecosystem support. It follows a traditional relational model using <b>databases</b>, <b>schemas</b>, <b>tables</b>, and <b>rows</b>. <br>
      Visit <a>https://www.mysql.com/</a> for more information.
    </td>
  </tr>
</table>

Default workspace: `db_workbench`

## Mental Model
- A MySQL **server** can contain multiple databases.
- A **database** contains tables and optionally views, triggers, and stored procedures.
- Data is stored in **tables** (rows and columns).  
- MySQL uses loosely-typed SQL compared to PostgreSQL; `AUTO_INCREMENT` is common for primary keys.  
- Commands like `SHOW DATABASES` or `SHOW TABLES` are MySQL-specific client commands.  

## Commands
### 1. Connect
```bash
make cli-mysql
```

### 2. Show Current Workspace
```sql
SELECT DATABASE(); -- Shows active database
```

### 3. List Workspaces (Databases)
```sql
SHOW DATABASES; -- Lists all databases
```

### 4. Switch Workspace
```sql
USE db_workbench; -- Switch to specific database
```

### 5. Create Workspace
```sql
CREATE DATABASE example_db; -- Creates new database
```

### 6. List Structures (Tables)
```sql
SHOW TABLES; -- Lists tables in current database
```

### 7. Create Structure (Table)
```sql
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    age INT
); -- Creates a new table
```

### 8. Describe Structure
```sql
DESCRIBE users; -- Shows table structure
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
EXIT; -- Exit MySQL shell
```

---

**Notes:**
- Workspace = database; `db_workbench` is pre-created by default.
- Follows standard relational model with tables, rows, columns.
- Supports transactions, constraints, indexes, and basic stored procedures.
- MySQL commands like SHOW TABLES, DESCRIBE, USE are client-side; SQL syntax is mostly standard with some MySQL-specific extensions.
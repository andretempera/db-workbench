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

Default workspace: `db_workbench` (bucket)

## Mental Model
```txt
Cluster
 └── Bucket (workspace)
      └── Scope (optional grouping)
           └── Collection (optional grouping)
                └── Document (JSON, flexible schema, like a row in SQL)
```
- **Cluster** contains one or more buckets.
- **Bucket** = workspace; `db_workbench` exists by default.
- **Scopes and Collections** optional grouping documents inside a bucket (`_default` always exists).
- **Document** = JSON object stored in a bucket (like a row in SQL).
- Couchbase is optimized for **distributed access, caching, and flexible schema designs**.

## Commands
### 1. Connect
```bash
make cli-couchbase-native
```

### 2. Set Query Context (like "USE DATABASE" command)
```sql
\SET -query_context `db_workbench`._default;
```

### 3. Show Current Workspace (Bucket)
```sql
SELECT name FROM system:buckets WHERE name = "db_workbench";
```

### 4. List Workspaces (Buckets)
```sql
SELECT name FROM system:buckets;
```

### 5. Create Workspace (Bucket)
```sql
CREATE BUCKET `example_bucket`;
```

### 6. Create Primary Index (if not exists)
```sql
CREATE PRIMARY INDEX IF NOT EXISTS ON `db_workbench`;
```

### 7. List Structures (Collections, like tables)
```sql
SELECT name FROM system:collections WHERE `bucket`='db_workbench';
```

### 8. Create Structure (Collection, like creating a table);
```sql
CREATE COLLECTION `users` ON `bucket` `db_workbench`;
```

### 9. Insert Data (Equivalent to inserting a new row in a table)
```sql
INSERT INTO `db_workbench`._default.`users` (KEY, VALUE)
VALUES ("user::2", {
  "id": 2,
  "name": "Alice",
  "age": 30
});
```

### 10. Query All Data
```sql
SELECT * FROM `db_workbench`._default.`users`;
```

### 11. Query With Condition
```sql
SELECT * FROM `db_workbench`._default.`users`
WHERE id = 2;
```

### 12. Update Data
```sql
UPDATE `db_workbench`._default.`users`
SET age = 31
WHERE id = 2;
```

### 13. Delete Data
```sql
DELETE FROM `db_workbench`._default.`users`
WHERE id = 2;
```

### 14. Drop Structure (Collection)
```sql
DROP COLLECTION `users` ON BUCKET `db_workbench`;
```

### 15. Drop Workspace (Bucket)
```sql
DROP BUCKET `example_bucket`;
```

### 16. Exit CLI
```bash
\quit;
# or
Ctrl + D
```

---

**Notes:**
- Couchbase **does not enforce schemas**; JSON documents can vary in structure.
- Collections are optional; `_default` collection always exists in a bucket.
- Use `db_workbench` bucket for local experimentation.
- N1QL is SQL-like, but you query JSON fields (e.g., `user.name` instead of a column name).
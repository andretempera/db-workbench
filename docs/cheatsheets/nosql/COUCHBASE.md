# Couchbase Cheatsheet

<table>
  <tr>
    <td width="90" style="vertical-align: middle; padding-right: 10px;">
      <img src="https://cdn.jsdelivr.net/gh/devicons/devicon@latest/icons/couchbase/couchbase-original.svg" width="75" />
    </td>
    <td style="vertical-align: middle;">
      Couchbase is a distributed, document-oriented database that stores <b>JSON documents</b> in buckets. It supports key-value operations, N1QL (SQL-like query language), and indexes for efficient queries.
    </td>
  </tr>
</table>

Default workspace: `db_workbench` (bucket)

## Mental Model
- **Bucket** = workspace; `db_workbench` exists by default.
- **Document** = JSON object stored in a bucket (like a row in SQL).
- **Collections / Scopes** allow grouping documents inside a bucket (optional in simple setups).
- Queries use **N1QL**, a SQL-like language for JSON documents.
- Keys are unique per document; documents can have flexible, dynamic schemas.
- Couchbase is optimized for **distributed access, caching, and flexible schema designs**.

## Commands

### 1. Connect
```bash
make cli-couchbase
# Or using Python SDK:
from couchbase.cluster import Cluster
from couchbase.auth import PasswordAuthenticator
cluster = Cluster('couchbase://localhost', PasswordAuthenticator('Administrator','password'))
bucket = cluster.bucket('db_workbench')
collection = bucket.default_collection()
```

### 2. Show Current Workspace (Bucket)
```sql
SELECT b.* FROM `db_workbench` b LIMIT 1; -- Example of referencing the default bucket
```

### 3. List Workspaces (Buckets)
```sql
SELECT name FROM system:buckets;
```

### 4. Switch Workspace (Bucket)
```sql
USE `db_workbench`;
```

### 5. Create Workspace (Bucket)
```sql
CREATE BUCKET `example_bucket`;
```

### 6. List Structures (Collections)
```sql
SELECT name FROM system:collections WHERE keyspace_id='db_workbench';
```

### 7. Create Structure (Collection)
```sql
CREATE COLLECTION `users` ON BUCKET `db_workbench`;
```

### 8. Insert Data
```sql
INSERT INTO `db_workbench`.`_default`.`users` (KEY, VALUE)
VALUES ("user::1", {"id": 1, "name": "Andre", "project": "db-workbench"});
```

### 9. Query All Data
```sql
SELECT * FROM `db_workbench`.`_default`.`users`;
```

### 10. Query With Condition
```sql
SELECT * FROM `db_workbench`.`_default`.`users`
WHERE id = 1;
```

### 11. Update Data
```sql
UPDATE `db_workbench`.`_default`.`users`
SET project = "db-workbench-updated"
WHERE id = 1;
```

### 12. Delete Data
```sql
DELETE FROM `db_workbench`.`_default`.`users`
WHERE id = 1;
```

### 13. Drop Structure (Collection)
```sql
DROP COLLECTION `users` ON BUCKET `db_workbench`;
```

### 14. Drop Workspace (Bucket)
```sql
DROP BUCKET `example_bucket`;
```

### 15. Exit
```bash
exit  # Exit CLI
```

---

**Notes:**
- Couchbase **does not enforce schemas**; JSON documents can vary in structure.
- Collections are optional; `_default` collection always exists in a bucket.
- Use `db_workbench` bucket for local experimentation.
- N1QL is SQL-like, but you query JSON fields (e.g., `user.name` instead of a column name).
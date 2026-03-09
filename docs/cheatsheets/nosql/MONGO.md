# MongoDB Cheatsheet

<table>
  <tr>
    <td width="90" style="vertical-align: middle; padding-right: 10px;">
      <img src="https://cdn.jsdelivr.net/gh/devicons/devicon@latest/icons/mongodb/mongodb-original.svg" width="75" />
    </td>
    <td style="vertical-align: middle;">
      MongoDB is a NoSQL document database that stores data in flexible <b>JSON-like</b> documents (<b>BSON</b>). It is schema-flexible and designed for scalability and rapid development. <br>
      Visit <a>https://www.mongodb.com/</a> for more information.
    </td>
  </tr>
</table>

## Mental Model
```txt
Cluster (optional)
 └── Database (logical grouping)
      └── Collection (grouping)
           └── Document (BSON data)
```
- A MongoDB deployment can run as a single server, a replica set, or a sharded cluster.
- A **database** is the primary logical grouping and contains collections.
- A **collection** stores documents (similar to a table in relational systems).
- A **document** is a BSON object (binary JSON) identified by a unique _id (similar to a row).
- Data is stored in flexible, schema-optional format.


## Basic Commands & Workflow
### 1. Start Environment
- Open MongoDB CLI:
```bash
  make cli-mongo
```

### 2. Inspect Existing Setup
- Show all databases:
```sql
  show dbs
```

- Show collections:
```sql
  show collections
```

- Show collection structure:
```sql
  Object.keys(db.test.findOne() || {})
```

- Query all data in the `test` collection:
```sql
  db.test.find();
```

### 3. Insert a Row
- Insert a new row into the `test` collection:
```sql
  db.test.insertOne({ id: 2, name: "Paula", project: "new-project" });
```

- Check the data after insertion:
```sql
  db.test.find();  -- View the collection to see the new row added
```

### 4. Update Data
- Update data in the `test` table:
```sql
  db.test.updateOne({ id: 2 }, { $set: { project: "updated-project" } });  -- Updates document based on first matching id number
```

- Check the data after update:
```sql
  db.test.find();  -- View the collection again to check the updated document
```

### 5. Delete Data
- Delete a document from the `test` table:
```sql
  db.test.deleteOne({ id: 2 });  -- Deletes document based on first matching id number
```

- Check the data after deletion:
```sql
  db.test.find();  -- Collection should have just one entry again
```

### 6. Create a New Database
- Create and use a new database:
```sql
  use new_database  -- Single command creates and connects to the new database
```

- List all databases again:
```sql
  show dbs  -- Newly created database is empty and not yet visible
```

### 7. Add a New Table
- Create a new table:
```sql
  db.createCollection(
    "top_secret",
    {
      validator: {
        $jsonSchema: {
          bsonType: "object",
          required: ["id","name","organization","country","years_active"],
          properties: {
            id: { bsonType: "int" },
            name: { bsonType: "string" },
            organization: { bsonType: "string" },
            country: { bsonType: "string" },
            years_active: { bsonType: "int" }
          }
        }
      }
    }
  )
```

- List all databases again:
```sql
  show dbs  -- By adding a collection, the created database is now visible
```

- List collections again:
```sql
  show collections  -- Newly created collection should be visible
```

- List collections per bucket:
```sql
db.adminCommand({ listDatabases: 1 }).databases.forEach(function(d) {
    if (["admin","config","local"].includes(d.name)) return;
    print("Database: " + d.name);
    db = db.getSiblingDB(d.name);
    print("Collections: " + db.getCollectionNames().join(", "));
});
```

- Insert data into the new table:
```sql
  db.top_secret.insertMany([
    { id: 1, name: "James", organization: "MI6", country: "UK", years_active: 20 },
    { id: 2,name: "Ethan", organization: "IMF", country: "USA", years_active: 30 },
    { id: 3,name: "Nikita", organization: "Section One", country: "Russia", years_active: 8 },
    { id: 4,name: "Jason", organization: "CIA", country: "USA", years_active: 12 },
    { id: 5,name: "Sydney", organization: "SD-6", country: "USA", years_active: 10 }
  ]);
```

- Check the new collection's data:
```sql
  db.top_secret.find()
```

### 8. Conditional queries
- Match criteria:
```sql
  db.top_secret.find({ organization: "CIA" });
```

- Find MAX value in entire table:
```sql
  db.top_secret.aggregate([
  { $group: { _id: null, max_years_active: { $max: "$years_active" } } }
  ]); -- also works with $min
```

- Threshold criteria:
```sql
  db.top_secret.find({ years_active: { $lt: 15 } });  -- also works with lte(<=), gt(>) and gte(>=)
```

- Multiple criteria:
```sql
  db.top_secret.find({
  years_active: { $gt: 10 },
  name: { $regex: /^J/ }
  });  -- matching names that start with "J"
```


### 9. Aggregation queries
- Count number of rows:
```sql
  db.top_secret.countDocuments({
  years_active: { $gt: 15 }
  });  -- also works with gte(>=), lt(<) and lte(<=)
```

- Using average and grouping:
```sql
  db.top_secret.aggregate([
    { $match: { country: "USA" } },             // filter documents
    { $group: { _id: "$country", avg_years: { $avg: "$years_active" } } } // group by country and compute average
  ]);   -- also works with $sum
```

- Find MIN within a group:
```sql
  db.top_secret.aggregate([
  { $group: { _id: "$country", min_years: { $min: "$years_active" } } }
  ]); -- also works with $max
```
	
### 10. Cleanup
- Delete collection:
```sql
  db.top_secret.drop();
```

- List collections again:
```sql
  show collections  -- Verify that the "top_secret" collection was deleted
```

- Delete database:
```sql
  db.dropDatabase();  -- Drops the database you are currently in
```

- Switch back to original database:
```sql
  use db_workbench;
```

- List all databases again:
```sql
  show dbs  -- Verify that the "new_database" database was deleted
```

### 11. Exit Environment
- Exit MongoDB CLI:
```sql
  quit
```

### Notes:
- Workspace = database; the `db_workbench` database is pre-created by default.
- Collections store documents (JSON/BSON); schemas are optional and can vary between documents.
- Every document has a unique _id field, which acts as the primary key.
- Queries use MongoDB’s JSON-like operators ($eq, $gt, $in, etc.) rather than standard SQL.
- Indexes can be added to collections to improve query performance; _id is indexed by default.
- MongoDB can run as a standalone server, replica set, or sharded cluster; behavior may differ in distributed setups.
- Commands like show dbs, show collections, and db.collection.find() are MongoDB shell commands, not standard SQL.

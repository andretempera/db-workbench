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

Default workspace: `db_workbench`

## Mental Model
- A MongoDB **server** contains multiple databases.
- A **database** contains collections.
- A **collection** contains documents (JSON-like objects).
- Documents can have flexible structures (no enforced schema by default).
- Data is queried using JavaScript-style syntax.
- There are no joins in the traditional SQL sense.

## Commands

### 1. Connect
```bash
make cli-mongo
```

### 2. Show Current Workspace
```javascript
db  // Shows current database
```

### 3. List Workspaces (Databases)
```javascript
show dbs  // Lists all databases
```

### 4. Switch Workspace
```javascript
use db_workbench  // Switch to database
```

### 5. Create Workspace
```javascript
use example_db  // Creates database if it does not exist
```

### 6. List Structures (Collections)
```javascript
show collections  // Lists collections in current database
```

### 7. Create Structure (Collection)
```javascript
db.createCollection("users")  // Explicitly creates collection
```

(Note: Collections are also created automatically when inserting documents.)

### 8. Describe Structure
```javascript
db.users.findOne()  // Shows example document structure
```

(MongoDB does not enforce a fixed schema.)

### 9. Insert Data
```javascript
db.users.insertOne({
  name: "Alice",
  age: 30
});  // Inserts one document
```

### 10. Query All Data
```javascript
db.users.find();  // Returns all documents
```

### 11. Query With Condition
```javascript
db.users.find({ age: { $gt: 25 } });  // Filters documents
```

### 12. Update Data
```javascript
db.users.updateOne(
  { name: "Alice" },
  { $set: { age: 31 } }
);  // Updates matching document
```

### 13. Delete Data
```javascript
db.users.deleteOne(
  { name: "Alice" }
);  // Deletes matching document
```

### 14. Drop Structure
```javascript
db.users.drop();  // Permanently removes collection
```

### 15. Exit
```bash
exit
```

---

**Notes:**
- Workspace = database; pre-created db_workbench is your default.
- Collections hold documents (flexible JSON/BSON); no enforced schema.
- Queries use MongoDB query operators ($eq, $gt, $in, etc.) instead of standard SQL.
- Indexes improve performance; _id is always the primary key.
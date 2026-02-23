// init.js

db = db.getSiblingDB("db_workbench");

db.test.updateOne(
    { id: 1 },
    { $set: { name: "Andre", project: "db-workbench" } },
    { upsert: true }
);

print("MongoDB initialization complete: 'test' document in 'db_workbench'");
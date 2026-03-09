// init.js

function waitForMongo(maxRetries = 10, delayMs = 1000) {
    let retries = 0;
    while (retries < maxRetries) {
        try {
            db.adminCommand({ ping: 1 });
            print("MongoDB is ready!");
            return;
        } catch (e) {
            print("Waiting for MongoDB to be ready...");
            retries++;
            sleep(delayMs);
        }
    }
    throw new Error("MongoDB did not start in time");
}

waitForMongo();

db = db.getSiblingDB("db_workbench");

db.test.updateOne(
    { id: 1 },
    { $set: { name: "Andre", project: "db-workbench" } },
    { upsert: true }
);


// Create db_workbench if it doesn't exist
db = db.getSiblingDB('db_workbench');


// Check if the collection exists
if (db.getCollectionNames().indexOf("test") === -1) {
    print("Creating collection 'test'...");
    db.createCollection("test");
}

// Ensure the document exists
db.test.updateOne(
    { id: 1 },
    { $set: { name: "Andre", project: "db-workbench" } },
    { upsert: true }
);

print("MongoDB initialization complete: 'test' document in 'db_workbench'");
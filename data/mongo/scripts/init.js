// init.js
const { MongoClient } = require("mongodb");

const MONGO_USER = process.env.MONGO_INITDB_ROOT_USERNAME || "root";
const MONGO_PASS = process.env.MONGO_INITDB_ROOT_PASSWORD || "rootpass";
const MONGO_HOST = process.env.MONGO_HOST || "localhost";
const MONGO_PORT = process.env.MONGO_PORT || 27017;
const MONGO_DB = process.env.MONGO_DB || "testdb";

const url = `mongodb://${MONGO_USER}:${MONGO_PASS}@${MONGO_HOST}:${MONGO_PORT}`;

async function init() {
    const client = new MongoClient(url);
    await client.connect();

    const db = client.db(MONGO_DB);
    await db.collection("test").updateOne(
        { id: 1 },
        { $set: { name: "Andre", project: "db-workbench" } },
        { upsert: true }
    );

    console.log(`MongoDB initialization complete: 'test' document in '${MONGO_DB}'`);
    await client.close();
}

init().catch(err => console.error(err));
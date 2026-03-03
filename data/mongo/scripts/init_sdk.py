import os
import sys
import time
import code
from pymongo import MongoClient
from pymongo.errors import ConnectionFailure

# Env variables
MONGO_HOST = os.getenv("MONGO_HOST", "mongo")
MONGO_PORT = int(os.getenv("MONGO_PORT", 27017))
MONGO_USER = os.getenv("MONGO_USER", "root")
MONGO_PASSWORD = os.getenv("MONGO_PASSWORD", "rootpass")

AUTH_DB = os.getenv("MONGO_AUTH_DB", "admin")
WORK_DB = os.getenv("MONGO_DB", "db_workbench")

# Connect to MongoDB with retry
client = None
for attempt in range(10):
    try:
        client = MongoClient(
            host=MONGO_HOST,
            port=MONGO_PORT,
            username=MONGO_USER,
            password=MONGO_PASSWORD,
            authSource=AUTH_DB,
            serverSelectionTimeoutMS=2000
        )
        client.admin.command("ping")
        break
    except ConnectionFailure:
        print(f"Attempt {attempt+1}/10: MongoDB not ready, retrying in 3s...")
        time.sleep(3)
else:
    print("Error: Unable to connect to MongoDB.")
    sys.exit(1)

db = client[WORK_DB]

# Initialize test collection if empty
print("Ensuring 'test' collection has base document...")

db.test.update_one(
    {"id": 1},
    {"$set": {"name": "Andre", "project": "db-workbench"}},
    upsert=True
)

print("\n||| MongoDB SDK Python CLI |||")
print(f"Connected to database '{WORK_DB}'")
print("Objects available:")
print("    - client")
print("    - db\n")

code.interact(local=globals())
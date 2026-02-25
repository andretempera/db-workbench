# ./data/couchbase/scripts/sdk_shell.py
import os
import code
from couchbase.cluster import Cluster
from couchbase.auth import PasswordAuthenticator

# Environment variables with defaults
COUCHBASE_HOST = os.getenv("COUCHBASE_HOST", "localhost")
COUCHBASE_USER = os.getenv("COUCHBASE_USER", "Administrator")
COUCHBASE_PASSWORD = os.getenv("COUCHBASE_PASSWORD", "password")
COUCHBASE_BUCKET = os.getenv("COUCHBASE_BUCKET", "db_workbench")

# Connect to cluster
cluster = Cluster(f"couchbase://{COUCHBASE_HOST}", PasswordAuthenticator(COUCHBASE_USER, COUCHBASE_PASSWORD))

# Connect to the bucket and default collection
bucket = cluster.bucket(COUCHBASE_BUCKET)
collection = bucket.default_collection()

print(f"Connected to Couchbase bucket '{bucket.name}'")
print("Variables available in this interactive shell:")
print("  - cluster: Couchbase Cluster object")
print("  - bucket: Connected Couchbase bucket")
print("  - collection: Default collection for queries/documents")

# Launch interactive shell
code.interact(local=globals())
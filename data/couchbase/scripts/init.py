import os
from couchbase.cluster import Cluster
from couchbase.auth import PasswordAuthenticator
from couchbase.collection import UpsertOptions

# Load connection info from environment variables
COUCHBASE_HOST = os.getenv("COUCHBASE_HOST", "localhost")
COUCHBASE_USER = os.getenv("COUCHBASE_USER", "Administrator")
COUCHBASE_PASSWORD = os.getenv("COUCHBASE_PASSWORD", "password")
COUCHBASE_BUCKET = os.getenv("COUCHBASE_BUCKET", "default")

# Connect to Couchbase
cluster = Cluster(f"couchbase://{COUCHBASE_HOST}", PasswordAuthenticator(COUCHBASE_USER, COUCHBASE_PASSWORD))
bucket = cluster.bucket(COUCHBASE_BUCKET)
collection = bucket.default_collection()

# Upsert a simple test document
collection.upsert("test:1", {"id": 1, "name": "Andre", "project": "db-workbench"})

print(f"Couchbase initialization complete: document 'test:1' added to bucket '{COUCHBASE_BUCKET}'.")
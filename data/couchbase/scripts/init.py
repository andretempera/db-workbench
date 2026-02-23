import os
import time
from couchbase.cluster import Cluster
from couchbase.auth import PasswordAuthenticator
from couchbase.management.buckets import BucketSettings, CreateBucketSettings
from couchbase.exceptions import BucketAlreadyExistsException

# Environment variables
COUCHBASE_HOST = os.getenv("COUCHBASE_HOST", "localhost")
COUCHBASE_USER = os.getenv("COUCHBASE_USER", "Administrator")
COUCHBASE_PASSWORD = os.getenv("COUCHBASE_PASSWORD", "password")
COUCHBASE_BUCKET = os.getenv("COUCHBASE_BUCKET", "db_workbench")

# Connect to cluster
cluster = Cluster(f"couchbase://{COUCHBASE_HOST}", PasswordAuthenticator(COUCHBASE_USER, COUCHBASE_PASSWORD))
mgr = cluster.buckets()

# Create bucket if it doesn't exist
try:
    mgr.create_bucket(CreateBucketSettings(
        name=COUCHBASE_BUCKET,
        ram_quota_mb=100
    ))
    print(f"Bucket '{COUCHBASE_BUCKET}' created.")
except BucketAlreadyExistsException:
    print(f"Bucket '{COUCHBASE_BUCKET}' already exists.")

# Wait a few seconds for bucket to be ready
time.sleep(5)

bucket = cluster.bucket(COUCHBASE_BUCKET)
collection = bucket.default_collection()

# Upsert test document
collection.upsert("test:1", {"id": 1, "name": "Andre", "project": "db-workbench"})

print(f"Couchbase initialization complete: document 'test:1' added to bucket '{COUCHBASE_BUCKET}'.")
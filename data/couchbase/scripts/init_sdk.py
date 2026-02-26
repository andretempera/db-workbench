import os
import code
from couchbase.cluster import Cluster
from couchbase.auth import PasswordAuthenticator
from couchbase.exceptions import CouchbaseException


# Environment variables with defaults
COUCHBASE_HOST = os.getenv("COUCHBASE_HOST", "localhost")
COUCHBASE_USER = os.getenv("COUCHBASE_USER", "Administrator")
COUCHBASE_PASSWORD = os.getenv("COUCHBASE_PASSWORD", "password")
COUCHBASE_BUCKET = os.getenv("COUCHBASE_BUCKET", "db_workbench")


# Basic checks for environment variables
if not all([COUCHBASE_HOST, COUCHBASE_USER, COUCHBASE_PASSWORD, COUCHBASE_BUCKET]):
    print("Error: Missing one or more required environment variables.")
    exit(1)


# Connect to Couchbase Cluster
try:
    print(f"Connecting to Couchbase cluster at couchbase://{COUCHBASE_HOST}...")
    cluster = Cluster(f"couchbase://{COUCHBASE_HOST}", PasswordAuthenticator(COUCHBASE_USER, COUCHBASE_PASSWORD))
    bucket = cluster.bucket(COUCHBASE_BUCKET)
    collection = bucket.default_collection()
    print(f"Connected to Couchbase bucket '{bucket.name}'")
except CouchbaseException as e:
    print(f"Error connecting to Couchbase: {e}")
    exit(1)


# Launch interactive shell
code.interact(local=globals())
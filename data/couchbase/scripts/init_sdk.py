import os
import code
from couchbase.cluster import Cluster
from couchbase.auth import PasswordAuthenticator
from couchbase.exceptions import CouchbaseException


# Environment variables with defaults
COUCHBASE_HOST = os.getenv("COUCHBASE_HOST", "couchbase")
COUCHBASE_USER = os.getenv("COUCHBASE_USER", "Administrator")
COUCHBASE_PASSWORD = os.getenv("COUCHBASE_PASSWORD", "password")
COUCHBASE_BUCKET = os.getenv("COUCHBASE_BUCKET", "db_workbench")


# Basic checks
if not all([COUCHBASE_HOST, COUCHBASE_USER, COUCHBASE_PASSWORD, COUCHBASE_BUCKET]):
    print("Error: Missing one or more required environment variables.")
    exit(1)


# Connection string logic
if COUCHBASE_HOST == "couchbase":
    connection_string = f"couchbase://{COUCHBASE_HOST}"
else:
    connection_string = f"couchbase://127.0.0.1"


# Connect to Couchbase
cluster = None
bucket = None
collection = None

try:
    print(f"Connecting to Couchbase cluster at: {connection_string}...")

    authenticator = PasswordAuthenticator(COUCHBASE_USER, COUCHBASE_PASSWORD)
    cluster = Cluster(connection_string, authenticator=authenticator)
    bucket = cluster.bucket(COUCHBASE_BUCKET)
    collection = bucket.default_collection()

    print(f"\n||| Couchbase SDK Python CLI |||")
    print(f"Connected to Couchbase bucket '{bucket.name}'")
    print("Objects available:")
    print("    - cluster")
    print("    - bucket")
    print(f"    - collection\n")

except CouchbaseException as e:
    print(f"Error connecting to Couchbase: {e}")
    exit(1)


# Launch interactive shell
code.interact(local=globals())
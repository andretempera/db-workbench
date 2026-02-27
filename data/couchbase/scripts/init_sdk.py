import os
import code
from couchbase.cluster import Cluster
from couchbase.auth import PasswordAuthenticator
from couchbase.exceptions import CouchbaseException


# Environment variables with defaults
COUCHBASE_HOST = os.getenv("COUCHBASE_HOST", "couchbase")  # default to 'couchbase' but can be overwritten
COUCHBASE_USER = os.getenv("COUCHBASE_USER", "Administrator")
COUCHBASE_PASSWORD = os.getenv("COUCHBASE_PASSWORD", "password")
COUCHBASE_BUCKET = os.getenv("COUCHBASE_BUCKET", "db_workbench")

# Debugging: print the values of environment variables
print(f"COUCHBASE_HOST: {COUCHBASE_HOST}")
print(f"COUCHBASE_USER: {COUCHBASE_USER}")
print(f"COUCHBASE_PASSWORD: {COUCHBASE_PASSWORD}")
print(f"COUCHBASE_BUCKET: {COUCHBASE_BUCKET}")

# Basic checks for environment variables
if not all([COUCHBASE_HOST, COUCHBASE_USER, COUCHBASE_PASSWORD, COUCHBASE_BUCKET]):
    print("Error: Missing one or more required environment variables.")
    exit(1)

# Modify the connection string dynamically based on host access method
if COUCHBASE_HOST == "couchbase":
    # Inside Docker container, use internal Docker network name
    connection_string = f"couchbase://{COUCHBASE_HOST}"
else:
    # Outside Docker or testing with localhost, use 127.0.0.1 for localhost access
    connection_string = f"couchbase://127.0.0.1"

# Debugging: print connection string being used
print(f"Connecting to Couchbase cluster at: {connection_string}...")

# Create authenticator and check if connection works
try:
    authenticator = PasswordAuthenticator(COUCHBASE_USER, COUCHBASE_PASSWORD)
    print("Authenticator created successfully.")
    
    # Initialize the Cluster with authenticator
    cluster = Cluster(connection_string, authenticator=authenticator)
    bucket = cluster.bucket(COUCHBASE_BUCKET)
    collection = bucket.default_collection()

    print(f"Connected to Couchbase bucket '{bucket.name}'")

except CouchbaseException as e:
    print(f"Error connecting to Couchbase: {e}")
    exit(1)

# Launch interactive shell
code.interact(local=globals())
import os
import sys
import time
import code

from cassandra.cluster import Cluster
from cassandra.auth import PlainTextAuthProvider
from cassandra.policies import DCAwareRoundRobinPolicy
from cassandra.cluster import NoHostAvailable


# Environment variables with defaults
CASSANDRA_HOST = os.getenv("CASSANDRA_HOST", "cassandra")
CASSANDRA_PORT = int(os.getenv("CASSANDRA_PORT", "9042"))
CASSANDRA_USER = os.getenv("CASSANDRA_USER", "cassandra")
CASSANDRA_PASSWORD = os.getenv("CASSANDRA_PASSWORD", "cassandra")
CASSANDRA_KEYSPACE = "db_workbench"


# Basic validation
if not all([CASSANDRA_HOST, CASSANDRA_PORT, CASSANDRA_USER, CASSANDRA_PASSWORD]):
    print("Error: Missing one or more required Cassandra environment variables.")
    sys.exit(1)


print(f"Connecting to Cassandra cluster at {CASSANDRA_HOST}:{CASSANDRA_PORT}...")


# Authentication provider
auth_provider = PlainTextAuthProvider(
    username=CASSANDRA_USER,
    password=CASSANDRA_PASSWORD
)


cluster = None
session = None


# Retry logic (in case Cassandra is still warming up)
for attempt in range(10):
    try:
        cluster = Cluster(
            [CASSANDRA_HOST],
            port=CASSANDRA_PORT,
            auth_provider=auth_provider,
            load_balancing_policy=DCAwareRoundRobinPolicy()
        )

        session = cluster.connect()
        session.set_keyspace(CASSANDRA_KEYSPACE)

        break

    except NoHostAvailable:
        print(f"Attempt {attempt + 1}/10: Cassandra not ready, retrying in 3 seconds...")
        time.sleep(3)
else:
    print("Error: Unable to connect to Cassandra after multiple attempts.")
    sys.exit(1)


print("\n||| Cassandra SDK Python CLI |||")
print(f"Connected to keyspace '{CASSANDRA_KEYSPACE}'")
print("Objects available:")
print("    - cluster")
print("    - session\n")


# Launch interactive shell
code.interact(local=globals())
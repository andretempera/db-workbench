#!/usr/bin/env python3
import os
import sys
import time
import code
from elasticsearch import Elasticsearch, exceptions

# Environment variables with defaults
ELASTIC_HOST = os.getenv("ELASTIC_HOST", "localhost")
ELASTIC_PORT = int(os.getenv("ELASTIC_PORT", 9200))
ELASTIC_USER = os.getenv("ELASTIC_USER", "elastic")
ELASTIC_PASSWORD = os.getenv("ELASTIC_PASSWORD", "rootpass")
ELASTIC_INDEX = os.getenv("ELASTIC_INDEX", "db_workbench")

# Basic validation
if not all([ELASTIC_HOST, ELASTIC_PORT, ELASTIC_USER, ELASTIC_PASSWORD, ELASTIC_INDEX]):
    print("Error: Missing one or more required Elasticsearch environment variables.")
    sys.exit(1)

print(f"Connecting to Elasticsearch at {ELASTIC_HOST}:{ELASTIC_PORT}...")

# Initialize client
es = Elasticsearch(
    f"https://{ELASTIC_HOST}:{ELASTIC_PORT}",
    basic_auth=(ELASTIC_USER, ELASTIC_PASSWORD),
    verify_certs=False  # dev / Docker self-signed certs
)

# Retry logic
MAX_ATTEMPTS = 10
SLEEP_SECONDS = 3

for attempt in range(1, MAX_ATTEMPTS + 1):
    try:
        if es.ping():
            print(f"Connected to Elasticsearch at {ELASTIC_HOST}:{ELASTIC_PORT}")
            break
        else:
            raise exceptions.ConnectionError("Cluster ping returned False")
    except exceptions.ConnectionError as e:
        print(f"Attempt {attempt}/{MAX_ATTEMPTS}: Elasticsearch not ready ({e}), retrying in {SLEEP_SECONDS}s...")
        time.sleep(SLEEP_SECONDS)
else:
    print("Error: Unable to connect to Elasticsearch after multiple attempts.")
    sys.exit(1)

# Print CLI-style banner
print("\n||| Elasticsearch SDK Python CLI |||")
print(f"Connected to index '{ELASTIC_INDEX}'")
print("Objects available:")
print("    - es (Elasticsearch client)\n")

# Launch interactive shell
code.interact(local=globals())
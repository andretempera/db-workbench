import os
import sys
import time
import code
from elasticsearch import Elasticsearch
from elasticsearch.exceptions import ConnectionError, NotFoundError

# Environment variables with defaults
ELASTIC_HOST = os.getenv("ELASTIC_HOST", "elasticsearch")  # Set to 'elasticsearch' (service name)
ELASTIC_PORT = int(os.getenv("ELASTIC_PORT", "9200"))
ELASTIC_USER = os.getenv("ELASTIC_USER", "elastic")
ELASTIC_PASSWORD = os.getenv("ELASTIC_PASSWORD", "rootpass")

print(f"ELASTIC_HOST: {ELASTIC_HOST}")
print(f"ELASTIC_PORT: {ELASTIC_PORT}")
print(f"ELASTIC_USER: {ELASTIC_USER}")
print(f"ELASTIC_PASSWORD: {ELASTIC_PASSWORD}")

# Basic validation
if not all([ELASTIC_HOST, ELASTIC_PORT, ELASTIC_USER, ELASTIC_PASSWORD]):
    print("Error: Missing one or more required Elasticsearch environment variables.")
    sys.exit(1)

print(f"Connecting to Elasticsearch at https://{ELASTIC_HOST}:{ELASTIC_PORT}...")  

# Initialize Elasticsearch client with authentication and bypass certificate verification
try:
    es = Elasticsearch(
        [f"https://{ELASTIC_HOST}:{ELASTIC_PORT}"],
        basic_auth=(ELASTIC_USER, ELASTIC_PASSWORD),
        verify_certs=False,  # Disable SSL certificate verification
    )

    # Test the connection
    if not es.ping():
        print(f"Error: Unable to ping Elasticsearch at https://{ELASTIC_HOST}:{ELASTIC_PORT}.")
        sys.exit(1)

    print("\n||| Elasticsearch SDK Python CLI |||")
    print(f"Connected to Elasticsearch at {ELASTIC_HOST}:{ELASTIC_PORT}")
    print("Objects available:")
    print("    - es (Elasticsearch client)\n")

except (ConnectionError, NotFoundError) as e:
    print(f"Error: Unable to connect to Elasticsearch ({e}). Please check if Elasticsearch is running.")
    sys.exit(1)

# Launch interactive shell
code.interact(local=globals())
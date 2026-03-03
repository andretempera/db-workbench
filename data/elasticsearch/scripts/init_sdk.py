import os
import sys
import time
import code
from elasticsearch import Elasticsearch
from elasticsearch.exceptions import ConnectionError

ELASTICSEARCH_HOST = os.getenv("ELASTICSEARCH_HOST", "elasticsearch")
ELASTICSEARCH_PORT = int(os.getenv("ELASTICSEARCH_PORT", "9200"))

if not all([ELASTICSEARCH_HOST, ELASTICSEARCH_PORT]):
    print("Error: Missing required Elasticsearch environment variables.")
    sys.exit(1)

print(f"Connecting to Elasticsearch at {ELASTICSEARCH_HOST}:{ELASTICSEARCH_PORT}...")

es = None

# Retry logic
for attempt in range(10):
    try:
        es = Elasticsearch([{"host": ELASTICSEARCH_HOST, "port": ELASTICSEARCH_PORT}])
        if es.ping():
            break
    except ConnectionError:
        print(f"Attempt {attempt + 1}/10: Elasticsearch not ready, retrying in 3 seconds...")
        time.sleep(3)
else:
    print("Error: Unable to connect to Elasticsearch after multiple attempts.")
    sys.exit(1)

print("\n||| Elasticsearch SDK Python CLI |||")
print("Objects available:")
print("    - es (Elasticsearch client)\n")

code.interact(local=globals())
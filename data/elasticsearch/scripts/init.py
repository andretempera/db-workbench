import os
import time
from elasticsearch import Elasticsearch

print("Starting Initialization Script...")

ELASTIC_HOST = "localhost"
ELASTIC_PORT = int(os.getenv("ELASTIC_PORT", "9200")) 
ELASTIC_USER = os.getenv("ELASTIC_USER")
ELASTIC_PASSWORD = os.getenv("ELASTIC_PASSWORD")

max_attempts = 30

print(f"Connecting to Elasticsearch at {ELASTIC_HOST}:{ELASTIC_PORT}...")
for attempt in range(1, max_attempts + 1):
    try:
        es = Elasticsearch(
            f"https://{ELASTIC_HOST}:{ELASTIC_PORT}",
            basic_auth=(ELASTIC_USER, ELASTIC_PASSWORD),
            verify_certs=False,
            request_timeout=3
        )

        if es.ping():
            print("Elasticsearch is ready!")
            break

    except Exception:
        pass

    time.sleep(2)
else:
    raise RuntimeError("Elasticsearch did not start in time.")

index_name = "db_workbench"
doc = {"id": 1, "name": "Andre", "project": "db-workbench"}

if not es.indices.exists(index=index_name):
    print("Creating index...")
    es.indices.create(index=index_name)

es.index(index=index_name, id=1, document=doc)

print(f"Elasticsearch initialization complete: '{index_name}' document created.")

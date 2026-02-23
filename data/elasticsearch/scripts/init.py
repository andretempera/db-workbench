import os
from elasticsearch import Elasticsearch

# Environment variables
ELASTIC_HOST = os.getenv("ELASTIC_HOST", "localhost")
ELASTIC_PORT = int(os.getenv("ELASTIC_PORT", 9200))
ELASTIC_USER = os.getenv("ELASTIC_USER", "elastic")
ELASTIC_PASSWORD = os.getenv("ELASTIC_PASSWORD", "rootpass")

# Connect
es = Elasticsearch(
    f"http://{ELASTIC_HOST}:{ELASTIC_PORT}",
    basic_auth=(ELASTIC_USER, ELASTIC_PASSWORD)
)

# Use db_workbench index for consistency
index_name = "db_workbench_test"

doc = {"id": 1, "name": "Andre", "project": "db-workbench"}

# Create or update a single test document
es.index(index=index_name, id=1, document=doc)

print(f"Elasticsearch initialization complete: '{index_name}' document created.")
import os
from elasticsearch import Elasticsearch

# Load connection info from environment variables
ELASTIC_HOST = os.getenv("ELASTIC_HOST", "localhost")
ELASTIC_PORT = os.getenv("ELASTIC_PORT", "9200")
ELASTIC_USER = os.getenv("ELASTIC_USER", "elastic")
ELASTIC_PASSWORD = os.getenv("ELASTIC_PASSWORD", "rootpass")

es = Elasticsearch(
    f"http://{ELASTIC_HOST}:{ELASTIC_PORT}",
    basic_auth=(ELASTIC_USER, ELASTIC_PASSWORD)
)

doc = {"id": 1, "name": "Andre", "project": "db-workbench"}

# Create or update a simple test document in index "test"
es.index(index="test", id=1, document=doc)

print("Elasticsearch initialization complete: 'test' document created.")
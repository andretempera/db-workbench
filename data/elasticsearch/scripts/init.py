import os
import time
from elasticsearch import Elasticsearch
from elasticsearch import Elasticsearch, exceptions

print("Waiting 45 seconds for Elasticsearch to fully start...")
time.sleep(45)

ELASTIC_HOST = os.getenv("ELASTIC_HOST", "localhost")
ELASTIC_PORT = int(os.getenv("ELASTIC_PORT", 9200))
ELASTIC_USER = os.getenv("ELASTIC_USER", "elastic")
ELASTIC_PASSWORD = os.getenv("ELASTIC_PASSWORD", "rootpass")

# Retry until Elasticsearch is ready
max_attempts = 10
for attempt in range(max_attempts):
    try:
        es = Elasticsearch(
            f"https://{ELASTIC_HOST}:{ELASTIC_PORT}",
            basic_auth=(ELASTIC_USER, ELASTIC_PASSWORD),
            verify_certs=False  # ignore self-signed cert in Docker
        )
        if es.ping():
            print("Elasticsearch is ready!")
            break
    except Exception as e:
        print(f"Elasticsearch not ready (attempt {attempt+1})... retrying in 3s")
        time.sleep(3)
else:
    raise RuntimeError("Elasticsearch did not become ready after multiple attempts.")

# Use 'db_workbench' index
index_name = "db_workbench"

doc = {"id": 1, "name": "Andre", "project": "db-workbench"}

# Create index if it doesn't exist
if not es.indices.exists(index=index_name):
    es.indices.create(index=index_name)

# Insert or update test document
es.index(index=index_name, id=1, document=doc)

print(f"Elasticsearch initialization complete: '{index_name}' document created.")

KIBANA_USER = os.getenv("KIBANA_ELASTICSEARCH_USER", "kibana_user")
KIBANA_PASSWORD = os.getenv("KIBANA_ELASTICSEARCH_PASSWORD", "kibana_password")

try:
    es.security.put_user(
        username=KIBANA_USER,
        body={
            "password": KIBANA_PASSWORD,
            "roles": ["kibana_admin"],
            "full_name": "Kibana Admin User"
        }
    )
    print(f"Kibana user '{KIBANA_USER}' created/updated successfully.")
except exceptions.AuthenticationException:
    print(f"Error: Could not authenticate to create Kibana user.")
except exceptions.AuthorizationException:
    print(f"Error: User does not have permission to create Kibana user.")
except Exception as e:
    print(f"Error creating Kibana user: {e}")
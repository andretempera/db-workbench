from couchbase.cluster import Cluster
from couchbase.auth import PasswordAuthenticator
from couchbase.collection import UpsertOptions

cluster = Cluster("couchbase://localhost", PasswordAuthenticator("Administrator", "password"))
bucket = cluster.bucket("default")
collection = bucket.default_collection()

collection.upsert("test:1", {"id": 1, "name": "Andre", "project": "local-databases"})
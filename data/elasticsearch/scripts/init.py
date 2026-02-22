from elasticsearch import Elasticsearch

es = Elasticsearch("http://localhost:9200", basic_auth=("elastic", "rootpass"))

doc = {"id": 1, "name": "Andre", "project": "local-databases"}
es.index(index="test", id=1, document=doc)
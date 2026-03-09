# Elasticsearch Cheatsheet

<table>
  <tr>
    <td width="90" style="vertical-align: middle; padding-right: 10px;">
      <img src="https://cdn.jsdelivr.net/gh/devicons/devicon@latest/icons/elasticsearch/elasticsearch-original.svg" width="75" />
    </td>
    <td style="vertical-align: middle;">
      Elasticsearch is a distributed search and analytics engine. Data is stored in <b>indices</b>, which contain <b>documents</b> in JSON format. It is optimized for full-text search, aggregations, and near real-time analytics. <br>
      Visit <a>https://www.elastic.co/elasticsearch</a> for more information.
    </td>
  </tr>
</table>

## Mental Model
```txt
Cluster
 └── Index (logical grouping)
      └── Shard (data partition)
           └── Document (JSON data)
```
- An Elasticsearch **cluster** contains one or more nodes (servers that hold data), and contains one or more indexes.
- An **index** is the primary logical grouping of data (similar to a merging of database and table conceptually). It is split into **shards**, which distribute data across nodes.
- A **document** is a JSON object stored inside an index, and are automatically assigned to shards (similar to a row).
- Elasticsearch uses a REST-based JSON API (not SQL by default, though SQL support exists).



## Basic Commands & Workflow
### 1. Start Environment
```sql
-- Elasticsearch does not provide a dedicated interactive CLI like SQL databases.
-- Once the container or service is running, you can interact with it via HTTP requests using tools such as `curl`, `http`, `Postman`, or language-specific SDKs.
-- The REST API allows you to query, insert, update, and delete documents immediately after the service is available.
```

### 2. Inspect Existing Setup
- Show all indexes:
```sql
-- All commands require connecting via `user:password https://host:port` pattern. Provided examples use default .env values.
  curl -k -s -u elastic:rootpass "https://localhost:9200/_cat/indices?v" | awk '$6 > 0'
```

- Show index structure:
```sql
  curl -k -s -u elastic:rootpass "https://localhost:9200/db_workbench_test/_mapping?pretty"
```

- Query all data in the `db_workbench_test` index:
```sql
  curl -k -s -u elastic:rootpass "https://localhost:9200/db_workbench_test/_search?q=*&_source=true&pretty"
```

### 3. Insert a Row
- Insert a new document into the `db_workbench_test` index:
```sql
  curl -k -s -u elastic:rootpass -X POST "https://localhost:9200/db_workbench_test/_doc/2" \
  -H 'Content-Type: application/json' \
  -d '{"name": "Paula", "project": "new-project"}'
```

- Check the data after insertion:
```sql
  curl -k -s -u elastic:rootpass "https://localhost:9200/db_workbench_test/_search?q=*&_source=true&pretty"  -- View the index to see the new document added
```

### 4. Update Data
- Update document in the `db_workbench_test` index:
```sql
  curl -k -s -u elastic:rootpass -X POST "https://localhost:9200/db_workbench_test/_update/2" \
  -H 'Content-Type: application/json' \
  -d '{"doc": {"project": "updated-project"}}'  -- Updates document based on id number
```

- Check the data after update:
```sql
  curl -k -s -u elastic:rootpass "https://localhost:9200/db_workbench_test/_search?q=*&_source=true&pretty"  -- View the index again to check the updated document
```

### 5. Delete Data
- Delete a document from the `db_workbench_test` index:
```sql
  curl -k -s -u elastic:rootpass -X DELETE "https://localhost:9200/db_workbench_test/_doc/2"  -- Deletes document based on id number
```

- Check the data after deletion:
```sql
  curl -k -s -u elastic:rootpass "https://localhost:9200/db_workbench_test/_search?q=*&_source=true&pretty"  -- Index should have just one entry again
```

### 6. Add a New Index
- Create a new index:
```sql
  curl -k -s -u elastic:rootpass -X PUT "https://localhost:9200/new_index_top_secret" \
  -H 'Content-Type: application/json' \
  -d '{
    "mappings": {
      "properties": {
        "name": {
          "type": "text",
          "fields": {
            "keyword": { "type": "keyword", "ignore_above": 256 }
          }
        },
        "organization": { 
          "type": "text",
          "fields": {
            "keyword": { "type": "keyword", "ignore_above": 256 }
          }
        },
        "country": {
          "type": "text",
          "fields": {
            "keyword": { "type": "keyword", "ignore_above": 256 }
          }
        },
        "years_active": { "type": "integer" }
      }
    }
  }'
```

- List all indexes again:
```sql
  curl -k -s -u elastic:rootpass "https://localhost:9200/_cat/indices?v" | awk '$6 > 0'  -- Newly created index should be visible
```

- Switch to the new index:
```sql
  -- Not required, indexes are always directly accessible
```

### 7. Add Data
- Insert data into the new index:
```sql
  curl -k -s -u elastic:rootpass -X POST "https://localhost:9200/new_index_top_secret/_doc/1" \
  -H 'Content-Type: application/json' \
  -d '{"name":"James","organization":"MI6","country":"UK","years_active":20}'
  curl -k -s -u elastic:rootpass -X POST "https://localhost:9200/new_index_top_secret/_doc/2" \
  -H 'Content-Type: application/json' \
  -d '{"name":"Ethan","organization":"IMF","country":"USA","years_active":30}'
  curl -k -s -u elastic:rootpass -X POST "https://localhost:9200/new_index_top_secret/_doc/3" \
  -H 'Content-Type: application/json' \
  -d '{"name":"Nikita","organization":"Section One","country":"Russia","years_active":8}'
  curl -k -s -u elastic:rootpass -X POST "https://localhost:9200/new_index_top_secret/_doc/4" \
  -H 'Content-Type: application/json' \
  -d '{"name":"Jason","organization":"CIA","country":"USA","years_active":12}'
  curl -k -s -u elastic:rootpass -X POST "https://localhost:9200/new_index_top_secret/_doc/5" \
  -H 'Content-Type: application/json' \
  -d '{"name":"Sydney","organization":"SD-6","country":"USA","years_active":10}'  -- bulk inserts are possible with `--data-binary` 
```

- Check the new index's data:
```sql
  curl -k -s -u elastic:rootpass "https://localhost:9200/new_index_top_secret/_search?q=*&_source=true&pretty"
```

### 8. Conditional queries
- Match criteria:
```sql
  curl -k -s -u elastic:rootpass "https://localhost:9200/new_index_top_secret/_search?pretty" \
  -H 'Content-Type: application/json' \
  -d '{
        "query": {
          "match": {
            "organization": "CIA"
          }
        }
      }'
```

- Find MAX value in entire table:
```sql
  curl -k -s -u elastic:rootpass "https://localhost:9200/new_index_top_secret/_search?pretty" \
  -H 'Content-Type: application/json' \
  -d '{
        "size": 0,
        "aggs": {
          "max_years_active": {
            "max": { "field": "years_active" }
          }
        }
      }' -- also works with MIN()
```

- Threshold criteria:
```sql
  curl -k -s -u elastic:rootpass "https://localhost:9200/new_index_top_secret/_search?pretty" \
  -H 'Content-Type: application/json' \
  -d '{
        "query": {
          "range": {
            "years_active": { "lt": 15 }
          }
        }
      }'  -- also works with lte(<=), gt(>) and gte(>=)
```

- Multiple criteria:
```sql
  curl -k -s -u elastic:rootpass "https://localhost:9200/new_index_top_secret/_search?pretty" \
  -H 'Content-Type: application/json' \
  -d '{
        "query": {
          "bool": {
            "must": [
              { "range": { "years_active": { "gt": 10 } } },
              { "wildcard": { "name.keyword": "J*" } }
            ]
          }
        }
      }'  -- matching names that start with "J"
```


### 9. Aggregation queries
- Count number of rows:
```sql
  curl -k -s -u elastic:rootpass "https://localhost:9200/new_index_top_secret/_count" \
  -H 'Content-Type: application/json' \
  -d '{
        "query": {
          "range": {
            "years_active": { "gt": 15 }
          }
        }
      }'  -- also works with gte(>=), lt(<) and lte(<=)
```

- Using average and grouping:
```sql
  curl -k -s -u elastic:rootpass "https://localhost:9200/new_index_top_secret/_search?pretty" \
  -H 'Content-Type: application/json' \
  -d '{
        "size": 0,
        "query": {
          "term": { "country.keyword": "USA" }
        },
        "aggs": {
          "by_country": {
            "terms": { "field": "country.keyword" },
            "aggs": {
              "avg_years_active": { "avg": { "field": "years_active" } }
            }
          }
        }
      }'   -- also works with SUM()
```

- Find MIN within a group:
```sql
  curl -k -s -u elastic:rootpass "https://localhost:9200/new_index_top_secret/_search?pretty" \
  -H 'Content-Type: application/json' \
  -d '{
    "size": 0,
    "aggs": {
      "by_country": {
        "terms": { "field": "country.keyword" },
        "aggs": {
          "min_years_active": { "min": { "field": "years_active" } }
        }
      }
    }
  }' -- also works with MAX()
```
	
### 10. Cleanup
- Delete index:
```sql
  curl -k -s -u elastic:rootpass -X DELETE "https://localhost:9200/new_index_top_secret?pretty"
```

- List all indexes again:
```sql
  curl -k -s -u elastic:rootpass "https://localhost:9200/_cat/indices?v" | awk '$6 > 0'  -- Verify that the "new_index_top_secret" index was deleted
```

### 11. Exit Environment
```sql
-- Elasticsearch does not have a CLI environment to exit.
```


### Notes:
- Workspace = index; `db_workbench` index is pre-created by default.
- Elasticsearch is a document-oriented NoSQL database; documents are stored as JSON.
- Schema-flexible: each document can have different fields, but mappings define data types and analyzers.
- Clusters can contain multiple nodes and indexes for high availability and scalability.
- Indexes are partitioned into shards; shards distribute data across nodes automatically.
- Documents are accessed via REST API or SDKs; SQL endpoint exists for convenience.
- Operations are index-centric; you specify the index for each query.
- Supports full-text search, filtering, aggregations, and analytics on JSON data.
- Commands like `GET`, `POST`, `PUT`, and `_search` are Elasticsearch API operations, not standard SQL.
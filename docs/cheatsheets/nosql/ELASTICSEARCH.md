# Elasticsearch Cheatsheet

<table>
  <tr>
    <td width="90" style="vertical-align: middle; padding-right: 10px;">
      <img src="https://cdn.jsdelivr.net/gh/devicons/devicon@latest/icons/elasticsearch/elasticsearch-original.svg" width="75" />
    </td>
    <td style="vertical-align: middle;">
      Elasticsearch is a distributed search and analytics engine. Data is stored in <b>indices</b>, which contain <b>documents</b> in JSON format. It is optimized for full-text search, aggregations, and near real-time analytics.
    </td>
  </tr>
</table>

Default workspace: `db_workbench`

## Mental Model
- **Index** = workspace (like a database or keyspace).
- **Document** = individual JSON object (like a row).
- **Type** (deprecated in modern ES) = logical grouping inside index.
- Queries are **JSON-based** (DSL) or via HTTP API.
- `db_workbench` index is pre-created for experimentation.
- Elasticsearch is eventually consistent; writes may take milliseconds to propagate.

## Commands

### 1. Connect
```bash
make cli-elasticsearch
# Or use curl:
curl -X GET "localhost:9200/"
```

### 2. Show Current Workspace (Index)
```bash
curl -X GET "localhost:9200/db_workbench/_search?pretty"
```

### 3. List Workspaces (Indices)
```bash
curl -X GET "localhost:9200/_cat/indices?v"
```

### 4. Switch Workspace
Not applicable — each query specifies index directly.

### 5. Create Workspace (Index)
```bash
curl -X PUT "localhost:9200/example_index?pretty"
```

### 6. List Structures (Mappings / Types)
```bash
curl -X GET "localhost:9200/db_workbench/_mapping?pretty"
```

### 7. Create Structure (Mapping)
```bash
curl -X PUT "localhost:9200/db_workbench/_mapping?pretty" -H 'Content-Type: application/json' -d'
{
  "properties": {
    "id": { "type": "integer" },
    "name": { "type": "text" },
    "project": { "type": "text" }
  }
}'
```

### 8. Insert Data
```bash
curl -X POST "localhost:9200/db_workbench/_doc/1?pretty" -H 'Content-Type: application/json' -d'
{
  "id": 1,
  "name": "Andre",
  "project": "db-workbench"
}'
```

### 9. Query All Data
```bash
curl -X GET "localhost:9200/db_workbench/_search?pretty" -H 'Content-Type: application/json' -d'
{
  "query": { "match_all": {} }
}'
```

### 10. Query With Condition
```bash
curl -X GET "localhost:9200/db_workbench/_search?pretty" -H 'Content-Type: application/json' -d'
{
  "query": {
    "match": { "name": "Andre" }
  }
}'
```

### 11. Update Data
```bash
curl -X POST "localhost:9200/db_workbench/_update/1?pretty" -H 'Content-Type: application/json' -d'
{
  "doc": { "project": "db-workbench-updated" }
}'
```

### 12. Delete Data
```bash
curl -X DELETE "localhost:9200/db_workbench/_doc/1?pretty"
```

### 13. Drop Structure (Index)
```bash
curl -X DELETE "localhost:9200/db_workbench?pretty"
```

### 14. Exit
Not applicable — CLI exits as normal shell.

---

**Notes:**
- Every operation is index-centric; the default `db_workbench` index is your workspace.
- Documents are JSON objects, not rows with fixed schema (though mappings define types).
- Queries use DSL JSON, not SQL (though Elasticsearch has SQL endpoint for convenience).
- There is no `USE` command; you specify index in every request.
# DB Workbench Cheatsheets
This folder contains reference cheatsheets for all databases included in **`db-workbench`**. Each cheatsheet provides basic information about the database, mental models, fundamental commands, a circular workflow, and additional notes, making initial local experimentation easier.


## Folder Structure
```txt
cheatsheets/
    ├── README.md
    ├── file/
    │   ├── DUCKDB.md
    │   └── SQLITE.md
    ├── sql/
    │   ├── MARIADB.md
    │   ├── MYSQL.md
    │   └── POSTGRES.md
    └── nosql/
        ├── CASSANDRA.md
        ├── CLICKHOUSE.md
        ├── COUCHBASE.md
        ├── ELASTICSEARCH.md
        ├── MONGO.md
        └── REDIS.md
```


## How to Use
1. Navigate to the folder for your database type.
2. Open the corresponding markdown file.
3. Use as a quick reference guide to basic commands.
4. Or follow the entire circular workflow from start to finish.


## Notes
- Each cheatsheet assumes a default workspace (`db_workbench` or `db_workbench.<file_extension>`) pre-created by the project.
- Commands reflect local CLI usage but can also be applied in GUIs when available.
- The circular workflow is designed so you can start from a default workspace, create tables/data, perform queries, clean up, and end back at the original starting state.
- These cheatsheets are intended for **learning, testing, and experimentation** - not production deployment.

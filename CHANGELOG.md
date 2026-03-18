# Changelog

## v1.1.0 – Expand SQL
- Created CHANGELOG.md
- Minor fixes to docs
- Added 4 SQL databases:
  - CockroachDB
  - H2
  - TimescaleDB
  - YugabyteDB

## v1.0.0 – Initial Release
### Core
- Centralized `Makefile` commands to spin up, access, reset databases
- Unified `docker-compose.yaml` for containerized databases and web GUIs
- Python SDK CLI support for file-based and containerized databases
- `.env.example` for environment variables (ports, users, passwords)
- `.venv` setup instructions for file-based DBs

### Databases
- Created CLI, Web GUI and SDK with integrated Makefile commands for the the follwoing databases:
  - DuckDB
  - SQLite
  - MariaDB
  - MySQL
  - PostgreSQL
  - Cassandra
  - ClickHouse
  - Couchbase
  - Elasticsearch
  - MongoDB
  - Redis

### Documentation
- Quickstart setup in `README.md`
- Cheatsheets in `docs/cheatsheets` for File, SQL and NoSQL databases
- Troubleshooting guide
- Philosophy, non-goals, architecture overview

### Dev Tools / Utilities
- `make doctor` for environment checks
- Initialization scripts for all databases with idempotent test data
- Persistent storage via Docker volumes or local files
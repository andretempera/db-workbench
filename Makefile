.DEFAULT_GOAL := help

# Load .env variables into Makefile
ifneq (,$(wildcard .env))
	include .env
	export
endif


########################################
# File-Based Databases
########################################

up-sqlite: ## Initialize SQLite database file
	python3 data/sqlite/scripts/init.py

cli-sqlite: ## Enter SQLite CLI
	sqlite3 ${SQLITE_DB_PATH}

down-sqlite: ## No-op (file-based)
	@echo "SQLite is file-based. Nothing to stop."


up-duckdb: ## Initialize DuckDB database file
	python3 data/duckdb/scripts/init.py

cli-duckdb-python: ## Enter DuckDB via Python CLI
	python3 -c "import duckdb, pandas as pd; conn = duckdb.connect('${DUCKDB_DB_PATH}'); import code; code.interact(local=globals())"

cli-duckdb-docker: ## Enter DuckDB via Docker CLI
	docker run --rm -it -v "$$PWD/data/duckdb/db:/workspace" -w /workspace duckdb/duckdb duckdb database.duckdb
	
down-duckdb: ## No-op (file-based unless using Docker manually)
	@echo "DuckDB (Python mode) has nothing to stop."


########################################
# SQL Databases
########################################

up-postgres: ## Start PostgreSQL + pgAdmin
	docker compose up -d postgres pgadmin

cli-postgres: ## Enter PostgreSQL CLI
	docker compose exec -it postgres psql -h $$POSTGRES_HOST -p $$POSTGRES_PORT -U $$POSTGRES_USER -d $$POSTGRES_DB
	
down-postgres: ## Stop PostgreSQL + pgAdmin
	docker compose stop postgres pgadmin


up-mysql: ## Start MySQL + phpMyAdmin
	docker compose up -d mysql phpmyadmin

cli-mysql: ## Enter MySQL CLI
	docker compose exec -it mysql mysql -h $$MYSQL_HOST -P $$MYSQL_PORT -u $$MYSQL_USER -p$$MYSQL_PASSWORD -D $$MYSQL_DB

down-mysql: ## Stop MySQL + phpMyAdmin
	docker compose stop mysql phpmyadmin


up-mariadb: ## Start MariaDB + phpMyAdmin
	docker compose up -d mariadb phpmyadmin

cli-mariadb: ## Enter MariaDB CLI
	docker compose exec -it mariadb mariadb -h $$MARIADB_HOST -P $$MARIADB_PORT -u $$MARIADB_USER -p$$MARIADB_PASSWORD -D $$MARIADB_DB

down-mariadb: ## Stop MariaDB + phpMyAdmin
	docker compose stop mariadb phpmyadmin


########################################
# NoSQL Databases
########################################

up-mongo: ## Start MongoDB + Mongo Express
	docker compose up -d mongo mongo-express

cli-mongo: ## Enter Mongo shell
	docker compose exec -it mongo mongosh -u $$MONGO_USER -p $$MONGO_PASSWORD --authenticationDatabase $$MONGO_DB -h $$MONGO_HOST -P $$MONGO_PORT

down-mongo: ## Stop MongoDB + Mongo Express
	docker compose stop mongo mongo-express


up-redis: ## Start Redis + RedisInsight
	docker compose up -d redis redis-insight

cli-redis: ## Enter Redis CLI
	docker compose exec -it redis redis-cli -h $$REDIS_HOST -p $$REDIS_PORT -a $$REDIS_PASSWORD

down-redis: ## Stop Redis + RedisInsight
	docker compose stop redis redis-insight


up-cassandra: ## Start Cassandra
	docker compose up -d cassandra

cli-cassandra: ## Enter Cassandra CQL shell
	docker compose exec -it cassandra cqlsh $$CASSANDRA_HOST $$CASSANDRA_PORT -u $$CASSANDRA_USER -p $$CASSANDRA_PASSWORD

down-cassandra: ## Stop Cassandra
	docker compose stop cassandra


up-elasticsearch: ## Start Elasticsearch
	docker compose up -d elasticsearch
	
cli-elasticsearch: ## Connect to Elasticsearch console
	curl -u $$ELASTIC_USER:$$ELASTIC_PASSWORD http://$$ELASTIC_HOST:$$ELASTIC_PORT

down-elasticsearch: ## Stop Elasticsearch
	docker compose stop elasticsearch


up-clickhouse: ## Start ClickHouse
	docker compose up -d clickhouse

cli-clickhouse: ## Enter ClickHouse client
	docker compose exec -it clickhouse clickhouse-client --host $$CLICKHOUSE_HOST --port $$CLICKHOUSE_PORT --user $$CLICKHOUSE_USER --password $$CLICKHOUSE_PASSWORD --database=default

down-clickhouse: ## Stop ClickHouse
	docker compose stop clickhouse


up-couchbase: ## Start Couchbase
	docker compose up -d couchbase

cli-couchbase: ## Connect to Couchbase CLI
	docker compose exec -it couchbase /bin/bash

down-couchbase: ## Stop Couchbase
	docker compose stop couchbase


########################################
# Grouped Commands
########################################

up-file: ## Start all file-based databases (SQLite + DuckDB)
	make up-sqlite
	make up-duckdb

down-file: ## Stop all file-based databases (SQLite + DuckDB)
	make down-sqlite
	make down-duckdb


up-sql: ## Start all SQL databases (+ GUIs)
	docker compose up -d postgres pgadmin mysql mariadb phpmyadmin

down-sql: ## Stop all SQL databases (+ GUIs)
	docker compose stop postgres pgadmin mysql mariadb phpmyadmin


up-nosql: ## Start all NoSQL databases (+ GUIs where available)
	docker compose up -d mongo mongo-express redis redis-insight cassandra elasticsearch clickhouse couchbase

down-nosql: ## Stop all NoSQL databases
	docker compose stop mongo mongo-express redis redis-insight cassandra elasticsearch clickhouse couchbase


up-all: ## Start all databases (File-based + SQL + NoSQL)
	make up-file
	make up-sql
	make up-nosql
	
down-all: ## Stop all databases (File-based + SQL + NoSQL)
	make down-file
	make down-sql
	make down-nosql


########################################
# Reset Commands
########################################

reset-sqlite: ## Delete SQLite database file
	@echo "Removing SQLite database..."
	@rm -f ${SQLITE_DB_PATH} || true

reset-duckdb: ## Delete DuckDB database file
	@echo "Removing DuckDB database..."
	@rm -f ${DUCKDB_DB_PATH} || true


reset-postgres: ## Remove PostgreSQL + pgAdmin containers and volumes
	docker compose down -v --remove-orphans postgres pgadmin

reset-mysql: ## Remove MySQL + phpMyAdmin containers and volumes
	docker compose down -v --remove-orphans mysql phpmyadmin

reset-mariadb: ## Remove MariaDB + phpMyAdmin containers and volumes
	docker compose down -v --remove-orphans mariadb phpmyadmin


reset-mongo: ## Remove Mongo + Mongo Express containers and volumes
	docker compose down -v --remove-orphans mongo mongo-express

reset-redis: ## Remove Redis + RedisInsight containers and volumes
	docker compose down -v --remove-orphans redis redis-insight

reset-cassandra: ## Remove Cassandra containers and volumes
	docker compose down -v --remove-orphans cassandra

reset-elasticsearch: ## Remove Elasticsearch containers and volumes
	docker compose down -v --remove-orphans elasticsearch

reset-clickhouse: ## Remove ClickHouse containers and volumes
	docker compose down -v --remove-orphans clickhouse

reset-couchbase: ## Remove Couchbase containers and volumes
	docker compose down -v --remove-orphans couchbase


reset-file: ## Reset all file-based databases (SQLite + DuckDB)
	make reset-sqlite
	make reset-duckdb

reset-sql: ## Reset all SQL databases (containers + volumes)
	make reset-postgres
	make reset-mysql
	make reset-mariadb

reset-nosql: ## Reset all NoSQL databases (containers + volumes)
	make reset-mongo
	make reset-redis
	make reset-cassandra
	make reset-elasticsearch
	make reset-clickhouse
	make reset-couchbase

reset-all: ## Reset all databases (SQL + NoSQL + file-based)
	make reset-file
	make reset-sql
	make reset-nosql

########################################
# Help Commands
########################################

.PHONY: help help-file help-sql help-nosql \
        help-sqlite help-duckdb \
        help-postgres help-mysql help-mariadb \
        help-mongo help-redis help-cassandra help-elasticsearch help-clickhouse help-couchbase

# Generic full help
help: ## Show all commands
	@echo ""
	@echo "local-databases            Available Commands"
	@echo "-------------------------  --------------------------------"
	@awk 'BEGIN {FS = ":.*##"} /^[a-zA-Z0-9_-]+:.*##/ { printf "  %-25s %s\n", $$1, $$2 }' $(MAKEFILE_LIST)
	@echo ""

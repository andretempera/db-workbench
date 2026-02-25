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

reset-sqlite: ## Delete SQLite database file
	@echo "Removing SQLite database..."
	@rm -f ${SQLITE_DB_PATH} || true


up-duckdb: ## Initialize DuckDB database file
	python3 data/duckdb/scripts/init.py

cli-duckdb: ## Incomplete command (requires either cli-duckdb-python or cli-duckdb-docker)
	@echo "Incomplete command. Use either 'make cli-duckdb-python' or 'make cli-duckdb-docker'."

cli-duckdb-python: ## Enter DuckDB via Python CLI
	python3 -c "import duckdb, pandas as pd; conn = duckdb.connect('${DUCKDB_DB_PATH}'); import code; code.interact(local=globals())"

cli-duckdb-docker: ## Enter DuckDB via Docker CLI
	docker run --rm -it -v "$$PWD/data/duckdb/db:/workspace" -w /workspace duckdb/duckdb duckdb db_workbench.duckdb
	
down-duckdb: ## No-op (file-based unless using Docker manually)
	@echo "DuckDB (Python mode) has nothing to stop."

reset-duckdb: ## Delete DuckDB database file
	@echo "Removing DuckDB database..."
	@rm -f ${DUCKDB_DB_PATH} || true


########################################
# SQL Databases
########################################

up-postgres: ## Start PostgreSQL + pgAdmin
	docker compose up -d postgres pgadmin

cli-postgres: ## Enter PostgreSQL CLI
	docker compose exec -it postgres psql -h ${POSTGRES_HOST} -p ${POSTGRES_PORT} -U ${POSTGRES_USER} -d ${POSTGRES_DB}

gui-postgres: ## Launch pgAdmin for PostgreSQL
	@echo "Click link to open GUI: http://localhost:${PGADMIN_PORT}"

down-postgres: ## Stop PostgreSQL + pgAdmin
	docker compose stop postgres pgadmin

reset-postgres: ## Remove PostgreSQL + pgAdmin containers and volumes
	docker compose down -v --remove-orphans postgres pgadmin


up-mysql: ## Start MySQL + phpMyAdmin
	docker compose up -d mysql phpmyadmin-mysql

cli-mysql: ## Enter MySQL CLI
	docker compose exec -it mysql mysql -h ${MYSQL_HOST} -P ${MYSQL_PORT} -u root -p${MYSQL_ROOT_PASSWORD} -D ${MYSQL_DB}

gui-mysql: ## Launch phpMyAdmin for MySQL
	@echo "Click link to open GUI: http://localhost:${PHPMYADMIN_MYSQL_PORT}"

down-mysql: ## Stop MySQL + phpMyAdmin
	docker compose stop mysql phpmyadmin-mysql

reset-mysql: ## Remove MySQL + phpMyAdmin containers and volumes
	docker compose down -v --remove-orphans mysql phpmyadmin-mysql


up-mariadb: ## Start MariaDB + phpMyAdmin
	docker compose up -d mariadb phpmyadmin-mariadb

cli-mariadb: ## Enter MariaDB CLI
	docker compose exec -it mariadb mariadb -h ${MARIADB_HOST} -P 3306 -u root -p${MARIADB_ROOT_PASSWORD} -D ${MARIADB_DB}

gui-mariadb: ## Launch phpMyAdmin for MariaDB
	@echo "Click link to open GUI: http://localhost:${PHPMYADMIN_MARIADB_PORT}"

down-mariadb: ## Stop MariaDB + phpMyAdmin
	docker compose stop mariadb phpmyadmin-mariadb

reset-mariadb: ## Remove MariaDB + phpMyAdmin containers and volumes
	docker compose down -v --remove-orphans mariadb phpmyadmin-mariadb


########################################
# NoSQL Databases
########################################

up-mongo: ## Start MongoDB + Mongo Express
	docker compose up -d mongo mongo-express

cli-mongo: ## Enter Mongo shell
	docker compose exec -it mongo mongosh "mongodb://$$MONGO_USER:$$MONGO_PASSWORD@$$MONGO_HOST:$$MONGO_PORT/db_workbench?authSource=admin"

gui-mongo: ## Launch Mongo Express for MongoDB
	@echo "Click link to open GUI: http://localhost:${MONGOEXPRESS_PORT}"

down-mongo: ## Stop MongoDB + Mongo Express
	docker compose stop mongo mongo-express

reset-mongo: ## Remove Mongo + Mongo Express containers and volumes
	docker compose down -v --remove-orphans mongo mongo-express


up-redis: ## Start Redis + RedisInsight
	docker compose up -d redis redis-insight

cli-redis: ## Enter Redis CLI
	docker compose exec -it redis redis-cli -h $$REDIS_HOST -p $$REDIS_PORT -a $$REDIS_PASSWORD

gui-redis: ## Launch RedisInsight for Redis
	@echo "Click link to open GUI: http://localhost:${REDISINSIGHT_PORT}"

down-redis: ## Stop Redis + RedisInsight
	docker compose stop redis redis-insight

reset-redis: ## Remove Redis + RedisInsight containers and volumes
	docker compose down -v --remove-orphans redis redis-insight


up-cassandra: ## Start Cassandra
	docker compose up -d cassandra

cli-cassandra: ## Enter Cassandra CQL shell (+ init script)
	docker compose exec -it cassandra bash -c "\
	cqlsh $$CASSANDRA_HOST $$CASSANDRA_PORT -u $$CASSANDRA_USER -p $$CASSANDRA_PASSWORD -f /docker-entrypoint-initdb.d/init.cql; \
	exec cqlsh $$CASSANDRA_HOST $$CASSANDRA_PORT -u $$CASSANDRA_USER -p $$CASSANDRA_PASSWORD -k db_workbench"

down-cassandra: ## Stop Cassandra
	docker compose stop cassandra

reset-cassandra: ## Remove Cassandra containers and volumes
	docker compose down -v --remove-orphans cassandra


up-elasticsearch: ## Start Elasticsearch
	docker compose up -d elasticsearch
	
cli-elasticsearch: ## Connect to Elasticsearch console
	curl -u $$ELASTIC_USER:$$ELASTIC_PASSWORD http://$$ELASTIC_HOST:$$ELASTIC_PORT

down-elasticsearch: ## Stop Elasticsearch
	docker compose stop elasticsearch

reset-elasticsearch: ## Remove Elasticsearch containers and volumes
	docker compose down -v --remove-orphans elasticsearch


up-clickhouse: ## Start ClickHouse
	docker compose up -d clickhouse

cli-clickhouse: ## Enter ClickHouse client
	docker compose exec -it clickhouse clickhouse-client --user $$CLICKHOUSE_USER --password $$CLICKHOUSE_PASSWORD --database db_workbench

gui-clickhouse: ## Launch ClickHouse Web UI
	@echo "Click link to open GUI: http://localhost:${CLICKHOUSE_PORT}"

down-clickhouse: ## Stop ClickHouse
	docker compose stop clickhouse

reset-clickhouse: ## Remove ClickHouse containers and volumes
	docker compose down -v --remove-orphans clickhouse


up-couchbase: ## Start Couchbase
	docker compose up -d couchbase

cli-couchbase: ## Connect to Couchbase CLI
	docker compose exec -it couchbase /bin/bash

gui-couchbase: ## Launch Couchbase Web Console
	@echo "Click link to open GUI: http://localhost:${COUCHBASE_PORT}"

down-couchbase: ## Stop Couchbase
	docker compose stop couchbase

reset-couchbase: ## Remove Couchbase containers and volumes
	docker compose down -v --remove-orphans couchbase


########################################
# Grouped Commands
########################################

up-file: ## Start all file-based databases (SQLite + DuckDB)
	make up-sqlite
	make up-duckdb

down-file: ## Stop all file-based databases (SQLite + DuckDB)
	make down-sqlite
	make down-duckdb

reset-file: ## Reset all file-based databases (SQLite + DuckDB)
	make reset-sqlite
	make reset-duckdb


up-sql: ## Start all SQL databases (+ GUIs)
	docker compose up -d postgres pgadmin mysql mariadb phpmyadmin-mysql phpmyadmin-mariadb

down-sql: ## Stop all SQL databases (+ GUIs)
	docker compose stop postgres pgadmin mysql mariadb phpmyadmin-mysql phpmyadmin-mariadb

reset-sql: ## Reset all SQL databases (containers + volumes)
	make reset-postgres
	make reset-mysql
	make reset-mariadb


up-nosql: ## Start all NoSQL databases (+ GUIs where available)
	docker compose up -d mongo mongo-express redis redis-insight cassandra elasticsearch clickhouse couchbase

down-nosql: ## Stop all NoSQL databases
	docker compose stop mongo mongo-express redis redis-insight cassandra elasticsearch clickhouse couchbase

reset-nosql: ## Reset all NoSQL databases (containers + volumes)
	make reset-mongo
	make reset-redis
	make reset-cassandra
	make reset-elasticsearch
	make reset-clickhouse
	make reset-couchbase


up-all: ## Start all databases (File-based + SQL + NoSQL)
	make up-file
	make up-sql
	make up-nosql
	
down-all: ## Stop all databases (File-based + SQL + NoSQL)
	make down-file
	make down-sql
	make down-nosql

reset-all: ## Reset all databases (SQL + NoSQL + file-based)
	make reset-file
	make reset-sql
	make reset-nosql


########################################
# Diagnostics
########################################
doctor: ## Check local environment for potential issues
	@WARN=0; \
	echo "Scanning for issues..."; \
	echo -n "Checking Docker... "; \
	if ! command -v docker >/dev/null 2>&1; then \
		echo "⚠  Docker not installed"; WARN=1; \
	elif ! docker info >/dev/null 2>&1; then \
		echo "⚠  Docker not running"; WARN=1; \
	else \
		echo "☑"; \
	fi; \
	echo -n "Checking for .env file... "; \
	if [ ! -f .env ]; then \
		echo "⚠  .env file missing"; WARN=1; \
	else \
		echo "☑"; \
	fi; \
	echo -n "Checking Python virtual environment... "; \
	if [ ! -d venv ] && [ ! -d .venv ]; then \
		echo "⚠  Python virtual environment not found"; WARN=1; \
	else \
		echo "☑"; \
	fi; \
	echo -n "Checking default ports... "; \
	PORT_WARN=0; \
	for port in 5432 3306 6379 27017 9200 9000; do \
		if lsof -i :$$port >/dev/null 2>&1; then \
			echo "⚠  Port $$port is in use"; \
			PORT_WARN=1; \
			WARN=1; \
		fi; \
	done; \
	if [ $$PORT_WARN -eq 0 ]; then echo "☑"; fi; \
	if [ $$WARN -eq 0 ]; then \
		echo "Environment check complete. No issues found."; \
	else \
		echo "Environment check complete. Please fix above issues."; \
	fi


########################################
# Help Commands
########################################

.PHONY: help-sqlite help-duckdb \
        help-postgres help-mysql help-mariadb \
        help-mongo help-redis help-cassandra help-elasticsearch help-clickhouse help-couchbase \
		help-file help-sql help-nosql help help-all

# Individual database help commands
help-sqlite: ## Show SQLite commands
	@echo ""
	@echo "  SQLite Commands"
	@echo "  -----------------"
	@awk 'BEGIN {FS = ":.*##"} /^up-sqlite:|^cli-sqlite:|^down-sqlite:|^reset-sqlite:/ {printf "  %-25s %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ""

help-duckdb: ## Show DuckDB commands
	@echo ""
	@echo "  DuckDB Commands"
	@echo "  -----------------"
	@awk 'BEGIN {FS = ":.*##"} /^up-duckdb:.*##/ {printf "  %-25s %s\n", $$1, $$2} /^cli-duckdb(-python|-docker)?:.*##/ {printf "  %-25s %s\n", $$1, $$2} /^down-duckdb:.*##/ {printf "  %-25s %s\n", $$1, $$2} /^reset-duckdb:.*##/ {printf "  %-25s %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ""

help-postgres: ## Show PostgreSQL commands
	@echo ""
	@echo "  PostgreSQL Commands"
	@echo "  ---------------------"
	@awk 'BEGIN {FS = ":.*##"} /^up-postgres:|^cli-postgres:|^gui-postgres:|^down-postgres:|^reset-postgres:/ {printf "  %-25s %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ""

help-mysql: ## Show MySQL commands
	@echo ""
	@echo "  MySQL Commands"
	@echo "------------------"
	@awk 'BEGIN {FS = ":.*##"} /^up-mysql:|^cli-mysql:|^gui-mysql:|^down-mysql:|^reset-mysql:/ {printf "  %-25s %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ""

help-mariadb: ## Show MariaDB commands
	@echo ""
	@echo "  MariaDB Commands"
	@echo "  ------------------"
	@awk 'BEGIN {FS = ":.*##"} /^up-mariadb:|^cli-mariadb:|^gui-mariadb:|^down-mariadb:|^reset-mariadb:/ {printf "  %-25s %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ""

help-mongo: ## Show MongoDB commands
	@echo ""
	@echo "  MongoDB Commands"
	@echo "  ------------------"
	@awk 'BEGIN {FS = ":.*##"} /^up-mongo:|^cli-mongo:|^gui-mongo:|^down-mongo:|^reset-mongo:/ {printf "  %-25s %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ""

help-redis: ## Show Redis commands
	@echo ""
	@echo "  Redis Commands"
	@echo "  ----------------"
	@awk 'BEGIN {FS = ":.*##"} /^up-redis:|^cli-redis:|^gui-redis:|^down-redis:|^reset-redis:/ {printf "  %-25s %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ""

help-cassandra: ## Show Cassandra commands
	@echo ""
	@echo "  Cassandra Commands"
	@echo "  --------------------"
	@awk 'BEGIN {FS = ":.*##"} /^up-cassandra:|^cli-cassandra:|^down-cassandra:|^reset-cassandra:/ {printf "  %-25s %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ""

help-elasticsearch: ## Show Elasticsearch commands
	@echo ""
	@echo "  Elasticsearch Commands"
	@echo "  ------------------------"
	@awk 'BEGIN {FS = ":.*##"} /^up-elasticsearch:|^cli-elasticsearch:|^down-elasticsearch:|^reset-elasticsearch:/ {printf "  %-25s %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ""

help-clickhouse: ## Show ClickHouse commands
	@echo ""
	@echo "  ClickHouse Commands"
	@echo "  ---------------------"
	@awk 'BEGIN {FS = ":.*##"} /^up-clickhouse:|^cli-clickhouse:|^gui-clickhouse:|^down-clickhouse:|^reset-clickhouse:/ {printf "  %-25s %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ""

help-couchbase: ## Show Couchbase commands
	@echo ""
	@echo "  Couchbase Commands"
	@echo "  --------------------"
	@awk 'BEGIN {FS = ":.*##"} /^up-couchbase:|^cli-couchbase:|^gui-couchbase:|^down-couchbase:|^reset-couchbase:/ {printf "  %-25s %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ""


# Grouped help commands
help-file: ## Show file-based database commands
	@echo ""
	@echo "  File-based Databases Commands"
	@echo "  -------------------------------"
	@awk 'BEGIN {FS=":.*##"} /^up-sqlite:|^cli-sqlite:|^down-sqlite:|^reset-sqlite:/ {printf "  %-25s %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ""
	@awk 'BEGIN {FS=":.*##"} /^up-duckdb:|^cli-duckdb:|^cli-duckdb-python:|^cli-duckdb-docker:|^down-duckdb:|^reset-duckdb:/ {printf "  %-25s %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ""

help-sql: ## Show SQL database commands
	@echo ""
	@echo "  SQL Databases Commands"
	@echo "  ------------------------"
	@awk 'BEGIN {FS=":.*##"} /^up-postgres:|^cli-postgres:|^gui-postgres:|^down-postgres:|^reset-postgres:/ {printf "  %-25s %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ""
	@awk 'BEGIN {FS=":.*##"} /^up-mysql:|^cli-mysql:|^gui-mysql:|^down-mysql:|^reset-mysql:/ {printf "  %-25s %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ""
	@awk 'BEGIN {FS=":.*##"} /^up-mariadb:|^cli-mariadb:|^gui-mariadb:|^down-mariadb:|^reset-mariadb:/ {printf "  %-25s %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ""

help-nosql: ## Show NoSQL database commands
	@echo ""
	@echo "  NoSQL Databases Commands"
	@echo "  --------------------------"
	@awk 'BEGIN {FS=":.*##"} /^up-mongo:|^cli-mongo:|^gui-mongo:|^down-mongo:|^reset-mongo:/ {printf "  %-25s %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ""
	@awk 'BEGIN {FS=":.*##"} /^up-redis:|^cli-redis:|^gui-redis:|^down-redis:|^reset-redis:/ {printf "  %-25s %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ""
	@awk 'BEGIN {FS=":.*##"} /^up-cassandra:|^cli-cassandra:|^down-cassandra:|^reset-cassandra:/ {printf "  %-25s %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ""
	@awk 'BEGIN {FS=":.*##"} /^up-elasticsearch:|^cli-elasticsearch:|^down-elasticsearch:|^reset-elasticsearch:/ {printf "  %-25s %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ""
	@awk 'BEGIN {FS=":.*##"} /^up-clickhouse:|^cli-clickhouse:|^gui-clickhouse:|^down-clickhouse:|^reset-clickhouse:/ {printf "  %-25s %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ""
	@awk 'BEGIN {FS=":.*##"} /^up-couchbase:|^cli-couchbase:|^gui-couchbase:|^down-couchbase:|^reset-couchbase:/ {printf "  %-25s %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ""

# Generic full help
help: ## Show all commands
	@echo ""
	@echo "  DB Workbench - Available Commands"
	@echo "  -----------------------------------"
	@awk 'BEGIN {FS = ":.*##"} /^[a-zA-Z0-9_-]+:.*##/ { printf "  %-25s %s\n", $$1, $$2 }' $(MAKEFILE_LIST)
	@echo ""

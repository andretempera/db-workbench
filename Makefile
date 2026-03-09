.DEFAULT_GOAL := help

# Load .env variables into Makefile
ifneq (,$(wildcard .env))
	include .env
	export
endif


########################################
# File-Based Databases
########################################

up-duckdb: ## Start DuckDB database file
	python3 data/duckdb/scripts/init.py

cli-duckdb: ## Enter DuckDB native CLI (via Docker)
	docker run --rm -it --name duckdb-cli -v "${PWD}/data/duckdb/db:/workspace" -w /workspace duckdb/duckdb duckdb db_workbench.duckdb

sdk-duckdb: ## Enter DuckDB via Python SDK
	python3 ./data/duckdb/scripts/init_sdk.py

down-duckdb: ## No-op (file-based)
	@echo "DuckDB is file-based. Nothing to stop."

reset-duckdb: ## Delete DuckDB database file and remove CLI container
	docker compose down -v --remove-orphans duckdb-cli
	@echo "Removing DuckDB database..."
	@rm -f ${DUCKDB_DB_PATH} || true


up-sqlite: ## Initialize SQLite database file
	python3 data/sqlite/scripts/init.py

cli-sqlite: ## Enter SQLite CLI
	sqlite3 ${SQLITE_DB_PATH}

sdk-sqlite: ## Enter SQLite via Python SDK
	python3 ./data/sqlite/scripts/init_sdk.py

down-sqlite: ## No-op (file-based)
	@echo "SQLite is file-based. Nothing to stop."

reset-sqlite: ## Delete SQLite database file
	@echo "Removing SQLite database..."
	@rm -f ${SQLITE_DB_PATH} || true


########################################
# SQL Databases
########################################

up-mariadb: ## Start MariaDB
	docker compose up -d mariadb

cli-mariadb: ## Enter MariaDB CLI
	docker compose exec -it mariadb mariadb -h ${MARIADB_HOST} -P 3306 -u ${MARIADB_USER} -p${MARIADB_ROOT_PASSWORD} -D ${MARIADB_DB}

gui-mariadb: ## Launch phpMyAdmin for MariaDB
	docker compose up -d phpmyadmin-mariadb
	@echo "Click link to open GUI: http://localhost:${PHPMYADMIN_MARIADB_PORT}"

sdk-mariadb: ## Connect to MariaDB via Python SDK
	docker compose up -d mariadb-sdk
	docker compose exec mariadb-sdk python /scripts/init_sdk.py

down-mariadb: ## Stop MariaDB, phpMyAdmin and SDK container
	docker compose stop mariadb phpmyadmin-mariadb mariadb-sdk

reset-mariadb: ## Remove MariaDB, phpMyAdmin, SDK containers and volumes
	docker compose down -v --remove-orphans mariadb phpmyadmin-mariadb mariadb-sdk


up-mysql: ## Start MySQL
	docker compose up -d mysql

cli-mysql: ## Enter MySQL CLI
	docker compose exec -it mysql mysql -h ${MYSQL_HOST} -P ${MYSQL_PORT} -u ${MYSQL_USER} -p${MYSQL_ROOT_PASSWORD} -D ${MYSQL_DB}

gui-mysql: ## Launch phpMyAdmin for MySQL
	docker compose up -d phpmyadmin-mysql
	@echo "Click link to open GUI: http://localhost:${PHPMYADMIN_MYSQL_PORT}"

sdk-mysql: ## Connect to MySQL via Python SDK
	docker compose up -d mysql-sdk
	docker compose exec mysql-sdk python /scripts/init_sdk.py

down-mysql: ## Stop MySQL, phpMyAdmin and SDK container
	docker compose stop mysql phpmyadmin-mysql mysql-sdk

reset-mysql: ## Remove MySQL, phpMyAdmin, SDK containers and volumes
	docker compose down -v --remove-orphans mysql phpmyadmin-mysql mysql-sdk


up-postgres: ## Start PostgreSQL
	docker compose up -d postgres

cli-postgres: ## Enter PostgreSQL CLI
	docker compose exec -it postgres psql -h ${POSTGRES_HOST} -p ${POSTGRES_PORT} -U ${POSTGRES_USER} -d ${POSTGRES_DB}

gui-postgres: ## Launch pgAdmin for PostgreSQL
	docker compose up -d pgadmin
	@echo "Click link to open GUI: http://localhost:${PGADMIN_PORT}"

sdk-postgres: ## Connect to PostgreSQL via Python SDK
	docker compose up -d postgres-sdk
	docker compose exec postgres-sdk python /scripts/init_sdk.py

down-postgres: ## Stop PostgreSQL, pgAdmin and SDK container
	docker compose stop postgres pgadmin postgres-sdk

reset-postgres: ## Remove PostgreSQL, pgAdmin, SDK containers and volumes
	docker compose down -v --remove-orphans postgres pgadmin postgres-sdk


########################################
# NoSQL Databases
########################################

up-cassandra: ## Start Cassandra
	docker compose up -d cassandra cassandra-init

cli-cassandra: ## Enter Cassandra CQL shell
	docker compose exec -it cassandra cqlsh ${CASSANDRA_HOST} ${CASSANDRA_PORT} -u ${CASSANDRA_USER} -p ${CASSANDRA_PASSWORD} -k db_workbench

sdk-cassandra: ## Connect to Cassandra via Python SDK
	docker compose up -d cassandra-sdk
	docker compose exec cassandra-sdk python /scripts/init_sdk.py

down-cassandra: ## Stop Cassandra and SDK container
	docker compose stop cassandra cassandra-init cassandra-sdk

reset-cassandra: ## Remove Cassandra, SDK container and volumes
	docker compose down -v --remove-orphans cassandra cassandra-init cassandra-sdk


up-clickhouse: ## Start ClickHouse
	docker compose up -d clickhouse

cli-clickhouse: ## Enter ClickHouse client
	docker compose exec -it clickhouse clickhouse-client --user ${CLICKHOUSE_USER} --password ${CLICKHOUSE_PASSWORD} --database db_workbench

gui-clickhouse: ## Launch ClickHouse Web UI
	@echo "Click link to open GUI: http://localhost:${CLICKHOUSE_PORT}"

sdk-clickhouse: ## Connect to ClickHouse via Python SDK
	docker compose up -d clickhouse-sdk
	docker compose exec clickhouse-sdk python /scripts/init_sdk.py

down-clickhouse: ## Stop ClickHouse and SDK container
	docker compose stop clickhouse clickhouse-sdk

reset-clickhouse: ## Remove ClickHouse, SDK containers and volumes
	docker compose down -v --remove-orphans clickhouse clickhouse-sdk


up-couchbase: ## Start Couchbase
	docker compose up -d couchbase
	docker compose exec couchbase bash /scripts/init.sh

cli-couchbase: ## Connect to Couchbase CLI
	docker compose exec couchbase cbq -u ${COUCHBASE_USER} -p ${COUCHBASE_PASSWORD} -engine http://${COUCHBASE_HOST}:${COUCHBASE_PORT}

gui-couchbase: ## Launch Couchbase Web Console
	@echo "Click link to open GUI: http://localhost:${COUCHBASE_PORT}/ui/index.html"

sdk-couchbase: ## Connect to Couchbase via Python SDK
	docker compose up -d couchbase-sdk
	docker compose exec couchbase-sdk python /scripts/init_sdk.py

down-couchbase: ## Stop Couchbase and SDK container
	docker compose stop couchbase couchbase-sdk

reset-couchbase: ## Remove Couchbase, SDK containers and volumes
	docker compose down -v --remove-orphans couchbase couchbase-sdk


up-elasticsearch: ## Start Elasticsearch
	docker compose up -d elasticsearch
	python3 ./data/elasticsearch/scripts/init.py
	bash ./data/elasticsearch/scripts/init_kibana.sh

gui-elasticsearch: ## Launch Kibana for Elasticsearch
	docker compose up -d kibana
	@echo "Click link to open GUI: http://localhost:${KIBANA_PORT}"

sdk-elasticsearch: ## Connect to Elasticsearch via Python SDK
	docker compose up -d elasticsearch-sdk
	docker compose exec elasticsearch-sdk python /scripts/init_sdk.py

down-elasticsearch: ## Stop Elasticsearch, Kibana and SDK container
	docker compose stop elasticsearch kibana elasticsearch-sdk

reset-elasticsearch: ## Remove Elasticsearch, Kibana, SDK containers and volumes
	docker compose down -v --remove-orphans elasticsearch kibana elasticsearch-sdk
	rm -f ./data/elasticsearch/logs/.init_done
	rm -f ./data/elasticsearch/logs/.init_kibana_done


up-mongo: ## Start MongoDB
	docker compose up -d mongo

cli-mongo: ## Enter Mongo shell (+ init script)
	docker compose exec -T mongo mongosh "mongodb://${MONGO_USER}:${MONGO_PASSWORD}@${MONGO_HOST}:${MONGO_PORT}/db_workbench?authSource=admin"

gui-mongo: ## Launch Mongo Express for MongoDB (+ init script)
	docker compose up -d mongo-express
	@echo "Click link to open GUI: http://localhost:${MONGOEXPRESS_PORT}"

sdk-mongo: ## Connect to MongoDB via Python SDK (+ init script)
	docker compose up -d mongo-sdk
	docker compose exec mongo-sdk python /scripts/init_sdk.py

down-mongo: ## Stop MongoDB + Mongo Express
	docker compose stop mongo mongo-init mongo-express mongo-sdk

reset-mongo: ## Remove Mongo + Mongo Express containers and volumes
	docker compose down -v --remove-orphans mongo mongo-init mongo-express mongo-sdk


up-redis: ## Start Redis + RedisInsight
	docker compose up -d redis

cli-redis: ## Enter Redis CLI (+ init script)
	docker compose exec -T redis sh -c "cat /scripts/init.redis | redis-cli -h ${REDIS_HOST} -p ${REDIS_PORT} -a ${REDIS_PASSWORD}"
	docker compose exec -it redis redis-cli -h ${REDIS_HOST} -p ${REDIS_PORT} -a ${REDIS_PASSWORD}

gui-redis: ## Launch RedisInsight for Redis (+ init script)
	docker compose up -d redis-insight
	docker compose exec -T redis sh -c "cat /scripts/init.redis | redis-cli -h ${REDIS_HOST} -p ${REDIS_PORT} -a ${REDIS_PASSWORD}"
	@echo "Click link to open GUI: http://localhost:${REDISINSIGHT_PORT}"

sdk-redis: ## Connect to Redis via Python SDK (+ init script)
	docker compose up -d redis-sdk
	docker compose exec redis-sdk python /scripts/init_sdk.py

down-redis: ## Stop Redis + RedisInsight
	docker compose stop redis redis-insight redis-sdk

reset-redis: ## Remove Redis + RedisInsight containers and volumes
	docker compose down -v --remove-orphans redis redis-insight redis-sdk


########################################
# Grouped Commands
########################################

up-file: ## Start all file-based databases (SQLite + DuckDB)
	make up-duckdb	
	make up-sqlite

down-file: ## Stop all file-based databases (SQLite + DuckDB)
	make down-duckdb	
	make down-sqlite

reset-file: ## Reset all file-based databases (SQLite + DuckDB)
	make reset-duckdb	
	make reset-sqlite


up-sql: ## Start all SQL databases and available GUIs, build respective SDKs images
	make up-mariadb
	make up-mysql
	make up-postgres

down-sql: ## Stop all SQL databases, SDKs and GUIs
	make down-mariadb
	make down-mysql
	make down-postgres

reset-sql: ## Reset all SQL databases (containers + volumes)
	make reset-mariadb
	make reset-mysql
	make reset-postgres


up-nosql: ## Start all NoSQL databases and available GUIs, build respective SDKs images
	make up-cassandra
	make up-clickhouse
	make up-couchbase
	make up-elasticsearch
	make up-mongo
	make up-redis

down-nosql: ## Stop all NoSQL databases
	make down-cassandra
	make down-clickhouse
	make down-couchbase
	make down-elasticsearch
	make down-mongo
	make down-redis

reset-nosql: ## Reset all NoSQL databases (containers + volumes)
	make reset-cassandra
	make reset-clickhouse
	make reset-couchbase
	make reset-elasticsearch
	make reset-mongo
	make reset-redis


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
help-duckdb: ## Show DuckDB commands
	@echo ""
	@echo "  DuckDB Commands"
	@echo "  -----------------"
	@awk 'BEGIN {FS = ":.*##"} /^up-duckdb:|^cli-duckdb:|^sdk-duckdb:|^down-duckdb:|^reset-duckdb:/ {printf "  %-25s %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ""

help-sqlite: ## Show SQLite commands
	@echo ""
	@echo "  SQLite Commands"
	@echo "  -----------------"
	@awk 'BEGIN {FS = ":.*##"} /^up-sqlite:|^cli-sqlite:|^sdk-sqlite:|^down-sqlite:|^reset-sqlite:/ {printf "  %-25s %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ""


help-mariadb: ## Show MariaDB commands
	@echo ""
	@echo "  MariaDB Commands"
	@echo "  ------------------"
	@awk 'BEGIN {FS = ":.*##"} /^up-mariadb:|^cli-mariadb:|^sdk-mariadb:|^gui-mariadb:|^down-mariadb:|^reset-mariadb:/ {printf "  %-25s %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ""

help-mysql: ## Show MySQL commands
	@echo ""
	@echo "  MySQL Commands"
	@echo "------------------"
	@awk 'BEGIN {FS = ":.*##"} /^up-mysql:|^cli-mysql:|^sdk-mysql:|^gui-mysql:|^down-mysql:|^reset-mysql:/ {printf "  %-25s %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ""

help-postgres: ## Show PostgreSQL commands
	@echo ""
	@echo "  PostgreSQL Commands"
	@echo "  ---------------------"
	@awk 'BEGIN {FS = ":.*##"} /^up-postgres:|^cli-postgres:|^sdk-postgres:|^gui-postgres:|^down-postgres:|^reset-postgres:/ {printf "  %-25s %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ""


help-cassandra: ## Show Cassandra commands
	@echo ""
	@echo "  Cassandra Commands"
	@echo "  --------------------"
	@awk 'BEGIN {FS = ":.*##"} /^up-cassandra:|^cli-cassandra:|^sdk-cassandra:|^down-cassandra:|^reset-cassandra:/ {printf "  %-25s %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ""

help-clickhouse: ## Show ClickHouse commands
	@echo ""
	@echo "  ClickHouse Commands"
	@echo "  ---------------------"
	@awk 'BEGIN {FS = ":.*##"} /^up-clickhouse:|^cli-clickhouse:|^sdk-clickhouse:|^gui-clickhouse:|^down-clickhouse:|^reset-clickhouse:/ {printf "  %-25s %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ""

help-couchbase: ## Show Couchbase commands
	@echo ""
	@echo "  Couchbase Commands"
	@echo "  --------------------"
	@awk 'BEGIN {FS = ":.*##"} /^up-couchbase:|^cli-couchbase:|^sdk-couchbase:|^gui-couchbase:|^down-couchbase:|^reset-couchbase:/ {printf "  %-25s %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ""

help-elasticsearch: ## Show Elasticsearch commands
	@echo ""
	@echo "  Elasticsearch Commands"
	@echo "  ------------------------"
	@awk 'BEGIN {FS = ":.*##"} /^up-elasticsearch:|^gui-elasticsearch:|^sdk-elasticsearch:|^down-elasticsearch:|^reset-elasticsearch:/ {printf "  %-25s %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ""

help-mongo: ## Show MongoDB commands
	@echo ""
	@echo "  MongoDB Commands"
	@echo "  ------------------"
	@awk 'BEGIN {FS = ":.*##"} /^up-mongo:|^cli-mongo:|^sdk-mongo:|^gui-mongo:|^down-mongo:|^reset-mongo:/ {printf "  %-25s %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ""

help-redis: ## Show Redis commands
	@echo ""
	@echo "  Redis Commands"
	@echo "  ----------------"
	@awk 'BEGIN {FS = ":.*##"} /^up-redis:|^cli-redis:|^sdk-redis:|^gui-redis:|^down-redis:|^reset-redis:/ {printf "  %-25s %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ""


# Grouped help commands
help-file: ## Show file-based database commands
	@echo ""
	@echo "  File-based Databases Commands"
	@echo "  -------------------------------"
	@awk 'BEGIN {FS=":.*##"} /^up-duckdb:|^cli-duckdb:|^sdk-duckdb:|^down-duckdb:|^reset-duckdb:/ {printf "  %-25s %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ""
	@awk 'BEGIN {FS=":.*##"} /^up-sqlite:|^cli-sqlite:|^sdk-sqlite:|^down-sqlite:|^reset-sqlite:/ {printf "  %-25s %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ""

help-sql: ## Show SQL database commands
	@echo ""
	@echo "  SQL Databases Commands"
	@echo "  ------------------------"
	@awk 'BEGIN {FS=":.*##"} /^up-mariadb:|^cli-mariadb:|^sdk-mariadb:|^gui-mariadb:|^down-mariadb:|^reset-mariadb:/ {printf "  %-25s %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ""
	@awk 'BEGIN {FS=":.*##"} /^up-mysql:|^cli-mysql:|^sdk-mysql:|^gui-mysql:|^down-mysql:|^reset-mysql:/ {printf "  %-25s %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ""
	@awk 'BEGIN {FS=":.*##"} /^up-postgres:|^cli-postgres:|^sdk-postgres:|^gui-postgres:|^down-postgres:|^reset-postgres:/ {printf "  %-25s %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ""

help-nosql: ## Show NoSQL database commands
	@echo ""
	@echo "  NoSQL Databases Commands"
	@echo "  --------------------------"
	@awk 'BEGIN {FS=":.*##"} /^up-cassandra:|^cli-cassandra:|^sdk-cassandra:|^down-cassandra:|^reset-cassandra:/ {printf "  %-25s %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ""
	@awk 'BEGIN {FS=":.*##"} /^up-clickhouse:|^cli-clickhouse:|^gui-clickhouse:|^sdk-clickhouse:|^down-clickhouse:|^reset-clickhouse:/ {printf "  %-25s %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ""
	@awk 'BEGIN {FS=":.*##"} /^up-couchbase:|^cli-couchbase:|^sdk-couchbase:|^gui-couchbase:|^down-couchbase:|^reset-couchbase:/ {printf "  %-25s %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ""
	@awk 'BEGIN {FS=":.*##"} /^up-elasticsearch:|^gui-elasticsearch:|^sdk-elasticsearch:|^down-elasticsearch:|^reset-elasticsearch:/ {printf "  %-25s %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ""
	@awk 'BEGIN {FS=":.*##"} /^up-mongo:|^cli-mongo:|^sdk-mongo:|^gui-mongo:|^down-mongo:|^reset-mongo:/ {printf "  %-25s %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ""
	@awk 'BEGIN {FS=":.*##"} /^up-redis:|^cli-redis:|^sdk-redis:|^gui-redis:|^down-redis:|^reset-redis:/ {printf "  %-25s %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ""

# Generic full help
help: ## Show all commands
	@echo ""
	@echo "  DB Workbench - Available Commands"
	@echo "  -----------------------------------"
	@awk 'BEGIN {FS = ":.*##"} /^[a-zA-Z0-9_-]+:.*##/ { printf "  %-25s %s\n", $$1, $$2 }' $(MAKEFILE_LIST)
	@echo ""

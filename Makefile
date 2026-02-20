.DEFAULT_GOAL := help

########################################
# SQL Databases
########################################

up-postgres: ## Start PostgreSQL
	docker compose up -d postgres

down-postgres: ## Stop PostgreSQL
	docker compose stop postgres

up-mysql: ## Start MySQL
	docker compose up -d mysql

down-mysql: ## Stop MySQL
	docker compose stop mysql

up-mariadb: ## Start MariaDB
	docker compose up -d mariadb

down-mariadb: ## Stop MariaDB
	docker compose stop mariadb


########################################
# NoSQL Databases
########################################

up-mongo: ## Start MongoDB
	docker compose up -d mongo

down-mongo: ## Stop MongoDB
	docker compose stop mongo

up-redis: ## Start Redis
	docker compose up -d redis

down-redis: ## Stop Redis
	docker compose stop redis

up-cassandra: ## Start Cassandra
	docker compose up -d cassandra

down-cassandra: ## Stop Cassandra
	docker compose stop cassandra

up-elasticsearch: ## Start Elasticsearch
	docker compose up -d elasticsearch

down-elasticsearch: ## Stop Elasticsearch
	docker compose stop elasticsearch

up-clickhouse: ## Start ClickHouse
	docker compose up -d clickhouse

down-clickhouse: ## Stop ClickHouse
	docker compose stop clickhouse

up-couchbase: ## Start Couchbase
	docker compose up -d couchbase

down-couchbase: ## Stop Couchbase
	docker compose stop couchbase


########################################
# File-Based Databases
########################################

up-sqlite: ## Create/Open SQLite database
	python3 data/sqlite/scripts/create_sqlite.py

down-sqlite: ## No-op (SQLite is file-based)
	@echo "SQLite is file-based. Nothing to stop."

up-duckdb-docker: ## DuckDB via Docker CLI
	docker compose run duckdb

up-duckdb-python: ## DuckDB via Python interactive session
	python ./data/duckdb/scripts/create_duckdb.py

up-duckdb: ## Start DuckDB (choice between Docker CLI or Python REPL)
	@echo "Select DuckDB mode:"
	@echo "1) Docker CLI"
	@echo "2) Python REPL"
	@read -p "Enter 1 or 2: " choice; \
	if [ $$choice -eq 1 ]; then \
		make up-duckdb-docker; \
	elif [ $$choice -eq 2 ]; then \
		make up-duckdb-python; \
	else \
		echo "Invalid choice"; \
	fi

down-duckdb:
	docker rm -f duckdb || true


########################################
# Web GUIs
########################################

up-pgadmin: ## Start pgAdmin
	docker compose up -d pgadmin

down-pgadmin: ## Stop pgAdmin
	docker compose stop pgadmin

up-phpmyadmin: ## Start phpMyAdmin
	docker compose up -d phpmyadmin

down-phpmyadmin: ## Stop phpMyAdmin
	docker compose stop phpmyadmin

up-mongo-express: ## Start Mongo Express
	docker compose up -d mongo-express

down-mongo-express: ## Stop Mongo Express
	docker compose stop mongo-express

up-redis-insight: ## Start RedisInsight
	docker compose up -d redis-insight

down-redis-insight: ## Stop RedisInsight
	docker compose stop redis-insight


########################################
# Grouped Commands
########################################

up-sql: ## Start all SQL databases
	docker compose up -d postgres mysql mariadb

down-sql: ## Stop all SQL databases
	docker compose stop postgres mysql mariadb

up-nosql: ## Start all NoSQL databases
	docker compose up -d mongo redis cassandra elasticsearch clickhouse couchbase

down-nosql: ## Stop all NoSQL databases
	docker compose stop mongo redis cassandra elasticsearch clickhouse couchbase


########################################
# Help
########################################

.PHONY: help
help: ## Show this help message
	@echo ""
	@echo "local-databases            Available Commands"
	@echo "-------------------------  --------------------------------"
	@awk 'BEGIN {FS = ":.*##"} /^[a-zA-Z0-9_-]+:.*##/ { printf "  %-25s %s\n", $$1, $$2 }' $(MAKEFILE_LIST)
	@echo ""
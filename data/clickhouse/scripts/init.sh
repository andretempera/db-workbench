#!/bin/sh
# /data/clickhouse/scripts/init.sh

# Start ClickHouse server in background
clickhouse-server &

# Wait until server is ready
until clickhouse-client --host "$CLICKHOUSE_HOST" --port "$CLICKHOUSE_PORT" --user "$CLICKHOUSE_USER" --password "$CLICKHOUSE_PASSWORD" --query "SELECT 1" > /dev/null 2>&1; do
    echo "Waiting for ClickHouse..."
    sleep 2
done

echo "ClickHouse is up. Running initialization script..."

# Run SQL init
clickhouse-client --host "$CLICKHOUSE_HOST" --port "$CLICKHOUSE_PORT" --user "$CLICKHOUSE_USER" --password "$CLICKHOUSE_PASSWORD" < /data/clickhouse/scripts/init.sql

# Keep container alive
wait
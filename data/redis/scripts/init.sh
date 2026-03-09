#!/bin/sh

REDIS_HOST="${REDIS_HOST:-redis}"
REDIS_PORT="${REDIS_PORT:-6379}"
REDIS_PASSWORD="${REDIS_PASSWORD:-rootpass}"
KEY="db_workbench:test:1"
VALUE='{"id":1,"name":"Andre","project":"db-workbench"}'

# wait for Redis to be ready
echo "Waiting for Redis to be ready..."
until redis-cli -h "$REDIS_HOST" -p "$REDIS_PORT" -a "$REDIS_PASSWORD" PING >/dev/null 2>&1; do
    sleep 1
done

echo "Redis is ready. Setting key..."
redis-cli -h "$REDIS_HOST" -p "$REDIS_PORT" -a "$REDIS_PASSWORD" JSON.SET "$KEY" . "$VALUE"

echo "Initialization complete: $KEY set."
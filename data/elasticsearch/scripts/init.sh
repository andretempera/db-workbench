#!/bin/sh
# /data/elasticsearch/scripts/wait-for-es.sh

echo "Starting Elasticsearch with automatic db_workbench_test initialization..."

# Start Elasticsearch in background
elasticsearch &

# Wait until ES is ready
until curl -s -u "$ELASTIC_USER:$ELASTIC_PASSWORD" "http://$ELASTIC_HOST:$ELASTIC_PORT" > /dev/null; do
    echo "Waiting for Elasticsearch..."
    sleep 2
done

echo "Elasticsearch is up. Running initialization script..."

# Run Python init
python /data/elasticsearch/scripts/init.py

# Keep the container running
wait
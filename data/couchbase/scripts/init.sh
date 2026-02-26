#!/bin/bash
set -euo pipefail

COUCHBASE_HOST=${COUCHBASE_HOST:-127.0.0.1}
COUCHBASE_USER=${COUCHBASE_USER:-Administrator}
COUCHBASE_PASSWORD=${COUCHBASE_PASSWORD:-password}
COUCHBASE_BUCKET=${COUCHBASE_BUCKET:-db_workbench}

# Mode parameter check
MODE="${1:-cli}"  # Default to "cli" if no argument is passed

echo "Mode selected: $MODE"

echo "Waiting for Couchbase management port (8091)..."
until curl -s http://$COUCHBASE_HOST:8091/pools >/dev/null 2>&1; do
    sleep 2
done
echo "Management API is up."

# Check if cluster is already initialized
if curl -s http://$COUCHBASE_HOST:8091/pools | grep -q '"pools":\[\]'; then
    echo "Cluster not initialized. Running cluster-init..."
    couchbase-cli cluster-init \
        -c $COUCHBASE_HOST:8091 \
        --cluster-username "$COUCHBASE_USER" \
        --cluster-password "$COUCHBASE_PASSWORD" \
        --cluster-name "db-workbench-cluster" \
        --services data,index,query \
        --cluster-ramsize 256 \
        --cluster-index-ramsize 256 \
        --index-storage-setting default
    echo "Cluster initialized."
else
    echo "Cluster already initialized."
fi

echo "Waiting for Query service (8093)..."
until netstat -tulpn | grep -q ":8093"; do
    sleep 2
done
echo "Query service is running."

# Create bucket if missing
echo "Creating bucket '$COUCHBASE_BUCKET' if missing..."
cbq -engine "couchbase://$COUCHBASE_HOST" -u "$COUCHBASE_USER" -p "$COUCHBASE_PASSWORD" \
    -s "CREATE BUCKET IF NOT EXISTS \`$COUCHBASE_BUCKET\`;"

# Short pause for bucket creation
sleep 5

# Insert test document
echo "Inserting test document..."
cbq -engine "couchbase://$COUCHBASE_HOST" -u "$COUCHBASE_USER" -p "$COUCHBASE_PASSWORD" \
    -s "UPSERT INTO \`$COUCHBASE_BUCKET\` (KEY, VALUE) VALUES ('test:1', { 'id': 1, 'name': 'Andre', 'project': 'db-workbench' });"

# Ensure primary index exists
echo "Creating primary index..."
cbq -engine "couchbase://$COUCHBASE_HOST" -u "$COUCHBASE_USER" -p "$COUCHBASE_PASSWORD" \
    -s "CREATE PRIMARY INDEX IF NOT EXISTS ON \`$COUCHBASE_BUCKET\`;"

# Mode-specific execution
if [[ "$MODE" == "cli" ]]; then
    echo "Starting interactive Couchbase shell..."
    exec cbq -engine "couchbase://$COUCHBASE_HOST" -u "$COUCHBASE_USER" -p "$COUCHBASE_PASSWORD"
elif [[ "$MODE" == "gui" ]]; then
    echo "Initialization complete."
    exit 0
elif [[ "$MODE" == "python" ]]; then
    echo "Starting Python SDK shell..."
    python3 /data/couchbase/scripts/init_sdk.py
    exit 0
else
    echo "Unknown mode: $MODE. Exiting."
    exit 1
fi
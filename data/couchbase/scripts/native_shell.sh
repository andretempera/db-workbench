#!/bin/bash
# /data/couchbase/scripts/native_shell.sh
set -e

# Environment variables
COUCHBASE_HOST=${COUCHBASE_HOST:-localhost}
COUCHBASE_USER=${COUCHBASE_USER:-Administrator}
COUCHBASE_PASSWORD=${COUCHBASE_PASSWORD:-password}
COUCHBASE_BUCKET=${COUCHBASE_BUCKET:-db_workbench}

echo "Couchbase server is up."

# Initialize cluster if not already done
echo "Initializing cluster..."
if ! couchbase-cli server-info -c "$COUCHBASE_HOST:8091" -u "$COUCHBASE_USER" -p "$COUCHBASE_PASSWORD" >/dev/null 2>&1; then
    echo "Cluster not initialized. Initializing..."
    couchbase-cli cluster-init \
        --cluster-username "$COUCHBASE_USER" \
        --cluster-password "$COUCHBASE_PASSWORD" \
        --cluster-name "db-workbench-cluster" \
        --services data,index,query \
        --cluster-ramsize 256 \
        --cluster-index-ramsize 128 \
        --index-storage-setting default
else
    echo "Cluster may already be initialized"
fi

# Wait for Query service to be ready
echo "Waiting for Query service..."
until curl -s "http://$COUCHBASE_HOST:8093/query/service" >/dev/null 2>&1; do
    sleep 2
done
echo "Query service is online."

# Create bucket if missing
echo "Creating bucket $COUCHBASE_BUCKET if missing..."
cbq -u "$COUCHBASE_USER" -p "$COUCHBASE_PASSWORD" -s "CREATE BUCKET IF NOT EXISTS \`$COUCHBASE_BUCKET\`;"
sleep 5

# Insert test document
echo "Inserting test document into $COUCHBASE_BUCKET..."
cbq -u "$COUCHBASE_USER" -p "$COUCHBASE_PASSWORD" -s "UPSERT INTO \`$COUCHBASE_BUCKET\` (KEY, VALUE) VALUES ('test:1', { 'id': 1, 'name': 'Andre', 'project': 'db-workbench' });"

# Drop into interactive Couchbase shell
echo "Initialization complete. Dropping into interactive Couchbase shell..."
exec cbq -u "$COUCHBASE_USER" -p "$COUCHBASE_PASSWORD"
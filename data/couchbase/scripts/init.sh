#!/bin/bash
set -euo pipefail

# Exit early if marker exists
INIT_MARKER="/tmp/.couchbase_init_done"
if [ -f "$INIT_MARKER" ]; then
    echo "Init script already ran. Skipping."
    exit 0
fi

# --- Config variables ---
COUCHBASE_HOST=${COUCHBASE_HOST:-127.0.0.1}
COUCHBASE_USER=${COUCHBASE_USER:-Administrator}
COUCHBASE_PASSWORD=${COUCHBASE_PASSWORD:-password}
COUCHBASE_BUCKET=${COUCHBASE_BUCKET:-db_workbench}

echo "Waiting for Couchbase management API..."

# Wait for management API
until curl -sf http://$COUCHBASE_HOST:8091/pools >/dev/null 2>&1; do
    sleep 2
done
echo "Management API ready."

# Initialize cluster if needed
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

# Wait until Query service reports ready for the bucket
echo "Waiting for Query service to accept queries..."
for i in {1..30}; do
    if cbq -u "$COUCHBASE_USER" -p "$COUCHBASE_PASSWORD" \
        --engine http://$COUCHBASE_HOST:8093 -s "SELECT 1;" >/dev/null 2>&1; then
        echo "Query service ready."
        break
    else
        echo "Query service not ready yet..."
        sleep 2
    fi
done

# Create bucket if missing
echo "Creating bucket '$COUCHBASE_BUCKET' if missing..."
until cbq -u "$COUCHBASE_USER" -p "$COUCHBASE_PASSWORD" \
    --engine http://$COUCHBASE_HOST:8093 \
    -s "CREATE BUCKET IF NOT EXISTS \`$COUCHBASE_BUCKET\`;"; do
    echo "Waiting for bucket creation..."
    sleep 2
done

until curl -s -u "$COUCHBASE_USER:$COUCHBASE_PASSWORD" \
  http://$COUCHBASE_HOST:8091/pools/default/buckets/$COUCHBASE_BUCKET \
  | grep -q '"nodes"'; do
    echo "Bucket not ready yet..."
    sleep 2
done

sleep 3

echo "Bucket ready."

# Create collection if missing
cbq -u "$COUCHBASE_USER" -p "$COUCHBASE_PASSWORD" \
    --engine http://$COUCHBASE_HOST:8093 \
    --script="
CREATE COLLECTION \`$COUCHBASE_BUCKET\`.\`_default\`.\`test\` IF NOT EXISTS;
"

# Insert test document
echo "Inserting test document..."
cbq -u "$COUCHBASE_USER" -p "$COUCHBASE_PASSWORD" \
    --engine http://$COUCHBASE_HOST:8093 \
    -s "UPSERT INTO \`$COUCHBASE_BUCKET\`.\`_default\`.\`test\` (KEY, VALUE) VALUES ('id:1', { 'name': 'Andre', 'project': 'db-workbench' });"

# Create primary index
echo "Creating primary index..."
cbq -u "$COUCHBASE_USER" -p "$COUCHBASE_PASSWORD" \
    --engine http://$COUCHBASE_HOST:8093 \
    -s "CREATE PRIMARY INDEX IF NOT EXISTS ON \`$COUCHBASE_BUCKET\`.\`_default\`.\`test\`;"

# Creating marker file
touch "$INIT_MARKER"

echo "Couchbase initialization complete."
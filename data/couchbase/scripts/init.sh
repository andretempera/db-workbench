#!/bin/sh
# /data/couchbase/scripts/init.sh

# Start Couchbase in background
couchbase-server &

# Wait for Couchbase server to be ready (Web console on 8091)
until curl -s -u "$COUCHBASE_USER:$COUCHBASE_PASSWORD" "http://$COUCHBASE_HOST:$COUCHBASE_PORT/pools" > /dev/null; do
    echo "Waiting for Couchbase..."
    sleep 5
done

echo "Couchbase is up. Initializing bucket and test document..."

# Run Python init
python /data/couchbase/scripts/init.py

# Keep container alive
wait
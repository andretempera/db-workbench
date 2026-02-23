#!/bin/sh
# Wait for Cassandra to be ready
until cqlsh $$CASSANDRA_HOST $$CASSANDRA_PORT -u $$CASSANDRA_USER -p $$CASSANDRA_PASSWORD -e "DESCRIBE KEYSPACES"; do
    echo "Waiting for Cassandra..."
    sleep 5
done

# Execute init script
cqlsh $$CASSANDRA_HOST $$CASSANDRA_PORT -u $$CASSANDRA_USER -p $$CASSANDRA_PASSWORD -f /data/cassandra/scripts/init.cql
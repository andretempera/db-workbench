#!/bin/bash

# Exit early if marker exists
KIBANA_MARKER="./data/elasticsearch/logs/.init_kibana_done"
if [ -f "$KIBANA_MARKER" ]; then
    echo "Kibana system password already set. Skipping."
    exit 0
fi

# Set the Elasticsearch URL and Kibana credentials from environment variables
ES_URL="https://localhost:9200"
ES_USER="elastic"
ES_PASSWORD="${ELASTIC_PASSWORD}"
KIBANA_USER="${KIBANA_SYSTEM_USER}"
KIBANA_PASSWORD="${KIBANA_SYSTEM_PASSWORD}"

# Wait for Elasticsearch to be ready
echo "Waiting for Elasticsearch to be available..."

until curl -k -s -u ${ES_USER}:${ES_PASSWORD} "${ES_URL}/_cluster/health?wait_for_status=yellow&timeout=10s" | grep -q '"status":"yellow"'; do
  echo "Waiting for Elasticsearch..."
  sleep 5
done

echo "Elasticsearch is up and running."

# Set the Kibana system password using curl
echo "Setting the Kibana system password..."

curl -k -u ${ES_USER}:${ES_PASSWORD} -X POST "${ES_URL}/_security/user/${KIBANA_USER}/_password" -H 'Content-Type: application/json' -d"
{
  \"password\": \"${KIBANA_PASSWORD}\"
}"
# Check if the command succeeded
if [ $? -eq 0 ]; then
    echo "Kibana system password set successfully."
else
    echo "Failed to set Kibana system password."
    exit 1
fi

# Creating marker file
touch "$KIBANA_MARKER"

# Everything is ready, exit the script
exit 0
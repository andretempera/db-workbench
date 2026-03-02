import os
import sys
import time
import code
from clickhouse_connect import get_client

# Environment variables with defaults
CLICKHOUSE_HOST = os.getenv("CLICKHOUSE_HOST", "clickhouse")
CLICKHOUSE_PORT = int(os.getenv("CLICKHOUSE_PORT", "8123"))
CLICKHOUSE_USER = os.getenv("CLICKHOUSE_USER", "root")
CLICKHOUSE_PASSWORD = os.getenv("CLICKHOUSE_PASSWORD", "")
CLICKHOUSE_DATABASE = os.getenv("CLICKHOUSE_DATABASE", "db_workbench")

# Basic validation
if not all([CLICKHOUSE_HOST, CLICKHOUSE_PORT, CLICKHOUSE_USER, CLICKHOUSE_DATABASE]):
    print("Error: Missing one or more required ClickHouse environment variables.")
    sys.exit(1)

print(f"Connecting to ClickHouse at {CLICKHOUSE_HOST}:{CLICKHOUSE_PORT}...")

client = None

# Retry logic
for attempt in range(10):
    try:
        client = get_client(
            host=CLICKHOUSE_HOST,
            port=CLICKHOUSE_PORT,
            username=CLICKHOUSE_USER,
            password=CLICKHOUSE_PASSWORD,
            database=CLICKHOUSE_DATABASE
        )
        client.query("SELECT 1")  # test query
        break
    except Exception as e:
        print(f"Attempt {attempt + 1}/10: ClickHouse not ready ({e}), retrying in 3 seconds...")
        time.sleep(3)
else:
    print("Error: Unable to connect to ClickHouse after multiple attempts.")
    sys.exit(1)

print("\n||| ClickHouse SDK Python CLI |||")
print(f"Connected to database '{CLICKHOUSE_DATABASE}'")
print("Objects available:")
print("    - client\n")

# Launch interactive shell
code.interact(local=globals())
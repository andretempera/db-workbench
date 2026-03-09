import os
import sys
import time
import code
import redis
import json

# Environment variables
REDIS_HOST = os.getenv("REDIS_HOST", "redis")
REDIS_PORT = int(os.getenv("REDIS_PORT", 6379))
REDIS_PASSWORD = os.getenv("REDIS_PASSWORD", "rootpass")

# Retry logic to wait for Redis
client = None
for attempt in range(10):
    try:
        client = redis.Redis(
            host=REDIS_HOST,
            port=REDIS_PORT,
            password=REDIS_PASSWORD,
            decode_responses=True
        )
        client.ping()
        break
    except redis.exceptions.ConnectionError:
        print(f"Attempt {attempt+1}/10: Redis not ready, retrying in 3 seconds...")
        time.sleep(3)
else:
    print("Error: Unable to connect to Redis.")
    sys.exit(1)

print("Successfully connected to Redis")
print("Existing keys:", client.keys())

print("\n||| Redis SDK Python CLI |||")
print("Objects available:")
print("    - client\n")

# Launch interactive shell
code.interact(local=globals())
import os
import sys
import time
import code
import redis
from redis.exceptions import ConnectionError

REDIS_HOST = os.getenv("REDIS_HOST", "redis")
REDIS_PORT = int(os.getenv("REDIS_PORT", "6379"))

if not all([REDIS_HOST, REDIS_PORT]):
    print("Error: Missing required Redis environment variables.")
    sys.exit(1)

print(f"Connecting to Redis at {REDIS_HOST}:{REDIS_PORT}...")

r = None

# Retry logic
for attempt in range(10):
    try:
        r = redis.Redis(host=REDIS_HOST, port=REDIS_PORT, decode_responses=True)
        r.ping()
        break
    except ConnectionError:
        print(f"Attempt {attempt + 1}/10: Redis not ready, retrying in 3 seconds...")
        time.sleep(3)
else:
    print("Error: Unable to connect to Redis after multiple attempts.")
    sys.exit(1)

print("\n||| Redis SDK Python CLI |||")
print("Objects available:")
print("    - r (Redis client)\n")

code.interact(local=globals())
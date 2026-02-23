#!/bin/sh
redis-server --requirepass "$REDIS_PASSWORD" &
sleep 2
redis-cli -a "$REDIS_PASSWORD" < /data/redis/scripts/init.redis
wait
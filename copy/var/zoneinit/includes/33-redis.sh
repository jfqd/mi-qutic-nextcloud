if mdata-get spiped_redis_host 1>/dev/null 2>&1; then
  echo "* Use spiped-redis-host"
else
  echo "* Activate local redis"
  gsed -i \
       -e "s/# maxmemory <bytes>/maxmemory 256mb/" \
       -e "s/# maxmemory-policy noeviction/# maxmemory-policy allkeys-lfu/" \
       -e "s/# unixsocket \/tmp\/redis.sock/unixsocket \/var\/tmp\/redis.sock/" \
       /opt/local/etc/redis.conf
  chown root:redis /opt/local/etc/redis.conf
  svcadm enable redis
fi

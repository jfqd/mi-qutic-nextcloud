# newer redis need adjusted rights
chown root:redis /opt/local/etc/redis.conf
chmod 0640 /opt/local/etc/redis.conf
# local use only
echo "* Activate local redis"
gsed -i \
     -e "s/# maxmemory <bytes>/maxmemory 256mb/" \
     -e "s/# maxmemory-policy noeviction/# maxmemory-policy allkeys-lfu/" \
     -e "s/# unixsocket \/tmp\/redis.sock/unixsocket \/var\/tmp\/redis.sock/" \
     /opt/local/etc/redis.conf
svcadm enable redis

# set nexcloud data path
if mdata-get data_path 1>/dev/null 2>&1; then
  DATA_PATH=`mdata-get data_path`
  cd /var/www/htdocs/nextcloud/current/
  ln -nfs "$DATA_PATH" data
fi

if mdata-get config_path 1>/dev/null 2>&1; then
  DATA_PATH=`mdata-get config_path`
  cd /var/www/htdocs/nextcloud/current/
  ln -nfs "$config_path" config
fi


if mdata-get fpm_max_worker 1>/dev/null 2>&1; then
  WORKER=`mdata-get fpm_max_worker`
  /opt/local/bin/sed \
    -i \
    -e "s#pm.max_children = 10#pm.max_children = ${WORKER}#" \
    /opt/local/etc/php-fpm.d/www.conf
  svcadm restart svc:/pkgsrc/php-fpm:default
fi

if mdata-get redis_maxmemory 1>/dev/null 2>&1; then
  MAXMEMORY=`mdata-get redis_maxmemory`
  /opt/local/bin/sed \
    -i \
    -e "s#maxmemory 256mb#maxmemory ${MAXMEMORY}#" \
    /opt/local/etc/redis.conf
  svcadm restart svc:/pkgsrc/redis:default
fi

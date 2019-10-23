#!/bin/bash

if mdata-get proxysql_monitor_pwd 1>/dev/null 2>&1; then
  MONITOR_PWD=`mdata-get proxysql_monitor_pwd`
  sed -i "s#monitor_password=\"monitor\"#monitor_password=\"${MONITOR_PWD}\"#" /opt/local/etc/proxysql.cnf
fi

if mdata-get proxysql_admin_pwd 1>/dev/null 2>&1; then
  PROXY_ADMIN_PWD=`mdata-get proxysql_admin_pwd`
  sed -i "s#admin_credentials=\"admin:admin\"#admin_credentials=\"admin:${PROXY_ADMIN_PWD}\"#" /opt/local/etc/proxysql.cnf
  cat >> /root/.my.cnf << EOF
[client]
host = localhost
port = 3307
user = admin
password = ${PROXY_ADMIN_PWD}
prompt = 'Admin> '
EOF
chmod 0400 /root/.my.cnf
fi

if mdata-get percona_host 1>/dev/null 2>&1; then
  PERCONA_HOST=`mdata-get percona_host`
  sed -i "s/main.example.com/${PERCONA_HOST}/g" /opt/local/etc/proxysql.cnf
fi

if mdata-get percona_fallback_host 1>/dev/null 2>&1; then
  PERCONA_FALLBACK=`mdata-get percona_fallback_host`
  sed -i "s/backup.example.com/${PERCONA_FALLBACK}/g" /opt/local/etc/proxysql.cnf
fi

if mdata-get proxysql_database_user 1>/dev/null 2>&1; then
  PROXY_DB_USER=`mdata-get proxysql_database_user`
  sed -i "s#db-username#${PROXY_DB_USER}#" /opt/local/etc/proxysql.cnf
fi

if mdata-get proxysql_database_pwd 1>/dev/null 2>&1; then
  PROXY_DB_PWD=`mdata-get proxysql_database_pwd`
  sed -i "s#db-password#${PROXY_DB_PWD}#" /opt/local/etc/proxysql.cnf
fi

svcadm enable svc:/pkgsrc/proxysql:default

cat >> /root/.mysql_history << EOF
UPDATE mysql_servers SET status='OFFLINE_HARD' WHERE port='13306';
UPDATE mysql_servers SET status='ONLINE' WHERE port='13306';
LOAD MYSQL SERVERS TO RUNTIME;
SAVE MYSQL SERVERS TO DISK;
SELECT * FROM mysql_servers;
SELECT * FROM stats.stats_mysql_connection_pool;
EOF
chmod 0600 /root/.mysql_history
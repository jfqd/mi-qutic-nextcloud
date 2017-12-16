# set nexcloud data path
if mdata-get data_path 1>/dev/null 2>&1; then
  DATA_PATH=`mdata-get data_path`
  cd /opt/local/share/httpd/nextcloud/current/
  ln -nfs "$DATA_PATH" data
fi

if mdata-get server_name 1>/dev/null 2>&1; then
  SERVER_NAME=`mdata-get server_name`
  sed -i "s:SERVER_NAME:$SERVER_NAME:g" /opt/local/etc/httpd/vhosts/01-nextcloud.conf
fi

if mdata-get config_copy_path 1>/dev/null 2>&1; then
  COPY_PATH=`mdata-get config_copy_path`
  [ -f "$COPY_PATH" ] && cp "$COPY_PATH" /opt/local/share/httpd/nextcloud/shared/config/config.php
fi

# Enable apache by default
/usr/sbin/svcadm enable svc:/pkgsrc/apache:default

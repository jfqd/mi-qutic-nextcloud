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

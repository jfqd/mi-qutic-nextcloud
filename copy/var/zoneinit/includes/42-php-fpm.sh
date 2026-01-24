#!/bin/bash

#################################
# nginx config
#
if mdata-get mail_adminaddr 1>/dev/null 2>&1; then
  # Configure PHP sendmail return-path if possible
  echo "php_admin_value[sendmail_path] = /usr/sbin/sendmail -t -i -f $(mdata-get mail_adminaddr)" \
    >> /opt/local/etc/php/8.4/php-fpm.d/www.conf
fi

sed -i "s:nc.example.com:$(mdata-get server_name):g" /opt/local/etc/nginx/nginx.conf
sed -i "s:HOSTNAME:$(hostname):g" /opt/local/etc/httpd/vhosts/00-default.conf

#################################
# now decide which one to use:
# nginx (default) or apache
#
if [[ `mdata-get nginx_fpm 2>/dev/null` = "false" ]]; then
  #################################
  # use apache
  #
  if mdata-get server_name 1>/dev/null 2>&1; then
    SERVER_NAME=`mdata-get server_name`
    sed -i "s:SERVER_NAME:$SERVER_NAME:g" /opt/local/etc/httpd/vhosts/01-nextcloud.conf
  else
    sed -i "s:ServerName SERVER_NAME::g" /opt/local/etc/httpd/vhosts/01-nextcloud.conf
  fi

  if mdata-get server_alias 1>/dev/null 2>&1; then
    SERVER_ALIAS=`mdata-get server_alias`
    sed -i "s:SERVER_ALIAS:$SERVER_ALIAS:g" /opt/local/etc/httpd/vhosts/01-nextcloud.conf
  else
    sed -i "s:ServerAlias SERVER_ALIAS::g" /opt/local/etc/httpd/vhosts/01-nextcloud.conf
  fi
  
  # Enable apache
  /usr/sbin/svcadm enable svc:/pkgsrc/apache:default
  echo "/opt/local/bin/sed -i \"s#/var/log/php-fpm84.log.*##\" /etc/logadm.conf" >> /opt/local/bin/uptodate

else
  #################################
  # use nginx
  #

  # Disable Apache
  /usr/sbin/svcadm disable apache || true
  
  # Enable PHP-FPM
  /usr/sbin/svcadm enable svc:/pkgsrc/php-fpm84:default
  /usr/sbin/svcadm enable nginx
  echo "/opt/local/bin/sed -i \"s#/var/log/nginx/.*##\" /etc/logadm.conf" >> /opt/local/bin/uptodate

  # remove httpd cron-log-helper
  sed -i \
      "s|.*/usr/bin/ls -1dt /var/log/httpd/access.*|# removed httpd cron-log-helper|" \
      /var/spool/cron/crontabs/root
  
fi

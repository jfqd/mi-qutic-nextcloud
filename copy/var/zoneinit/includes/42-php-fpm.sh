#!/usr/bin/env bash

if mdata-get mpm_event 1>/dev/null 2>&1; then
  if [[ `mdata-get mpm_event` = "true" ]]; then
    # Deactivate apache mpm-prefork files
    mv /opt/local/etc/httpd/conf.d/00-modules_prefork.conf /opt/local/etc/httpd/conf.d/00-modules_prefork.bak
    mv /opt/local/etc/httpd/conf.d/09-tuning_prefork.conf /opt/local/etc/httpd/conf.d/09-tuning_prefork.bak

    # Deactivate php-module
    mv /opt/local/etc/httpd/conf.d/10-php.conf /opt/local/etc/httpd/conf.d/10-php.bak
    
    # Activate apache mpm-event files
    mv /opt/local/etc/httpd/conf.d/00-modules_event.bak /opt/local/etc/httpd/conf.d/00-modules_event.conf
    mv /opt/local/etc/httpd/conf.d/09-tuning_event.bak /opt/local/etc/httpd/conf.d/09-tuning_event.conf

    # Configure PHP sendmail return-path if possible
    if mdata-get mail_adminaddr 1>/dev/null 2>&1; then
      echo "php_admin_value[sendmail_path] = /usr/sbin/sendmail -t -i -f $(mdata-get mail_adminaddr)" \
        >> /opt/local/etc/php-fpm.d/pool-www.conf
    fi

    # Enable PHP-FPM
    /usr/sbin/svcadm enable svc:/pkgsrc/php-fpm:default
  fi
fi
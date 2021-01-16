# create cronjob for nexcloud script
echo '0,10,20,30,40,50 * * * * /opt/local/bin/php /var/www/htdocs/nextcloud/current/cron.php > /dev/null' >> /var/spool/cron/crontabs/www
echo "0,15,30,45 * * * * /usr/bin/find /var/tmp/ -name sess_* -cmin +120 -exec rm '{}' +" >> /var/spool/cron/crontabs/www

CRONJOB_ALL_FILES=`mdata-get cronjob_all_files`
if "$CRONJOB_ALL_FILES" != "false" 1>/dev/null 2>&1; then
  echo "38 3 * * * /opt/local/bin/php /var/www/htdocs/nextcloud/current/console.php files:scan --all" >> /var/spool/cron/crontabs/www
fi

echo "# End" >> /var/spool/cron/crontabs/www
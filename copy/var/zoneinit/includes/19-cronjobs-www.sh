# create cronjob for nexcloud script
echo '0,10,20,30,40,50 * * * * /opt/local/bin/php /var/www/htdocs/nextcloud/current/cron.php' >> /var/spool/cron/crontabs/www
echo "0,15,30,45 * * * * /usr/bin/find /var/tmp/ -name sess_* -cmin +120 -exec rm '{}' +" >> /var/spool/cron/crontabs/www
echo "# End" >> /var/spool/cron/crontabs/www

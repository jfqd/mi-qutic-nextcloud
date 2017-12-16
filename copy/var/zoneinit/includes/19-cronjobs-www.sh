# create cronjob for nexcloud script
echo '10,25,40,55 * * * * /opt/local/bin/php /opt/local/share/httpd/nextcloud/current/cron.php' >> /var/spool/cron/crontabs/www

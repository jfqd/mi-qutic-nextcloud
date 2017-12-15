# set php sender email address
if mdata-get mail_auth_user 1>/dev/null 2>&1; then
  echo "sendmail_from = $(mdata-get mail_auth_user);" > /opt/local/etc/php.d/sendmail_from.ini
fi
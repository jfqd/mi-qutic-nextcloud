#!/usr/bin/env bash

# Setup hostname
sed -i "s:HOSTNAME:$(hostname):g" /opt/local/etc/httpd/vhosts/00-default.conf

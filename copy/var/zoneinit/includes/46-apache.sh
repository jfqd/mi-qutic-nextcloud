#!/usr/bin/env bash

# TODO
# set MaxRequestWorkers and ServerLimit
# by script related to available memory

# Setup hostname
sed -i "s:HOSTNAME:$(hostname):g" /opt/local/etc/httpd/vhosts/00-default.conf

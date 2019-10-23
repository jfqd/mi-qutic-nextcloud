#!/usr/bin/bash

# cleanup mdata-store
mdata-delete mail_smarthost || true
mdata-delete mail_auth_user || true
mdata-delete mail_auth_pass || true
mdata-delete mail_adminaddr || true
mdata-delete admin_authorized_keys || true
mdata-delete root_authorized_keys || true
mdata-delete proxysql_admin_pwd || true
mdata-delete proxysql_monitor_pwd || true
mdata-delete proxysql_database_pwd || true
mdata-delete spiped_key || true

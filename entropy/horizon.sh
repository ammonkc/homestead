#!/usr/bin/env bash

SITEPATH=`echo $2 | sed -e "s,/*[^/]\+/*$,,"`

cat << HORIZON_EOF > /etc/supervisord.d/horizon-$1.ini
[program:horizon-$1]
process_name=%(program_name)s
command=/usr/bin/php $SITEPATH/artisan horizon
autostart=true
autorestart=true
startretries=10
user=apache
redirect_stderr=true
stdout_logfile=/var/log/horizon.log
HORIZON_EOF

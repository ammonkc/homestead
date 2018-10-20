#!/usr/bin/env bash

BOXNAME=$1
BOXVERSION=$2
export COMPOSER_ALLOW_SUPERUSER=1

echo 'Welcome to your Entropy virtual machine.' > /etc/motd

# Disable static motd
# sed -i 's/#PrintMotd yes/PrintMotd no/g' /etc/ssh/sshd_config
# install motd.sh
cat << MOTD_EOF > /etc/profile.d/motd.sh
#!/bin/bash

echo -e "
                _
               | |
      ___ _ __ | |_ _ __ ___  _ __  _   _
     / _ \ '_ \| __| '__/ _ \| '_ \| | | |
    |  __/ | | | |_| | | (_) | |_) | |_| |
     \___|_| |_|\__|_|  \___/| .__/ \__, |
                             | |     __/ |
                             |_|    |___/

################################################
Vagrant Box.......: $BOXNAME (v"$(echo $BOXVERSION | grep -o '[0-9.]*$')")
hostname..........: `hostname`
IP Address........: `/usr/sbin/ip addr show eth1 | grep 'inet ' | cut -f2 | awk '{print $2}'`
OS Release........: `cat /etc/redhat-release`
kernel............: `uname -r`
User..............: `whoami`
Apache............: `/usr/sbin/httpd -v | grep 'Server version' | awk '{print $3}' | tr -d Apache/`
Nginx.............: `echo -e "$(/usr/sbin/nginx -v 2>&1)" | grep -o '[0-9.]*$'`
PHP...............: `/usr/bin/php -v | grep cli | awk '{print $2}'`
MySQL.............: `/usr/bin/mysql -V | awk '{print $5}' | tr -d ,`
PostgreSQL........: `/usr/bin/psql --version | awk '{print $3}'`
Redis.............: `/usr/bin/redis-server --version | awk '{print $3}' | grep -o '[0-9.]*$'`
Node..............: `/usr/bin/node --version | grep -o '[0-9.]*$'`
Go................: `/usr/local/go/bin/go version | awk '{print $3}' | grep -o '[0-9.]*$'`
Supervisor........: `/usr/bin/supervisord --version`
Beanstalk.........: `/usr/bin/beanstalkd -v | grep -o '[0-9.]*$'`
Git...............: `/usr/local/git/bin/git --version | awk '{print $3}'`
Composer..........: `/usr/local/bin/composer --version | awk '{print $3}'`
WP-CLI............: `/usr/local/bin/wp --version --allow-root | awk '{print $2}'`
Ngrok.............: `/usr/local/bin/ngrok --version | awk '{print $3}'`
Configured Sites..:
`cat /etc/hosts.dnsmasq`
################################################
"
MOTD_EOF

chmod +x /etc/profile.d/motd.sh

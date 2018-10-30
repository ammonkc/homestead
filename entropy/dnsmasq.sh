#!/usr/bin/env bash


TLD=`echo $2 | sed -e "s/[^.]*]\?\([^.]*\)/\1/" | cut -d'.' -f 2`

sed -i -r "s/listen-address=(192\.|172\.|10\.)(\b[0-9]{1,3}\.){2}[0-9]{1,3}\b/listen-address=$1/" /etc/dnsmasq.d/homestead.conf
echo -e "$1 $2." >> /etc/hosts.dnsmasq
cat << DOMAIN_EOF > /etc/dnsmasq.d/$2.conf
address=/$2/$1
DOMAIN_EOF

#!/usr/bin/env bash


TLD=`echo $2 | sed -e "s/[^.]*]\?\([^.]*\)/\1/" | cut -d'.' -f 2`

sed -i -r "s/listen-address=(192\.|172\.|10\.)(\b[0-9]{1,3}\.){2}[0-9]{1,3}\b/listen-address=$1/" /etc/dnsmasq.d/homestead.conf
echo -e "$1 $2." >> /etc/hosts.dnsmasq
echo -e "domain=$TLD" > "/etc/dnsmasq.d/$TLD.conf"
echo -e "local=/$TLD/" >> "/etc/dnsmasq.d/$TLD.conf"

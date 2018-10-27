#!/usr/bin/env bash

# Clear The Old Dnsmasq records

echo -e "$1 homestead.test." > /etc/hosts.dnsmasq

find /etc/dnsmasq.d/ -type f -not -name 'homestead.conf' -delete

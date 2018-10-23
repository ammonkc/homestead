#!/usr/bin/env bash

# Clear The Old Dnsmasq records

> /etc/hosts.dnsmasq

find /etc/dnsmasq.d/ -type f -not -name 'homestead.conf' -delete

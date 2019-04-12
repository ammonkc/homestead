#!/usr/bin/env bash

# Clear The Old supervisord configs

find /etc/supervisord.d/ -type f -name 'horizon-*.ini' -delete

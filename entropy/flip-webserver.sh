#!/usr/bin/env bash

ps auxw | grep httpd | grep -v grep > /dev/null

if [ $? != 0 ]
then
    sudo systemctl stop nginx > /dev/null
    echo 'nginx stopped'
    sudo systemctl start httpd > /dev/null
    echo 'apache started'
else
    sudo systemctl stop httpd > /dev/null
    echo 'apache stopped'
    sudo systemctl start nginx > /dev/null
    echo 'nginx started'
fi

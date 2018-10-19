#!/usr/bin/env bash

if [ -f "/home/vagrant/.commonrc" ]; then
    echo -e '[[ -f "$HOME/.bash_aliases" ]] && source "$HOME/.bash_aliases"' >> "/home/vagrant/.commonrc"
fi

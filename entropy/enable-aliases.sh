#!/usr/bin/env bash

# if [ -f "/home/vagrant/.commonrc" ]; then
#     echo -e '[[ -f "$HOME/.bash_aliases" ]] && source "$HOME/.bash_aliases"' >> "/home/vagrant/.commonrc"
# fi

ALIASFILE="/home/vagrant/.bash_aliases"

if [ -f "$ALIASFILE" ]; then
    sed -i 's/if [[ "$1" && "$2" ]]/if [[ -n "$1" && -n "$2" ]]/' $ALIASFILE
fi

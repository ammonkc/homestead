#!/usr/bin/env bash

ALIASFILE="/home/vagrant/.bash_aliases"

if [ -f "$ALIASFILE" ]; then
    sed -i 's/if \[\[ \"$1\" \&\& \"$2\" \]\]/if \[\[ -n \"$1\" \&\& -n \"$2\" \]\]/g' $ALIASFILE
    sed -i 's/if \[\[ \"$1\" \]\]/if \[\[ -n \"$1\" \]\]/g' $ALIASFILE
fi

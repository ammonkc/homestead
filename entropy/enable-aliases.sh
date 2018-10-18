#!/usr/bin/env bash

if [ -f "$HOME/.commonrc" ]; then
    echo -e '[[ -f "$HOME/.bash_aliases" ]] && source "$HOME/.bash_aliases"' >> "$HOME/.commonrc"
fi

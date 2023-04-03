#!/bin/bash

NOTES=/home/$USER/Notes
#RG_BIN=/usr/bin/rg
#GREP=/usr/bin/grep
CMD="rg --heading -w -i -g !"*fish-history*" -g !"*.html*" -g !"*apt-packages*" -g !"*.json" -g !"*-fish-history*" -g !"*backup*""

if [[ -z $1 ]]; then
    echo "You must provide a search term as the argument to this command."
    exit 1
else
    TARGET="$1"
fi
# rg --heading -i "joanna" ~/Notes/journal/
$CMD "$TARGET" $NOTES



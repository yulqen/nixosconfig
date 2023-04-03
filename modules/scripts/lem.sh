#!/usr/bin/bash

NOTES=/home/$USER/Notes
TARGET_DIR=/home/lemon/Notes/homezet
VIM=/usr/bin/vim

if [[ "$1" = "-m" ]]; then
    msg="${*:2}"
    TARGET_DIR=/home/lemon/Documents/MOD/modzet
    shift
else
    msg="$@"
    shift
fi


STAMP="$(date +%G%m%d%H%M%S)"
F_PATH="$TARGET_DIR/$STAMP-$msg.md"

printf "# %s", "$msg" >> "$F_PATH"

$VIM "$F_PATH"

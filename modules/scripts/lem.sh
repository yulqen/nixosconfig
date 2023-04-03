#!/usr/bin/env bash

NOTES=/home/$USER/Notes
TARGET_DIR=/home/lemon/Notes/homezet

if [[ "$1" = "-m" ]]; then
    msg="${*:2}"
    TARGET_DIR=/home/lemon/Documents/Notes/MOD/modzet
    shift
else
    msg="$@"
    shift
fi


STAMP="$(date +%G%m%d%H%M%S)"
F_PATH="$TARGET_DIR/$STAMP-$msg.md"

printf "# %s", "$msg" >> "$F_PATH"

vim "$F_PATH"

{ pkgs, stdenv, ...}:

let
  todj = pkgs.writeShellScriptBin "todj" ''

#!/usr/bin/env bash

if [[ $1 = "-v" ]]
then
  CMD=${pkgs.vim}/bin/vim
  $CMD $(find /home/lemon/Documents/Notes/journal -name \*$(date '+%Y-%m-%d'\*))
else
  CMD=cat
  # $CMD $(find /home/lemon/Documents/Notes/journal -name "*$(date '+%Y-%m-%d')*")
  $CMD $(find /home/lemon/Documents/Notes/journal -name \*$(date '+%Y-%m-%d'\*))
fi

    '';

in
  {
    home.packages = [ todj ];
  }

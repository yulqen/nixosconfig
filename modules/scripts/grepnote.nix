{ pkgs, stdenv, ... }:

let
  script = builtins.readFile ./grepnote.sh;
  grepnote = pkgs.writeShellScriptBin "grepnote" script;
in
  {
    home.packages = [ grepnote ];
  }


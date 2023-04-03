{ pkgs, stdenv, ... }:

let
  script = builtins.readFile ./grepjournal.sh;
  grepjournal = pkgs.writeShellScriptBin "grepjournal" script;
in
  {
    home.packages = [ grepjournal ];
  }


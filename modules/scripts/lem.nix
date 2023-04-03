
{pkgs, stdenv, ...}:
let
  script = builtins.readFile ./lem.sh;
  lem = pkgs.writeShellScriptBin "lem" script;

in
  {
    home.packages = [ lem ];
  }

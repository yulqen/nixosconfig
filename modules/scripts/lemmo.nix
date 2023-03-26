
{pkgs, stdenv, ...}:
let
  lemmo = pkgs.writeShellScriptBin "lemmo" ''
NOTES=/home/$USER/Documents/Notes
TARGET_DIR=/home/lemon/Documents/Notes/homezet
VIM=${pkgs.vim}/bin/vim

if [[ "$1" = "-m" ]]; then
    msg="$\{*:2\}"
    TARGET_DIR=/home/lemon/Documents/MODObsidian/MOD
    shift
else
    msg="$@"
    shift
fi


STAMP="$(date +%G%m%d%H%M%S)"
F_PATH="$TARGET_DIR/$STAMP-$msg.md"

printf "# %s", "$msg" >> "$F_PATH"

$VIM "$F_PATH"

    '';

in
  {
    home.packages = [ lemmo ];
  }


{pkgs, stdenv, ...}:
let
  batnote = pkgs.writeShellScriptBin "batnote" ''

# a script for FZFing through my Notes folder for quick reading.
# Uses bat if installed, otherwise will use less.

NOTES="/home/lemon/Documents/Notes"
FZF_BIN="${pkgs.fzf}/bin/fzf"
CAT="${pkgs.bat}/bin/bat"
VIM=${pkgs.vim}/bin/vim

CMD="$CAT"

# instead of viewing with less, we want to edit in Vim
if ! [[ -x $FZF_BIN ]]; then
    echo "You need to have FZF installed for this to work."
    exit 1
fi

if [[ $1 = "-v" ]]
then
  echo "Using vim..."
  CMD=$VIM
  # Thanks to https://stackoverflow.com/a/1489405 for the find command to omit .git
  $CMD "$(find $NOTES -name '.git*' -type d -prune -o -type f -print|$FZF_BIN)"
  exit
fi

if [[ $1 = "-m" ]]
then
  echo "Searching mod files only..."
  NOTES=$NOTES/MOD
	if [[ $2 = "-v" ]]
	then
	  echo "Using vim..."
	  CMD=$VIM
	fi
  # Thanks to https://stackoverflow.com/a/1489405 for the find command to omit .git
  $CMD "$(find $NOTES -name '.git*' -type d -prune -o -type f -print|$FZF_BIN)"
  exit
fi

# if [[ -z $1 ]]; then
#     echo "You must provide a file name as the argument to this command."
#     exit 1
# else
#     TARGET=$1
# fi



# Thanks to https://stackoverflow.com/a/1489405 for the find command to omit .git
clear; $CMD "$(find $NOTES -name '.git*' -type d -prune -o -type f -print|$FZF_BIN)"
        '';
in
  {
    home.packages = [ batnote ];
  }

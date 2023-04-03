{pkgs, stdenv, ...}:

let
  zetrename = pkgs.writeShellScriptBin "zetrename" ''
# Renaming files of the format YYYYMMDDHHMMSS-title text etc.md is a massive pain, so this script does it for you.

NOTES=/home/$USER/Notes/MOD/modzet

function usage {
    echo
    echo "Usage: zetrename [PATH] [NAME]"
    echo " Renames a zet file, retaining original time stamp."
}


if [[ $# -eq 0 ]]; then
    usage; exit 1
fi

# path must be of form /home/$USER/Notes/MOD/modzet/20220419133511-Title of file.md

#re='^/tmp\/Notes\/modzet\/(.{14})-(.+)\.md'
re='^/home\/lemon\/Notes\/MOD\/modzet\/(.{14})-(.+)\.md'
if [[ "$1" =~ $re ]]; then
	notedate=\$\{BASH_REMATCH[1]}
	oldname=\$\{BASH_REMATCH[2]}
else
	echo "Please ensure you pass an appropriate absolute path to the file to be renamed or ensure it is quoted."
	exit 1
fi

NEW_PATH="$NOTES/$notedate-$2.md"

echo "$NEW_PATH"


# rename
mv "$1" "$NEW_PATH"
'';
in
  {
    home.packages = [ zetrename ];
  }


{pkgs, stdenv, ...}:
let
  tj = pkgs.writeShellScriptBin "tj" ''

# Here we are allowed to pass the -m flag to send the output to a different journal - one for work.
DEFAULT_JOURNAL=~/Documents/Notes/journal/home/$(date +\%Y-\%m-\%d).md
USE_CUSTOM_JOURNAL=false

while getopts "m" opt; do
  case $opt in
    m)
      USE_CUSTOM_JOURNAL=true
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done

shift $((OPTIND-1))

# Set TODAY_JOURNAL to the default value or the custom value depending on the flag
if [ "$USE_CUSTOM_JOURNAL" = true ]; then
  TODAY_JOURNAL=~/Documents/Notes/journal/work/MOD-$(date +\%Y-\%m-\%d).md
else
  TODAY_JOURNAL="$DEFAULT_JOURNAL"
fi


# Test whether it already exisits or not
if [[ -a $TODAY_JOURNAL ]]
then
        JLINE="- $(date +'%H:%M'): $1"
        echo "$JLINE" >> "$TODAY_JOURNAL"
else
    touch "$TODAY_JOURNAL"
    header_date="$(date +'%A %d %b %Y')"
    {   echo -e "# $header_date\n"
    } >> "$TODAY_JOURNAL"
        JLINE="- $(date +'%H:%M'): $1"
        echo "$JLINE" >> "$TODAY_JOURNAL"
fi
        '';

in
  {
    home.packages = [ tj ];
  }

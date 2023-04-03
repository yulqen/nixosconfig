#!/bin/env bash

# Search ~/Notes/journal/home for a term and return as a markdown list sorted by date.

function usage {
    echo
    echo "Usage: grepjournal [WORD] [-i (case insensitve)] [-h (display this help)]"
    echo "  Searches for WORD within all files within ~/Notes/journal. Displayed sorted by date."
}

if [[ $# -eq 0 ]]; then
    usage; exit 1
fi

while [[ $# -gt 0 ]]; do
    if [[ "$1" = "-i" ]]; then
        flag="-i"
        shift
    elif [[ "$1" = "-h" ]] || [[ "$1" = "--help" ]]; then
        usage
        exit
    else
        searchterm=$1
        shift
    fi
done

_get_weekday() {
    local monday="# (Monday)"
    local tuesday="# (Tuesday)"
    local wednesday="# (Wednesday)"
    local thursday="# (Thursday)"
    local friday="# (Friday)"
    local saturday="# (Saturday)"
    local sunday="# (Sunday)"
    while IFS= read -r fileline; do
        if [[ $fileline =~ $monday ]]; then
            echo "${BASH_REMATCH[1]}"
        elif [[ $fileline =~ $tuesday ]]; then
            echo "${BASH_REMATCH[1]}"
        elif [[ $fileline =~ $wednesday ]]; then
            echo "${BASH_REMATCH[1]}"
        elif [[ $fileline =~ $thursday ]]; then
            echo "${BASH_REMATCH[1]}"
        elif [[ $fileline =~ $friday ]]; then
            echo "${BASH_REMATCH[1]}"
        elif [[ $fileline =~ $saturday ]]; then
            echo "${BASH_REMATCH[1]}"
        elif [[ $fileline =~ $sunday ]]; then
            echo "${BASH_REMATCH[1]}"
        fi
    done < "$1"
}

colourWhite="\033[38;2;255;255;255m"
colourGreen="\033[38;2;0;255;0m"
colourLightGreen="\033[38;2;231;252;179m"
colourGray="\033[38;2;100;100;100m"
colourOrange="\033[38;2;249;130;44m"
colourCyan="\033[38;2;0;255;255m"
txBold="\033[1m"
txReset="\033[0m"

# Automatic cleanup
trap 'rm -f "$grepped_results"' EXIT
grepped_results=$(mktemp) || exit 1

trap 'rm -f "$output_file"' EXIT
output_file=$(mktemp) || exit 1

# nice line across the top
termsize=$(stty size| awk '{print $2}')
printf "${colourWhite}=%.0s" $(seq $termsize)
echo

# some confirmatory echoing
echo -e "${colourWhite}Search term: ${txBold}$searchterm${txReset}"
[[ -v flag ]] && echo "Flag: $flag"

if [[ $flag != "-i" ]]; then
    flag=""
fi

# do the business, starting with using grep to get the pertinent lines
echo -e "$(grep -R $flag "$searchterm" /home/"$USER"/Notes/journal/home)" > "$grepped_results"

# more confirmatory text
echo "Command: 'grep -R $flag $searchterm /home/"$USER"/Notes/journal/home'"

printf "=%.0s" $(seq $termsize)
echo ""

# because I can't get the regex right, I am searching for http or https to indicate a link in a line
urlregex="https?"
re='(^/home/lemon/Notes/journal/home/([0-9]{4})-([0-9]{2})-([0-9]{2})\.md):-\s([0-9]{2}:[0-9]{2}):\s(.*)'
while IFS=  read -r line; do
    if [[ $line =~ $re ]]; then
        path=${BASH_REMATCH[1]}
        year=${BASH_REMATCH[2]}
        month=${BASH_REMATCH[3]}
        day=${BASH_REMATCH[4]}
        time=${BASH_REMATCH[5]}
        note=${BASH_REMATCH[6]}
    fi
    output_day=$(_get_weekday "$path")
    out_line="${colourGreen} "$year"-"$month"-"$day"${colourGray}T${colourLightGreen}"$time": ${output_day} ${txReset} ${note}"
    if [[ $out_line =~ $urlregex ]]; then
        out_line=${out_line/${BASH_REMATCH[0]}/${colourCyan}${BASH_REMATCH[0]}${txReset}}
    fi
    if [[ $out_line =~ $searchterm ]]; then
        out_line=${out_line/$searchterm/"${colourOrange}${txBold}$searchterm${txReset}"}
    fi
    echo -e "$out_line" >> "$output_file" 
done < "$grepped_results"

# output
sort < "$output_file"


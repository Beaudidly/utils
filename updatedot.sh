#!/bin/sh

# Austin Bodzas - July 2016

# Little bash utility I wrote a little too late at night
# These are my early days of bash scripting, I feel like
# I will get addicted to this...


# TODO write help flag functionality to describe how to use it 
# and what it does

FILELIST=()
DOTDIR="$HOME/pkgs/dotfiles/"
FNAMEREGEX='(\w*\.?\w+)$'
RED='\033[0;31m'
GREEN='\033[0,32m'

track ()
{
    # check if the file exists
    if [[ ! -f "$1" ]];
    then 
        echo "File doesn't exit."
        exit 1
    fi


    # check if file is already being tracked
    for file in "${FILELIST[@]}"
    do
        if [[ "$1" == "$file" ]];
        then
            echo "File is already being tracked"
            exit 2
        fi
    done
    
    # append new file to the end of the log
    echo "Adding $1 to update list"
    echo "$1" >> ~/share/dottrack.log
}

update () {
    for file in "${FILELIST[@]}"
    do
        cp "$file" "$DOTDIR"
    done
}

isoutdated () {
    if [[ ! -f "$1" ]]
    then
        ( >&2 echo "Error: non-file passed to isoutdated()" ) 
        exit 1
    fi

    homefile="$1"
    repofile=""

    if [[ $homefile =~ $FNAMEREGEX ]]
    then
        repofile="$DOTDIR${BASH_REMATCH[1]}"
    else
        ( >&2 echo "Error: couldn't parse filename in isoutdated()")
        exit 1
    fi
    
    homedate=$(stat -c %Y "$homefile")
    repodate=$(stat -c %Y "$repofile")

    if [[ $homedate -lt $repodate ]] 
    then
        return 1
    else
        return 0
    fi
}

list () {
        
    printf "Files being tracked:\n\n"
    for file in "${FILELIST[@]}"
    do
        if [[ $file =~ $FNAMEREGEX ]]
        then
            output="${BASH_REMATCH[0]}"
            if isoutdated $file;
            then
                printf "\t${RED}${output}\n"
            else
                printf "\t${GREEN}${output}\n"
            fi
        fi
    done
}

# load tracked files
mapfile -t FILELIST < "$HOME/share/dottrack.log"

while getopts 't:ul' flag; do
    case "${flag}" in
        t) track "$OPTARG" ;;
        u) update ;;
        l) list ;;
        \?) list ;;
        *) ( >&2 echo "Not a valid flag." )
    esac
done

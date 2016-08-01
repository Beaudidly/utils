#!/bin/sh

# Austin Bodzas - July 2016


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
    printf "${GREEN} Files updated.\n" 
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

help () {
    printf "Usage:\n updatedot.sh [options]\n\n"
    printf "Keep track of dotfiles and their storage in a repository.\n\n"
    printf "Options:\n"
    printf "%s\n" " -t <file>   add the file to the tracking list"
    printf "%s\n" " -u          update the files in the repo"
    printf "%s\n\n" " -l          list the files being tracked"
    printf "%s\n" " -h          displays this help message"

    exit 0
}

# load tracked files
mapfile -t FILELIST < "$HOME/share/dottrack.log"

while getopts 't:uhl' flag; do
    case "${flag}" in
        t) track "$OPTARG" ;;
        u) update ;;
        l) list ;;
        h) help ;;
        \?) list ;;
        *) ( >&2 echo "Not a valid flag." )
           help
           ;;
    esac
done

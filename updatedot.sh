#!/bin/sh

FILELIST=()

track ()
{
    for arg in "$@"
    do
        echo "12312"
    done

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
        cp "$file" "$HOME/pkgs/dotfiles"
    done
}

list () {
    echo "Files being tracked:"
    for file in "${FILELIST[@]}"
    do
        echo "$file"
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

#!/bin/sh

# Quick script to update all executable scripts/programs from the utils
# directory.  Just copies them to the $HOME/bin/ folder.  This is really
# just intended to make my life easier, modify to fit your needs.

lastUpdate ()
{
    if [ ! -f $HOME/share/updatelast.log ]
    then
        echo "Not previously updated"
        touch $HOME/share/updatelast.log
    else
        echo "Last update:"
        cat $HOME/share/updatelast.log
    fi
}

update ()
{
    for file in $HOME/pkgs/utils/*
    do
        if [[ -x $file ]]
        then
            cp $file $HOME/bin/
            date > $HOME/share/updatelast.log
        fi
    done
}

lastUpdate
update

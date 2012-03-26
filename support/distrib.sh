#!/bin/bash

MODE="$1";
SSH="/usr/bin/ssh"
SCP="/usr/bin/scp"
RSYNC="/usr/bin/rsync"
MOVEIN="$HOME/bin/movein.sh"

# Check for distrib hosts
if [ ! -f ~/.distrib_hosts ]; then
    echo "!! no ~/.distrib_hosts found !!";
    exit 1;
fi;

## Setups
if [ "$MODE" == "movein" ]; then
    if [ ! -x "$MOVEIN" ]; then
        echo "!! Could not execute $MOVEIN !!"
        exit 1;
    fi;

    for host in `cat ~/.distrib_hosts`; do
        echo "=> Running movein.sh to $host";
        $HOME/bin/movein.sh $host
    done;

elif [ "$MODE" == "local" ]; then
    echo -n "- This will overwrite the remote ~/.bash_local file, continue ? [Y/n] ";
    read line
    if [ "$line" != "Y" ]; then
        echo " + abandoning, you must press 'Y' at the prompt to overwrite files";
        exit 0;
    fi;
    for host in `cat ~/.distrib_hosts`; do
        echo " => Resetting a default ~/.bash_local on $host";
        $SCP ~/.bash_local $host:~
    done;
fi;

echo "DONE.";
exit 0;

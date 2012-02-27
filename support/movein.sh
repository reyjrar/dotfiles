#!/bin/sh

HOST=$1

SSH="/usr/bin/ssh"
SCP="/usr/bin/scp"
RSYNC="/usr/bin/rsync"

# Check the Host
host $HOST &> /dev/null
rc=$?
if [ "$rc" -ne "0" ]; then
    echo "Invalid host: $HOST";
    exit 1;
fi;

# Added to distribution
if [ -f ~/.distrib_hosts ]; then
    grep "$HOST" ~/.distrib_hosts
    rc=$?;

    if [ "$rc" -ne "0" ]; then
        cp ~/.distrib_hosts /tmp/distrib_hosts.$$
        echo $HOST >> /tmp/distrib_hosts.$$
        sort /tmp/distrib_hosts.$$ > ~/.distrib_hosts
        rm /tmp/distrib_hosts.$$
        hosts=`wc -l ~/.distrib_hosts`;
        echo " => Added to ~/.distrib_hosts (now $hosts hosts)"
    fi;
fi;

## Setups
$SSH $HOST "test -d ~/.vimswap"
rc=$?
if [ "$rc" -ne "0" ]; then
    $SSH $HOST "mkdir ~/.vimswap"
    echo "  +--> created ~/.vimswamp";
fi;
$SSH $HOST "test -d ~/.bin"
rc=$?
if [ "$rc" -ne "0" ]; then
    $SSH $HOST "mkdir ~/.bin"
    echo "  +--> created ~/.bin";
fi;

$SCP ~/bin/vcprompt $HOST:~/bin
$SCP ~/bin/dotfiles-install.sh $HOST:~/bin
echo " => Copied Support Scripts";

## Rsync for dotfiles
$RSYNC -a --delete --exclude=.git ~/code/dotfiles -e ssh $HOST:~
echo " => Sync of dotfiles complete, running install"
$SSH $HOST "~/bin/dotfiles-install.sh"
echo " => dotfiles installed."

## bash_local for non-distributed changes
$SSH $HOST "test -f ~/.bash_local"
rc=$?
if [ "$rc" -ne "0" ]; then
    $SCP ~/.bash_local $HOST:~
    echo " => Setting a default ~/.bash_local";
fi;

## Vim Configs
$RSYNC -av --delete ~/.vim -e ssh $HOST:~
echo " => Sync of vim setup complete"

echo "DONE.";
exit 0;

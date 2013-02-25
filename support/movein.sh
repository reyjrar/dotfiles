#!/bin/sh

if [ "$1" == "-l" ]; then
    LOCAL_OVERWRITE=1;
    shift 1;
else
    LOCAL_OVERWRITE=0;
fi;
if [ "$1" == "-n" ]; then
    NO_DNS_CHECK=1;
    shift 1;
fi;

HOST=$1

SSH="/usr/bin/ssh -x"
SCP="/usr/bin/scp"
RSYNC="/usr/bin/rsync"

if [ ${DEBUG:-0} -gt 0 ]; then
    RSYNC_OPTS='-v'
else
    SCP_OPTS='-q'
fi

DIRS="
    .vimswap
    bin
    support
"
function remote_mkdir() {
    local dir=$1
    $SSH $HOST "test -d ~/$dir"
    rc=$?
    if [ "$rc" -ne "0" ]; then
        $SSH $HOST "mkdir ~/$dir"
        echo "  +--> created ~/$dir";
    else
        (( $DEBUG )) && echo " - remote_mkdir($dir) -> directory exists"
    fi;

}


# Check the Host
host $HOST &> /dev/null
rc=$?
if [ -z $NO_DNS_CHECK ] && [ "$rc" -ne "0" ]; then
    echo "Invalid host: $HOST";
    exit 1;
fi;

# Add to distribution
if [ -f ~/.distrib_hosts ]; then
    grep "^$HOST$" ~/.distrib_hosts
    rc=$?;

    if [ "$rc" -ne "0" ]; then
        cp ~/.distrib_hosts /tmp/distrib_hosts.$$
        echo $HOST >> /tmp/distrib_hosts.$$
        sort -u /tmp/distrib_hosts.$$ > ~/.distrib_hosts
        rm /tmp/distrib_hosts.$$
        hosts=`wc -l ~/.distrib_hosts`;
        echo " => Added to ~/.distrib_hosts (now $hosts hosts)"
    fi;
fi;

## Setups
for dir in $DIRS; do
    remote_mkdir $dir;
done

$SCP $SCP_OPTS ~/bin/vcprompt $HOST:~/bin
$RSYNC $RSYNC_OPTS -a --exclude=.git -e ssh ~/support/tmux-powerline $HOST:~/support
$RSYNC $RSYNC_OPTS -ae ssh ~/bin/*.sh $HOST:~/bin
echo " => Copied Support Scripts";

## Rsync for dotfiles
$RSYNC $RSYNC_OPTS -a --delete --exclude=.git ~/dotfiles -e ssh $HOST:~
echo " => Sync of dotfiles complete, running install"
$SSH $HOST "~/bin/dotfiles-install.sh"
echo " => dotfiles installed."

## bash_local for non-distributed changes
if [ $LOCAL_OVERWRITE -eq 0 ]; then
    $SSH $HOST "test -f ~/.bash_local"
    rc=$?
    if [ "$rc" -ne "0" ]; then
        LOCAL_OVERWRITE=1;
    fi;
fi;
if [ $LOCAL_OVERWRITE -eq 1 ]; then
    $SCP $SCP_OPTS ~/.bash_local $HOST:~
    echo " => Setting a default ~/.bash_local";
fi;

## Vim Configs
$RSYNC $RSYNC_OPTS -a --exclude=.git --delete -e ssh ~/.vim $HOST:~
echo " => Sync of vim setup complete"

echo "DONE.";
true;

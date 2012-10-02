# Path Injection
function path_inject() {
    (( $DEBUG )) && echo -n "path_inject( $1 )";
    if [ -d "$1" ]; then
        PATH="$1:$PATH";
        (( $DEBUG )) && echo -n " [FOUND]";
    fi;
    (( $DEBUG )) && echo;
}

function root_login() {
    local timeout=1800;
    local keyActive=`ssh-add -l |grep 'administrator.dsa'|wc -l`;

    local adminKey="$HOME/.ssh/administrator.dsa";

    if [ -f "$adminKey" ] || [ "$keyActive" -gt "0" ]; then

        local hasAgent="$keyActive";
        if [ "$SSH_AUTH_SOCK" ] && [ -e "$SSH_AUTH_SOCK" ]; then
            hasAgent=1;
        fi;

        if [ "$hasAgent" -gt "0" ]; then

            if [ "$keyActive" -eq "0" ]; then
                ssh-add -t $timeout $adminKey;
            fi;

            ssh -l root $*;

        else
            echo ">>> SSH Agent not running";
            ssh -i $adminKey -l root $*;
        fi;
    else
        echo ">>> Admin Key not found: ($adminKey)";
        ssh -l root $*;
    fi;

}

# Figure out how to checksum
type shasum &> /dev/null
if [[ $? -eq 0 ]]; then
    CHECKSUM_PROG=shasum
else
    type sha1sum &> /dev/null
    if [[ $? -eq 0 ]]; then
        CHECKSUM_PROG=sha1sum
    else
        CHECKSUM_PROG=md5sum
    fi
fi
# CACHE UUID
[ -z "$CACHE_UUID" ] && export CACHE_UUID=$(head -1 /dev/urandom |$CHECKSUM_PROG|awk '{print $1}');
# Cache cleaning
find $HOME/.cache -type f -mtime +1 -exec rm -f {} \; &> /dev/null
find $HOME/.cache -type d -empty -exec rmdir -f {} \; &> /dev/null

function cache_reset() {
    if [ -d "$HOME/.cache/$CACHE_UUID" ]; then
        find "$HOME/.cache/$CACHE_UUID" -maxdepth 1 -type f -exec rm -f {} \;
    fi
}

function cache_protected() {
    # Variables
    local check_name=$1
    local check=$2
    local timeout=3600

    # Setup cache directory
    [ ! -d "$HOME/.cache" ] && mkdir "$HOME/.cache";

    # Setup a UUID for this session
    [ ! -d "$HOME/.cache/$CACHE_UUID" ] && mkdir "$HOME/.cache/$CACHE_UUID";

    # Only do this if cache is stale
    cachefile="$HOME/.cache/$CACHE_UUID/$check_name"
    if [ -e "$cachefile" ]; then
        cachetime=$(stat -r $cachefile|awk '{print $9}');
        now=$(date +%s);
        oldest=$(($now - $timeout))
        cachevalue=$(cat $cachefile);
        if [[ $cachetime -gt $oldest ]]; then
            echo $cachevalue;
            return;
        fi
    fi

    # Run the check, get the value
    (($DEBUG)) && echo " + cache_protected() is running '$check'";
    value=$($check 2>/dev/null);
    rc=$?;

    # store the and return
    echo "$rc $value" > $cachefile;
    echo "$rc $value";
}

function ip_is_in() {
    local file=$1

    result=$(cache_protected "get_external_ip" "curl -XGET http://icanhazip.com/")
    ip=$(echo $result|cut -d' ' -f2)

    grep $ip $file &> /dev/null
    rc=$?

    echo $rc;
}

function check_proxy_wrapper() {
    # Set a proxy in the environment variable MY_PROXY
    program="$1"
    args=("$@")
    unset args[0]

    result=$(ip_is_in $HOME/.work_proxies);
    if [ "$result" == "0" ]; then
        (($DEBUG)) && echo " + setting proxies to $MY_PROXY";
        export HTTP_PROXY="http://$MY_PROXY/"
        export http_proxy="http://$MY_PROXY/"
        export https_proxy="https://$MY_PROXY/"
    else
        (($DEBUG)) && echo " + removing proxies";
        unset HTTP_PROXY
        unset http_proxy
        unset https_proxy
    fi

    command $program "${args[@]}";
}

function ssh_check_proxy() {
    result=$(ip_is_in $HOME/.work_proxies);
    if [ "$result" == "0" ]; then
        export SSH_PROXY="int"
    else
        export SSH_PROXY="ext"
    fi
    (($DEBUG)) && echo " + ssh is using $SSH_PROXY proxies";

    command ssh $@
}

function contents() {
    if [ -f "$1" ] && [ -r "$1" ]; then
        file_lines=`wc -l $1 | awk '{print $1}'`;
        rc=$?;
        if [[ $rc -ne 0 ]]; then
            echo "error reading file: $1";
            exit $rc;
        fi;
        if [[ $file_lines -gt $LINES ]]; then
            out=`expr $LINES / 2 - 1`;
            head -$out $1
            echo "::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::";
            tail -$out $1
        else
            cat $1;
        fi;
    else
        ls -lhF --color=auto $1
    fi
}

function send_bash_local() {
    host=$1
    if [ -f ~/.distrib_hosts ]; then
        grep "^$host$" ~/.distrib_hosts &> /dev/null
        rc=$?
        if [[ $rc -ne 0 ]]; then
            echo "!! warning : host $host was not found in ~/.distrib_hosts";
        fi;
    fi;
    /usr/bin/scp .bash_local $host:~
}

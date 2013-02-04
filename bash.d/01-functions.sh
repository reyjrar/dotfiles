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

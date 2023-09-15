# Path Injection
function path_inject() {
    path=$1
    (( $DEBUG )) && echo -n "path_inject( $path )";
    if [ -d "$path" ]; then
        if [[ $PATH =~ (^|:)$path(:|$) ]]; then
            (( $DEBUG )) && echo -n " [PRESENT]";
            newpath="$path";
            for dir in $( echo $PATH | tr ':' "\n" | awk '!x[$0]++' ); do
                [ "$path" == "$dir" ] && continue
                [ ! -d "$dir" ] && continue
                newpath="$newpath:$dir";
            done
            PATH="$newpath"
        else
            PATH="$path:$PATH";
            (( $DEBUG )) && echo -n " [ADDED]";
        fi
    fi;
    (( $DEBUG )) && echo;
}

function ssl_expiry() {
    if [ ! -z "$1" ]; then
        echo "" | openssl s_client -connect "$1" | openssl x509 -noout -dates
    else
        echo "usage: $FUNCNAME host:port";
        return 1;
    fi
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

function _set_win_title() {
    printf "\033]2;$1\007"
}

function tmux_wrapper() {
    version=`tmux -V |cut -d' ' -f 2`

    if [[ "$version" > "1.6" ]]; then
        command tmux -2 new-session -A -s base
    else
        command tmux -2 attach-session -t 0 || tmux new-session
    fi
}

function seconds_til_3am() {
    days="${1:-1}"
    # Check for GNU Compatibility
    date --date today > /dev/null 2>&1
    rc="$?";
    if [ "$rc" -eq "0" ]; then
        date="GNU";
        future=$(date --date "${days} days" +%Y-%m-%d)
        expire_at=$(date --date "$future 03:00:00" +%s);
        expire_seconds=$(($expire_at - $(date +%s)))
    else
        date="BSD";
        expire_at=$(date -j -f "%Y-%m-%dT%H:%M:%S" $(date -v+${days}d +"%Y-%m-%dT03:00:00") +%s)
        expire_seconds=$(($expire_at - $(date -j +%s)))
    fi

    (($DEBUG)) && echo "[$date] expire_seconds=$expire_seconds" >&2
    echo "$expire_seconds";
}

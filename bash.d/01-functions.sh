# Path Injection
function path_inject() {
    (( $DEBUG )) && echo -n "path_inject( $1 )";
    if [ -d "$1" ]; then
        PATH="$1:$PATH";
        (( $DEBUG )) && echo -n " [FOUND]";
    fi;
    (( $DEBUG )) && echo;
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
    printf "\033k$1\033\\"
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
    # Check for GNU Compatibility
    date --date today > /dev/null 2>&1
    rc="$?";
    if [ "$rc" -eq "0" ]; then
        date="GNU";
        expire_at=$(date --date "$(date --date tomorrow +%Y-%m-%d) 3:00:00" +%s);
        expire_seconds=$(($expire_at - $(date +%s)))
    else
        date="BSD";
        expire_at=$(date -j -f "%Y-%m-%dT%H:%M:%S" $(date -v+1d +"%Y-%m-%dT03:00:00") +%s)
        expire_seconds=$(($expire_at - $(date -j +%s)))
    fi

    (($DEBUG)) && echo "[$date] expire_seconds=$expire_seconds" >&2
    echo "$expire_seconds";
}

function fancy_ssh() {
    # Check for SSH_PRIMARY_AUTH_KEY, otherwise use id_rsa
    [ -z "$SSH_PRIMARY_AUTH_KEY" ] && SSH_PRIMARY_AUTH_KEY="$HOME/.ssh/id_rsa";

    # Check host status
    target_host=`command ssh -G "$@" |grep -e ^hostname -e ^port |awk '{print $2}' |xargs echo`
    if [ ! -z "$target_host" ]; then
        nc -w 2 -z $target_host >/dev/null 2>&1
        if [ $? -ne 0 ]; then
            echo "Host is down or not responding: $target_host";
        else
            _set_win_title "$target_host"
        fi
    fi

    if [ -f "$SSH_PRIMARY_AUTH_KEY" ]; then
        expiry="$(seconds_til_3am)"
        (($DEBUG)) && echo "Attempting to load SSH_PRIMARY_AUTH_KEY for $expiry seconds.";
        ssh-add -l > /dev/null || ssh-add -t $expiry "$SSH_PRIMARY_AUTH_KEY"
    fi

    if [ -z "$TMUX" ] && [ -z "$SSH_PLAIN" ]; then
        command ssh -t "$@" "tmux_wrapper || tmux || screen || bash -l"
    else
        [ -z "$SSH_PLAIN" ] && echo -e "[${bldylw}warn${txtrst}] Running tmux locally, skipping tmux on remote side.";
        command ssh "$@"
    fi
}

function batch_ssh() {
    command ssh -o BatchMode=yes -o ConnectTimeout=2 -o StrictHostKeyChecking=no "$@"
}

function update_auth_sock() {
    # From: https://chrisdown.name/2013/08/02/fixing-stale-ssh-sockets-in-tmux.html
    if [ ! -z "$TMUX" ]; then
        local socket_path="$(tmux show-environment | sed -n 's/^SSH_AUTH_SOCK=//p')"

        (($DEBUG)) && echo "[tmux] Fixing SSH_AUTH_SOCK=$socket_path"
        if ! [[ "$socket_path" ]]; then
            echo 'no socket path' >&2
            return 1
        else
            export SSH_AUTH_SOCK="$socket_path"
        fi
    elif [ ! -z "$STY" ]; then
        export SSH_AUTH_SOCK=$(find /tmp -maxdepth 2 -type s -name "agent*" -user $USER -printf '%T@ %p\n' 2>/dev/null |sort -n|tail -1|cut -d' ' -f2)
        (($DEBUG)) && echo "[screen] Fixing SSH_AUTH_SOCK=$SSH_AUTH_SOCK"
    else
        echo "Unable to do anything useful.";
    fi
}

# Configurations for SSH related things

alias ssh="fancy_ssh"
alias ssh-add="fancy_sshadd"
# Don't have SCP setup the ControlMaster because it doesn't setup agent forwarding
alias scp='scp -o ControlMaster=no'
# For the times before signed keys
alias unsafe_ssh='ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no'

# Functions
function fancy_sshadd {
    # No args and we find a key set load it
    if [[ $# == 0 ]] && [[ -f "$SSH_PRIMARY_AUTH_KEY" ]]; then
        if [ -z "$SSH_PRIMARY_AUTH_ID" ]; then
            export SSH_PRIMARY_AUTH_ID="$SSH_PRIMARY_AUTH_KEY"
        fi
        command ssh-add -l | grep "$SSH_PRIMARY_AUTH_ID"
        rc=$?
        # Only if it's not already loaded
        if [[ $rc != 0 ]]; then
            (($DEBUG)) && echo "Attempting to load SSH_PRIMARY_AUTH_KEY for $expiry seconds.";
            command ssh-add -t $(seconds_til_3am) "$SSH_PRIMARY_AUTH_KEY"
        fi
    # Add an expiry to a key automatically
    elif [[ -f "${@: -1}" ]]; then
        command ssh-add -t $(seconds_til_3am) "$@"
    # otherwise, do what I said.
    else
        command ssh-add "$@"
    fi
}

function fancy_ssh() {
    # Check for SSH_PRIMARY_AUTH_KEY, otherwise use id_rsa
    [ -z "$SSH_PRIMARY_AUTH_KEY" ] && SSH_PRIMARY_AUTH_KEY="$HOME/.ssh/id_rsa";

    # Check host status
    if [[ $# != 0 ]]; then
        target_host=`command ssh -G "$@" |grep -e ^hostname -e ^port |awk '{print $2}' |xargs echo`
        if [ ! -z "$target_host" ]; then
            _set_win_title "$target_host"
        fi
    fi

    if [ -f "$SSH_PRIMARY_AUTH_KEY" ]; then
        fancy_sshadd
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

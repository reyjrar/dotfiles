# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# Source global definitions
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# Path Injection
function path_inject() {
    if [ -d "$1" ]; then
        PATH="$1:$PATH";
    fi;
}

path_inject /sbin
path_inject /usr/sbin
path_inject /usr/local/sbin
path_inject /usr/local/bin
path_inject /opt/local/sbin
path_inject /opt/local/bin
path_inject /opt/perl/current/bin
path_inject /usr/pgsql-9.0/bin
path_inject $HOME/bin

export BASHRC=1
export LESS="-RM"

# Operating System Based Decisions
HOSTOS=`uname -s`
if [ "$HOSTOS" == "Darwin" ]; then
    alias ls='gls --time-style=long-iso -F --color'

elif [ "$HOSTOS" == "Linux" ]; then
    alias ls='ls --time-style=long-iso -F --color'
else
    echo "No options specified for this OS($HOSTOS)"
fi;

# User specific aliases and functions
alias who='who -H -u -T'
alias root='root_login';
alias screen="TERM=ansi screen"

#
# Interactive Shells only
if [ "$PS1" ]; then
    stty erase ^?
    shopt -s checkwinsize cdspell dotglob histappend nocaseglob no_empty_cmd_completion cmdhist

    export HISTCONTROL="ignoredups"
    export HISTIGNORE="&:ls:[bf]g:exit"

    if [ "$PROFILED" != "0" ]; then
        . $HOME/.bash_profile
    fi;
fi;

# Perl Brew
if [ -f ~/perl5/perlbrew/etc/bashrc ]; then
     source ~/perl5/perlbrew/etc/bashrc
fi

# Local, non SCM'd settings
if [ -f ~/.bash_local ]; then
     source ~/.bash_local
fi;

#
# For some reason this fjorks things.
unset LS_COLORS

function root_login () {
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
        ls -lh $1
    fi
}



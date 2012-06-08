# .bashrc
export BASHRC=1;

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# Source global definitions
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
elif [ -f /opt/local/etc/bash_completion ]; then
    . /opt/local/etc/bash_completion
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
path_inject /var/ossec/bin
path_inject /opt/perl/current/bin
path_inject /usr/pgsql-9.1/bin
path_inject /usr/pgsql-9.0/bin
path_inject $HOME/bin


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
export LESS="-RM"
alias c="contents"

#
# Interactive Shells only
if [ "$PS1" ]; then
    stty erase ^?
    shopt -s checkwinsize cdspell dotglob histappend nocaseglob no_empty_cmd_completion cmdhist

    export HISTCONTROL="ignoredups"
    export HISTIGNORE="&:ls:[bf]g:exit"
    unset LS_COLORS

    # Perl Brew
    if [ -f ~/perl5/perlbrew/etc/bashrc ]; then
         source ~/perl5/perlbrew/etc/bashrc
    fi

    # Local, non SCM'd settings
    if [ -f ~/.bash_local ]; then
         source ~/.bash_local
    fi;

fi;



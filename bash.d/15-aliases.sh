# User specific aliases and functions
alias who='who -H -u -T'
alias c="contents"
# Get Aliases
alias gg='git grep'

# Hive
command -v rlwrap &> /dev/null
rc=$?
if [[ "$rc" -eq "0" ]]; then
        alias rlhive='rlwrap -i --prompt-colour=yellow -f ~/.hive_completion -a hive $*'
fi;

if [ "$HOSTOS" == "OpenBSD" ] || [ "$HOSTOS" == "FreeBSD" ]; then
    if [ -x "/usr/local/bin/gls" ]; then
        alias ls='gls --time-style=long-iso -F --color'
    else
        alias ls="ls -F"
    fi
else
    alias ls='ls --time-style=long-iso -F --color'
fi


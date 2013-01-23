# Command Aliases
case "$HOSTOS" in
    "Darwin")
        alias ls='gls --time-style=long-iso -F --color'
        ;;
    "Linux")
        alias ls='ls --time-style=long-iso -F --color'
        ;;
esac;

# User specific aliases and functions
alias who='who -H -u -T'
alias root='root_login'
alias c="contents"
# Get Aliases
alias gg='git grep'

# Hive
command -v rlwrap &> /dev/null
rc=$?
if [[ "$rc" -eq "0" ]]; then
        alias rlhive='rlwrap -i --prompt-colour=yellow -f ~/.hive_completion -a hive $*'
fi;

# Some commands can be customized with ENV Variables
export LESS="-RM"


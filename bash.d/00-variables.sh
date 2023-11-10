# Shell Variables
EDITOR="vim"
LANG="en_US.UTF-8"
LC_TIME="C"
HOSTOS=$(uname -s)

case "$HOSTOS" in
    "Darwin"    ) PLATFORM="mac";;
    *           ) PLATFORM="linux";;
esac

export LESS="-RM"
export EDITOR LANG LC_TIME HOSTOS PLATFORM
unset USERNAME
unset LS_COLORS

if [ -f "$HOME/.bash_variables" ];  then
    . "$HOME/.bash_variables"
fi

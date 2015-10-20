# Shell Variables
EDITOR="vim"
LC_ALL="en_US.UTF-8"
HOSTOS=`uname -s`

case "$(uname -s)" in
    "Darwin"    ) PLATFORM="mac";;
    *           ) PLATFORM="linux";;
esac

export LESS="-RM"
export EDITOR LC_ALL HOSTOS PLATFORM
unset USERNAME
unset LS_COLORS

if [ -f "$HOME/.bash_variables" ];  then
    . "$HOME/.bash_variables"
fi

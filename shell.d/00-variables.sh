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
export ITERM_BGCOLOR="light"
unset USERNAME
unset LS_COLORS

for vars in "$HOME/.shell_variables" "$HOME/.${shell_name}_variables"; do
    [ -f "$vars" ] && . "$vars"
done

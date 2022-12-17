# GPG Configuration

if [ "$HOSTOS" == "Darwin" ]; then
    export GPG_TTY=$(tty)
fi

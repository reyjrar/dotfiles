# Set window titles for each bash command
case $TERM in
     rxvt|*term)
        set -o functrace
        trap 'echo -ne "\e]0;$BASH_COMMAND\007"' DEBUG
        export PS1="\e]0;$TERM\007$PS1"
     ;;
esac

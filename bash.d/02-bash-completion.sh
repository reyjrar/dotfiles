# Source global definitions
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
elif [ -f /opt/local/etc/bash_completion ]; then
    . /opt/local/etc/bash_completion
else
    echo "[notify] - bash completion disabled"
fi

shopt -s no_empty_cmd_completion

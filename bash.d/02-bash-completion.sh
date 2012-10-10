# Source global definitions
if [ -f /etc/bash_completion ]; then
    # Linux
    . /etc/bash_completion
elif [ -f /opt/local/etc/profile.d/bash_completion.sh ]; then
    # MacPorts 2.1.2
    . /opt/local/etc/profile.d/bash_completion.sh
elif [ -f /opt/local/etc/bash_completion ]; then
    # MacPorts prior to 2.1.2
    . /opt/local/etc/bash_completion
fi

shopt -s no_empty_cmd_completion

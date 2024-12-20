# Source global definitions

COMPLETION_SCRIPTS="
    /etc/bash_completion
    /usr/local/share/bash-completion/bash_completion.sh
    /opt/local/etc/bash_completion
    /opt/local/etc/profile.d/bash_completion.sh
    /etc/bash_completion.d/git
    $HOMEBREW_PREFIX/etc/bash_completion
    $HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh
"

for file in $COMPLETION_SCRIPTS; do
    if [ -f $file ]; then
        (($DEBUG)) && echo "bash_completion: sourcing $file";
        . $file
    fi
done

shopt -s no_empty_cmd_completion

#!/bin/sh

GIT_CONTRIB="/usr/share/git-core/contrib/completion/git-prompt.sh
            /opt/local/share/git/git-prompt.sh
            /opt/local/share/git-core/git-prompt.sh
"

for file in $GIT_CONTRIB; do
    if [ -f $file ]; then
        (($DEBUG)) && echo "git: sourcing $file";
        . $file
        export GIT_PS1_SHOWUPSTREAM="auto" \
               GIT_PS1_SHOWCOLORHINTS=true \
               GIT_PS1_SHOWDIRTYSTATE=true \
               GIT_PS1_SHOWUNTRACKEDFILES=true
    fi
done

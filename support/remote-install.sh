#!/bin/sh

if [ ! -z "$DO_INSTALL" ] || [ ! -L ~/.bash.d ]; then
    cd ~/dotfiles;
    ./bin/install.sh
fi;

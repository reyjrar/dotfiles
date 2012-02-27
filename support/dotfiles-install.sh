#!/bin/sh

if [ ! -L ~/.bashrc ]; then
    cd ~/dotfiles;
    ./bin/install.sh
fi;

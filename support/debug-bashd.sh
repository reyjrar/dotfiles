#!/bin/sh

# Script to debug the ordering and execution of bashrc stuff
for i in ~/.bash.d/*.sh; do
    bash -x $i;
    echo "STATUS: $?";
    read;
done

#!/bin/sh

if ssh-add -l &> /dev/null; then
    exit 0
fi

echo "ssh-agent has no identities, use ssh-add to add them"
exit 1

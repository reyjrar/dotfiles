#!/bin/sh
#

if !git rev-parse --is-inside-work-tree &> /dev/null; then
    echo "[$(basename "$0")] Not in a git repository"
    exit 0
fi

for branch in 'develop' 'main' 'master'; do
    if git rev-parse --verify "$branch" &> /dev/null; then
        against="origin/$branch"
        break
    fi
done

if [ -z "${branch:x}" ]; then
    echo "[$(basename "$0")] Couldn't determine a branch to rebase against"
    exit 1
fi
git fetch origin --tags --prune
git rebase -i "$against"

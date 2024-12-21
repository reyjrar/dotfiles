# ZSH Profile
#--------------

# Enable Debugging in the Shell with =1
DEBUG=0

if [[ -o interactive ]]; then
    # Interactive session, load ALL THE THINGS!
    set -u
    for rc in ~/.shell.d/*.sh; do
        file=$(basename "$rc")
        [[ $file == 99* ]] && continue
        (( $DEBUG )) && echo "rc loading '$rc'";
        source $rc;
    done;
    for rc in ~/.zsh.d/*.sh; do
        (( $DEBUG )) && echo "rc loading '$rc'";
        source $rc;
    done;
    for rc in ~/.shell.d/9*.sh; do
        (( $DEBUG )) && echo "rc loading '$rc'";
        source $rc;
    done;
    (( $DEBUG )) && echo "Loaded fully interactive."
else
    # Non-interactive, sparse load
    for rc in ~/.shell.d/{0,9}*.sh; do
        (( $DEBUG )) && echo "rc loading '$rc'";
        source $rc;
    done;
fi;

# Clear any bad RC's
true;
# vim:ft=sh

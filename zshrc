# ZSH Profile
#--------------
skip_global_compinit=1

# Enable Debugging in the Shell with =1
DEBUG=0

if [[ -o interactive ]]; then
    # Interactive session, load ALL THE THINGS!
    set -u
    for shell in 'shell' 'zsh'; do
        for rc in ~/.${shell}.d/*.sh; do
            file=$(basename "$rc")
            (( $DEBUG )) && echo "rc loading '${shell}.d/$rc'";
            source $rc;
        done;
    done
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

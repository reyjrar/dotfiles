# Bash Profile
#--------------

# Enable Debugging in the Shell with =1
DEBUG=0
# Source .bashrc for interactive shells
INTERACTIVE=0
case $- in *i*) INTERACTIVE=1;; esac

if [ $INTERACTIVE -eq 1 ]; then
    # Interactive session, load ALL THE THINGS!
    shopt -s nullglob
    for shell in 'shell' 'bash'; do
        for i in $(seq 0 9); do
            for rc in ~/.${shell}.d/${i}*.sh; do
                file=$(basename "$rc")
                (( $DEBUG )) && echo "rc loading '${shell}.d/$rc'";
                source $rc;
            done
        done 2> /dev/null
    done
    shopt -u nullglob
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

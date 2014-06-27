# Bash Profile
#--------------

# Enable Debugging in the Shell with =1
DEBUG=0
# Source .bashrc for interactive shells
INTERACTIVE=0
case $- in *i*) INTERACTIVE=1;; esac

if [ $INTERACTIVE -eq 1 ]; then
    # Interactive session, load ALL THE THINGS!
    for rc in ~/.bash.d/*.sh; do
        (( $DEBUG )) && echo "rc loading '$rc'";
        source $rc;
    done;
    (( $DEBUG )) && echo "Loaded fully interactive."
else
    # Non-interactive, sparse load
    source ~/.bash.d/00-system-defaults.sh
    source ~/.bash.d/00-variables.sh
    source ~/.bash.d/01-functions.sh
    source ~/.bash.d/02-base-paths.sh
    source ~/.bash.d/15-aliases.sh
fi;

# Clear any bad RC's
true;
# vim:ft=sh

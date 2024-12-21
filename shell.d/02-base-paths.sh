# Basic Path Injections
path_inject /bin
path_inject /usr/bin
path_inject /sbin
path_inject /usr/sbin
path_inject /usr/local/sbin
path_inject /usr/local/bin
path_inject /opt/local/sbin
path_inject /opt/local/bin
path_inject /var/ossec/bin
path_inject $HOME/bin
path_inject $HOME/.local/bin

# CDPATH is freaking magic
if [ -z "$CDPATH" ]; then
    export CDPATH=".:~/code/CPAN:~/code"
fi

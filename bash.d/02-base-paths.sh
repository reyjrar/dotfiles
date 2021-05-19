# Basic Path Injections
path_inject /sbin
path_inject /usr/sbin
path_inject /usr/local/sbin
path_inject /usr/local/bin
path_inject /opt/local/sbin
path_inject /opt/local/bin
path_inject /opt/local/libexec/gnubin
path_inject /opt/android/sdk/tools
path_inject /opt/android/sdk/platform-tools
path_inject /var/ossec/bin
path_inject /opt/perl/current/bin
path_inject /usr/pgsql-9.3/bin
path_inject /usr/pgsql-9.4/bin
path_inject $HOME/bin

# CDPATH is freaking magic
export CDPATH="$CDPATH:.:~/code/CPAN:/sandbox/$USER:~/sandbox"

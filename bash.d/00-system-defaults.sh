# Pull in the system-wide defaults
if [ -f /opt/local/etc/bashrc ]; then
    . /opt/local/etc/bashrc
elif [ -f /etc/bashrc ]; then
    . /etc/bashrc
else
    echo "[ERROR] Failed to find relevant system wide settings !!!"
fi

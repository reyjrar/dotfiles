# Pull in the system-wide defaults
BASHRC=("/opt/local/etc/bashrc" "/etc/bashrc")

## Fix ulimit
if command -v ulimit &> /dev/null; then
    minimum_ulimit=8192;
    if [ "$(ulimit -n)" -lt "$minimum_ulimit" ]; then
        ulimit -n "$minimum_ulimit"
    fi
fi

for bashrc in "${BASHRC[@]}"; do
    if [ -f "$bashrc" ]; then
        . $bashrc
        (( $DEBUG )) && echo "Loaded system settings: $bashrc"
        break;
    fi
done

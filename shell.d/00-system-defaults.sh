# Pull in the system-wide defaults
export shell_name=$(basename "$SHELL")
sysShellRC=("/opt/local/etc/${shell_name}rc" "/usr/local/etc/${shell_name}rc" "/etc/${shell_name}/rc")

## Fix ulimit
if command -v ulimit &> /dev/null; then
    minimum_ulimit=8192;
    if [ "$(ulimit -n)" -lt "$minimum_ulimit" ]; then
        ulimit -n "$minimum_ulimit"
    fi
fi

for shellrc in "${sysShellRC[@]}"; do
    if [ -f "$shellrc" ]; then
        . "$shellrc"
        (( $DEBUG )) && echo "Loaded system settings: $shellrc"
        break;
    fi
done

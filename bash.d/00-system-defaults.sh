# Pull in the system-wide defaults
BASHRC=("/opt/local/etc/bashrc" "/etc/bashrc")

for bashrc in "${BASHRC[@]}"; do
    if [ -f "$bashrc" ]; then
        . $bashrc
        (( $DEBUG )) && echo "Loaded system settings: $bashrc"
        break;
    fi
done

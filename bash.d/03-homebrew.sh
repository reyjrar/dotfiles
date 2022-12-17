if [ -x "/opt/homebrew/bin/brew" ]; then
    # Set Paths
    path_inject /opt/homebrew/bin
    eval "$(/opt/homebrew/bin/brew shellenv)"

    # Inject gnubins therein
    for path in /opt/homebrew/opt/*/libexec/gnubin; do
        path_inject "$path"
    done

    [[ -r "/opt/homebrew/etc/profile.d/bash_completion.sh" ]] && . "/opt/homebrew/etc/profile.d/bash_completion.sh"
fi

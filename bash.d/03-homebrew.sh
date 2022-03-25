if [ -x "/opt/homebrew/bin/brew" ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"

    # Homebrew bin
    path_inject /opt/homebrew/bin
    # Inject gnubins therein
    for path in /opt/homebrew/opt/*/libexec/gnubin; do
        path_inject "$path"
    done
fi


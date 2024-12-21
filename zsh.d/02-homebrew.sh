# homebrew GNU paths
if hash brew &> /dev/null; then
    # Inject gnubins therein
    for dir in $(brew --prefix)/opt/*/libexec/gnubin; do
        path_inject "$dir"
    done
fi

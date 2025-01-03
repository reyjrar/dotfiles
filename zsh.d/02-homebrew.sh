# homebrew GNU paths
if [ -n "${HOMEBREW_PREFIX+x}" ]; then
    path_inject "$HOMEBREW_PREFIX/bin"
    path_inject "$HOMEBREW_PREFIX/sbin"
    # Inject gnubins therein
    for dir in $HOMEBREW_PREFIX/opt/*/libexec/gnubin; do
        path_inject "$dir"
    done
fi

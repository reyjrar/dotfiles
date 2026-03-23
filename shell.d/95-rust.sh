#vim:ft=sh
if [ -f "$HOME/.cargo/env" ]; then
    . "$HOME/.cargo/env"
fi
path_inject "$HOME/.cargo/bin"

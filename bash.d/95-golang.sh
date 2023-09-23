# Golang Setup
if [ -d "$HOME/go" ]; then
    export GOPATH="$HOME/go"
    export GOBIN="$GOPATH/bin"
    path_inject "$GOBIN"

    # Go completions
    if command -v gocomplete &> /dev/null; then
        complete -C gocomplete go
    fi
fi

# Golang Setup
if [ -d "$HOME/go" ]; then
    export GOPATH="$HOME/go"
    export GOBIN="$GOPATH/bin"
    path_inject "$GOBIN"
fi

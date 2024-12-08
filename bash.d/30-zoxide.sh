if hash zoxide &> /dev/null; then
    eval "$(zoxide init bash)"

    alias cd=z
fi

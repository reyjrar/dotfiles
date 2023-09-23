brew_install_dir="/opt/homebrew"
if [ -x "$brew_install_dir/bin/brew" ]; then
    # Set Paths
    path_inject "$brew_install_dir/bin"
    eval "$($brew_install_dir/bin/brew shellenv)"

    # Inject gnubins therein
    for path in $brew_install_dir/opt/*/libexec/gnubin; do
        path_inject "$path"
    done

    for p in "bash_completion.sh" "z.sh"; do
        profile="$brew_install_dir/etc/profile.d/$p"
        [[ -r "$profile" ]] && . "$profile"
    done
fi

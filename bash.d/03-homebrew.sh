for dir in "/opt/homebrew" "$HOME/homebrew"; do
    if [ -d "$dir" ]; then
        brew_install_dir="$dir"
    fi
done

(($DEBUG)) && echo "brew_install_dir=$brew_install_dir"

if [ -n "$brew_install_dir" ] && [ -x "$brew_install_dir/bin/brew" ]; then
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

    # Load Latest PgSQL paths
    pgsqls=($(compgen -G "$brew_install_dir/opt/postgresql@*"))
    if [ "${#pgsqls}" -gt 0  ]; then
        latest_pgsql="${pgsqls[1]}"
        if [ -n "$latest_pgsql" ]; then
            path_inject "$latest_pgsql/bin"
        fi
    fi
fi

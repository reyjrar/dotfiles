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

    # Completions
    hbcomp="$brew_install_dir/etc/profile.d/bash_completion.sh"
    [ -r "$hbcomp" ] && . "$hbcomp"

    # Inject gnubins therein
    for dir in $brew_install_dir/opt/*/libexec/gnubin; do
        path_inject "$dir"
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

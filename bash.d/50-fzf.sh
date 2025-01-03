# Load FZF if available
fzf_dirs="
$HOMEBREW_PREFIX/opt/fzf/shell
/opt/local/share/fzf/shell
/usr/local/share/examples/fzf/shell
/usr/share/fzf/shell
"
for dir in $fzf_dirs; do
    if [ -d "$dir" ]; then
        for file in $dir/*.bash; do
            . $file
        done
    fi
done
